#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "net/http"
require "tempfile"
require "time"
require "uri"
require "yaml"

ROOT = File.expand_path("..", __dir__)
PUBLICATIONS_PATH = File.join(ROOT, "_data", "publications.yml")
METRICS_PATH = File.join(ROOT, "_data", "publication_metrics.yml")
USER_AGENT = "ChenruiMaHomepageMetrics/1.0 (https://merry7cherry.github.io/)"

class MetricsError < StandardError; end

def normalize_title(title)
  title.to_s.downcase.gsub(/[^a-z0-9]+/, " ").strip
end

def request_json(uri, request, attempts: 5)
  tries = 0
  response = nil
  begin
    tries += 1
    response = nil
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.open_timeout = 15
    http.read_timeout = 30
    response = http.request(request)

    if response.code.to_i == 429 || response.code.to_i >= 500
      raise MetricsError, "#{uri.host} returned HTTP #{response.code}"
    end
    unless response.is_a?(Net::HTTPSuccess)
      raise MetricsError, "#{uri.host} returned HTTP #{response.code}: #{response.body.to_s[0, 200]}"
    end

    JSON.parse(response.body)
  rescue MetricsError, Net::OpenTimeout, Net::ReadTimeout, SocketError, Errno::ECONNRESET => error
    raise error if tries >= attempts

    retry_after = response&.[]("Retry-After").to_s.to_i
    delay = retry_after.positive? ? [retry_after, 60].min : [2**tries, 30].min
    warn "#{error.message}; retrying in #{delay}s (attempt #{tries + 1}/#{attempts})"
    sleep(delay)
    retry
  end
end

def guard_metric_change!(paper_id, metric_name, previous, current)
  return if previous.nil? || ENV["ALLOW_METRIC_ANOMALIES"] == "1"

  if current < previous
    raise MetricsError, "#{paper_id} #{metric_name} decreased from #{previous} to #{current}; review before accepting"
  end

  threshold = [10, (previous * 0.5).ceil].max
  if current - previous > threshold
    raise MetricsError, "#{paper_id} #{metric_name} increased unusually from #{previous} to #{current}; review before accepting"
  end
end

def refresh_citations(publications, existing, checked_at)
  configured = publications.select { |paper| paper.dig("metrics", "semantic_scholar_id") }
  return {} if configured.empty?

  api_key = ENV.fetch("SEMANTIC_SCHOLAR_API_KEY", "").strip
  if ARGV.include?("--require-semantic-scholar-key") && api_key.empty?
    raise MetricsError, "SEMANTIC_SCHOLAR_API_KEY is required for the scheduled refresh"
  end

  fields = "paperId,title,citationCount,url"
  uri = URI("https://api.semanticscholar.org/graph/v1/paper/batch?fields=#{fields}")
  request = Net::HTTP::Post.new(uri)
  request["Content-Type"] = "application/json"
  request["User-Agent"] = USER_AGENT
  request["x-api-key"] = api_key unless api_key.empty?
  request.body = JSON.generate("ids" => configured.map { |paper| paper.dig("metrics", "semantic_scholar_id") })
  records = request_json(uri, request)
  raise MetricsError, "Semantic Scholar returned an unexpected response" unless records.is_a?(Array) && records.length == configured.length

  configured.each_with_index.each_with_object({}) do |(paper, index), output|
    record = records[index]
    paper_id = paper.fetch("id")
    semantic_id = paper.dig("metrics", "semantic_scholar_id")
    raise MetricsError, "Semantic Scholar did not return #{paper_id}" unless record.is_a?(Hash)
    raise MetricsError, "Semantic Scholar ID mismatch for #{paper_id}" unless record["paperId"] == semantic_id
    unless normalize_title(record["title"]) == normalize_title(paper["title"])
      raise MetricsError, "Semantic Scholar title mismatch for #{paper_id}: #{record['title'].inspect}"
    end

    count = record["citationCount"]
    raise MetricsError, "invalid citation count for #{paper_id}" unless count.is_a?(Integer) && count >= 0
    previous = existing.dig("publications", paper_id, "citations", "count")
    guard_metric_change!(paper_id, "citations", previous, count)
    output[paper_id] = {
      "count" => count,
      "url" => "https://www.semanticscholar.org/paper/#{semantic_id}",
      "updated_at" => checked_at
    }
  end
end

