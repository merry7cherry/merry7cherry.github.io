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
</style>

Hi, I am a Master's student at the University of California, Irvine, working as a Research Assistant in the [Trustworthy ML/AI Group](https://sites.google.com/uci.edu/yanning-shen/group?authuser=0) at UCI. I am also a student collaborator at [Oak Ridge National Laboratory](https://education.ornl.gov/graduate/).

**Research Interests**:

- **Generative Modeling**: Developing advanced algorithms and models for generative modeling, understanding, and reasoning, with applications in computer vision and vision-language models.

- **Efficient Generation**: Proposing novel generative theory/algorithms for efficiency, including one-step generation and multi-stage generation approaches.

- **Fairness in AI**: Designing methods to address challenges of fairness in generative models and representation learning.

- **Multi-modal Understanding**: Working on generative and understanding models for real-world data (images, videos, 3D, and multi-modality), focusing on improving efficiency and performance.


<div class="announcement-banner">
  📢 I'm seeking a PhD position focused on generative and understanding models for real-world data (images, videos, 3D, and multi-modality). Motivated to address challenges in generation, understanding, reasoning, efficiency, and fairness. Feel free to <a href="mailto:chenrum@uci.edu">reach out</a>!
</div>

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
- **University of California, Irvine**  
  *Master of Science in Computer Science (Networked Systems)*  
  September 2025 – June 2026 (Expected)  
  GPA: 4.00/4.00

- **University of California, Irvine**  
  *Joint Education Student (UCI 3+2 Engineering program) in Computer Science*  
  September 2024 – June 2025  
  GPA: 3.92/4.00

- **Central South University**  
  *Bachelor of Science in Computer Science*  
  September 2021 – June 2024  
  Grade: 86.8%, Rank: Top 35%

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

## 📫 Contact
Email: [chenrum@uci.edu](mailto:chenrum@uci.edu)  
Location: Irvine, California, USA  

