---
layout: default
---

<style>
/* 移动端优化样式 */
@media screen and (max-width: 768px) {
  /* 调整flex容器在移动端的布局 */
  div[style*="display: flex"] {
    flex-direction: column !important;
  }
  
  /* 确保图片在移动端占满宽度 */
  div[style*="display: flex"] img {
    width: 100% !important;
    max-width: 100% !important;
    margin-right: 0 !important;
  }
  
  /* 文本内容的最小宽度调整 */
  div[style*="min-width: 250px"] {
    min-width: 100% !important;
    margin-top: 0 !important;
  }
}

/* 防止图片加载时的抖动 */
img {
  aspect-ratio: attr(width) / attr(height);
}

.mentor-name {
  color: #ff9500;
}

.education-list {
  margin: 0 0 10px;
}

.education-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  line-height: 1.5;
  min-height: 84px;
}

.education-item + .education-item {
  margin-top: 14px;
}

.education-logo {
  width: 28px;
  height: 28px;
  object-fit: contain;
  border-radius: 4px;
  flex: 0 0 28px;
}

.education-item-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
  line-height: 1.5;
}
</style>

Hi, here is Chenrui's homepage, welcome 👋! 

I will be joining the [University of Virginia](https://www.virginia.edu/) as a Ph.D. student in Computer Science, where I will be affiliated with the [RAISE Lab](https://nandofioretto.github.io/group/) and advised by <a class="mentor-name" href="https://nandofioretto.github.io/">Prof. Ferdinando Fioretto</a>. Currently, I am a Master's student at the [University of California, Irvine](https://uci.edu/), working as a Research Assistant in the [Trustworthy ML/AI Group](https://sites.google.com/uci.edu/yanning-shen/group?authuser=0) at UCI, advised by <a class="mentor-name" href="https://sites.google.com/uci.edu/yanning-shen/home?authuser=0">Prof. Yanning Shen</a>. I am also a student collaborator at [Oak Ridge National Laboratory](https://education.ornl.gov/graduate/).
I received my bachelor's degree from [Central South University (中南大学)](https://www.usnews.com/education/best-global-universities/central-south-university-501467). During my senior year, I studied as an exchange student at the [University of California, Irvine](https://uci.edu/), where I completed my undergraduate thesis and graduate-level coursework.


## 🌟 Research Interests

- **Generative Modeling & Algorithmic Foundations**:  
  Research focuses on advanced generative models, including diffusion/flow models, autoregressive models, and VAEs, with an emphasis on the **mathematical and algorithmic foundations** of generation, aiming to improve controllability, robustness, and generalization for real-world data. A key direction is the development of **efficient generative methods**, these methods aim to fundamentally reduce inference and training cost while preserving or improving fidelity, providing theoretically grounded solutions for scalable and fast generation.

- **Multi-modal and Physically-Aware Understanding and Generation**:  
  Research also covers **multi-modal understanding and generation** for images, videos, 3D data, and vision–language tasks, motivating to solve the multi-modal collaboration and cross-modal alignment. Longer-term interests include incorporating **physical structure, dynamics, and causal constraints** into generative models, moving toward physically consistent, trustworthy AI systems deployed in realistic environments.

- **Fairness and Trustworthy Representation Learning**:  
  Another line of work studies the interaction between generative models, representation learning, and **fairness**, enabling both generative and downstream tasks to behave reliably and ethically across diverse populations and data distributions.



<div class="announcement-banner">
  📢 I am seeking a summer internship focused on generative and multimodal understanding models for real-world data, including images and videos. I am highly motivated to tackle challenges in generation, perception, reasoning, and efficiency. Feel free to <a href="mailto:chenrum@uci.edu">reach out</a>!
</div>


## 📫 Contact
Email: [zzz8fa@virginia.edu](mailto:zzz8fa@virginia.edu) and [chenrum@uci.edu](mailto:chenrum@uci.edu)  
Location: Irvine, California, USA  
My Chinese name is 马晨睿.


## 📰 News
- [2026-02] Our work [Learning Straight Flows: Variational Flow Matching for Efficient Generation](https://arxiv.org/abs/2511.17583) is accepted to CVPR 2026 main conference.
- [2026-01] Our work [CTR-LoRA: Curvature-Aware and Trust-Region Guided Low-Rank Adaptation for Large Language Models](https://arxiv.org/abs/2510.15962) is accepted to ICASSP 2026.
- [2025-11] Exited to receive AAAI-26 Scholarship ($1000), Thanks AAAI!
- [2025-11] Our work [CAD-VAE: Leveraging Correlation-Aware Latents for Comprehensive Fair Disentanglement](https://arxiv.org/abs/2503.07938) is accepted to AAAI 2026 main track.
- [2025-11] Our work [Self-Supervised Visual Prompting for Cross-Domain Road Damage Detection](https://arxiv.org/abs/2511.12410) is accepted to WACV 2026.


## 📝 Publications

<div class="section-header">
  <span style="font-size: 0.9em; color: #6b7280;">(* denotes equal contribution)</span>
  <div class="view-toggle">
    <button id="selectedBtn" class="active">Selected</button>
    <button id="allBtn">All Publications</button>
  </div>
</div>

<div id="publicationsList" class="publications-list">
  <!-- Publications will be loaded here dynamically -->
</div>

## 🎓 Education
<div class="education-list">
  <div class="education-item">
    <img class="education-logo" src="{{ '/img/uva-logo.svg' | relative_url }}" alt="University of Virginia">
    <div class="education-item-content">
      <strong>University of Virginia</strong>
      <em>Doctor of Philosophy in Computer Science</em>
      <span>August 2026 – June 2030 (Expected)</span>
    </div>
  </div>
  <div class="education-item">
    <img class="education-logo" src="{{ '/img/uci-logo.svg' | relative_url }}" alt="University of California, Irvine">
    <div class="education-item-content">
      <strong>University of California, Irvine</strong>
      <em>Master of Science in Computer Science</em>
      <span>September 2025 – June 2026 (Expected)</span>
      <span>GPA: 4.00/4.00</span>
    </div>
  </div>
  <div class="education-item">
    <img class="education-logo" src="{{ '/img/uci-logo.svg' | relative_url }}" alt="University of California, Irvine">
    <div class="education-item-content">
      <strong>University of California, Irvine</strong>
      <em>Exchange Student (UCI 3+2 Engineering program) in Computer Science</em>
      <span>September 2024 – June 2025</span>
      <span>GPA: 3.92/4.00</span>
    </div>
  </div>
  <div class="education-item">
    <img class="education-logo" src="{{ '/img/csu-logo.svg' | relative_url }}" alt="Central South University">
    <div class="education-item-content">
      <strong>Central South University</strong>
      <em>Bachelor of Science in Computer Science</em>
      <span>September 2021 – June 2025</span>
      <span>Grade: 86.8%, Rank: Top 35%</span>
    </div>
  </div>
</div>


## 💼 Experience
- **Research Assistant**  
  *Trustworthy ML/AI Group @ UCI*  
  September 2024 – Present  
  - Developed advanced algorithms and models for generative modeling, understanding, and reasoning, with applications in computer vision and vision-language models.
  - Proposed novel generative theory/algorithms for efficiency (one-step generation, multi-stage generation).
  - Designed methods to address challenges of fairness in generative models and representation learning.

- **Teaching Assistant**  
  *University of California, Irvine*  
  January 2026 – March 2026  
  - Assist the professor with teaching and grading, and organize course discussions.

- **Student Collaborator (remote)**  
  *Oak Ridge National Laboratory*  
  May 2025 – Present  
  - Engineered generative and understanding models with a focus on improving efficiency and performance.

  
## 🏅 Awards
- **Computer Science Scholar Fellowship**  
  University of Virginia, February 2026  

- **AAAI-2026 Scholarship**  
  Singapore, November 2025  

- **University-level Second Prize Scholarship (Top 20%)**  
  Central South University, September 2024

- **University-level Third Prize Scholarship (Top 30%)**  
  Central South University, September 2023

- **21st China Undergraduate Mathematical Competition in Modeling**  
  Changsha, Hunan, China, September 2023  
  National Second Prize, Top 15% nationwide.

- **4th National College Student Mathematical Modeling Competition**  
  Changsha, Hunan, China, July 2023  
  National First Prize, Top 5% nationwide.


## 📍 Professional Services
- **Conference Reviewer**: CVPR 2026, AAAI 2026
- TA for **UCI EECS 298: Networked System**, Spring 2026