def refresh_stars(publications, existing, checked_at)
  token = ENV.fetch("GITHUB_TOKEN", "").strip
  configured = publications.select { |paper| paper.dig("metrics", "github_repo") }

  configured.each_with_object({}) do |paper, output|
    paper_id = paper.fetch("id")
    repository = paper.dig("metrics", "github_repo")
    uri = URI("https://api.github.com/repos/#{repository}")
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/vnd.github+json"
    request["User-Agent"] = USER_AGENT
    request["X-GitHub-Api-Version"] = "2022-11-28"
    request["Authorization"] = "Bearer #{token}" unless token.empty?
    record = request_json(uri, request)

    unless record["full_name"].to_s.downcase == repository.downcase
      raise MetricsError, "GitHub repository mismatch for #{paper_id}: #{record['full_name'].inspect}"
    end
    count = record["stargazers_count"]
    raise MetricsError, "invalid Star count for #{paper_id}" unless count.is_a?(Integer) && count >= 0
    previous = existing.dig("publications", paper_id, "stars", "count")
    guard_metric_change!(paper_id, "Stars", previous, count)
    output[paper_id] = {
      "count" => count,
      "url" => record.fetch("html_url"),
      "updated_at" => checked_at
    }
  end
end

def validate_metrics!(publications, metrics)
  raise MetricsError, "publication metrics must be a mapping" unless metrics.is_a?(Hash)
  raise MetricsError, "checked_at must use YYYY-MM-DD" unless metrics["checked_at"].to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/)
  entries = metrics["publications"]
  raise MetricsError, "publication metrics entries must be a mapping" unless entries.is_a?(Hash)

  papers_by_id = publications.to_h { |paper| [paper.fetch("id"), paper] }
  unknown = entries.keys - papers_by_id.keys
  raise MetricsError, "metrics contain unknown publications: #{unknown.join(', ')}" unless unknown.empty?

  publications.each do |paper|
    paper_id = paper.fetch("id")
    entry = entries[paper_id] || {}
    if paper.dig("metrics", "semantic_scholar_id")
      citation = entry["citations"]
      raise MetricsError, "missing citations for #{paper_id}" unless citation.is_a?(Hash)
      raise MetricsError, "invalid citations for #{paper_id}" unless citation["count"].is_a?(Integer) && citation["count"] >= 0
      unless citation["url"].to_s.start_with?("https://www.semanticscholar.org/paper/")
        raise MetricsError, "invalid Semantic Scholar URL for #{paper_id}"
      end
    elsif entry.key?("citations")
      raise MetricsError, "#{paper_id} has citations without a locked Semantic Scholar ID"
    end

    if paper.dig("metrics", "github_repo")
      stars = entry["stars"]
      raise MetricsError, "missing Stars for #{paper_id}" unless stars.is_a?(Hash)
      raise MetricsError, "invalid Stars for #{paper_id}" unless stars["count"].is_a?(Integer) && stars["count"] >= 0
      raise MetricsError, "invalid GitHub URL for #{paper_id}" unless stars["url"].to_s.start_with?("https://github.com/")
    elsif entry.key?("stars")
      raise MetricsError, "#{paper_id} has Stars without a configured GitHub repository"
    end
  end
end

def write_metrics(metrics)
  Tempfile.create(["publication_metrics", ".yml"], File.dirname(METRICS_PATH)) do |file|
    file.write(YAML.dump(metrics))
    file.flush
    file.close
    File.rename(file.path, METRICS_PATH)
  end
end

begin
  publications = YAML.safe_load(File.read(PUBLICATIONS_PATH))
  existing = YAML.safe_load(File.read(METRICS_PATH))
  raise MetricsError, "publication data must be an array" unless publications.is_a?(Array)

  if ARGV.include?("--check")
    validate_metrics!(publications, existing)
    puts "publication metrics check passed"
    exit 0
  end

  unknown_arguments = ARGV - ["--require-semantic-scholar-key"]
  raise MetricsError, "unknown arguments: #{unknown_arguments.join(' ')}" unless unknown_arguments.empty?

  checked_at = Time.now.utc.strftime("%Y-%m-%d")
  citations = refresh_citations(publications, existing, checked_at)
  stars = refresh_stars(publications, existing, checked_at)

  entries = {}
  publications.each do |paper|
    paper_id = paper.fetch("id")
    entry = {}
    entry["citations"] = citations[paper_id] if citations.key?(paper_id)
    entry["stars"] = stars[paper_id] if stars.key?(paper_id)
    entries[paper_id] = entry unless entry.empty?
  end

  updated = {"checked_at" => checked_at, "publications" => entries}
  validate_metrics!(publications, updated)
  write_metrics(updated)
  puts "publication metrics refreshed for #{entries.length} publications"
rescue MetricsError => error
  warn "publication metrics refresh failed: #{error.message}"
  exit 1
end
