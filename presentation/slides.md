---
marp: true
theme: gaia
paginate: true
class: invert
title: "Optimizing Honeypot Deployment Stretagies: Towards Automated Delivery of Honeypot-as-a-service"
author: Sander Osvik Brekke
header: Optimizing Honeypot Deployment Stretagies – S. O. Brekke
footer: May 2024
size: 16:9
math: mathjax
---

<style>
    img[alt="center"] { display: block; margin: 0 auto; }
</style>

### **Optimizing Honeypot Deployment Stretagies:** Towards Automated Delivery of Honeypot-as-a-service

__SANDER O. BREKKE__
_Supervisor @ NTNU:_ **Slobodan Petrovic**
_Supervisor @ Eidsiva Bredbånd:_ Håkon Gunleifsen

---

## Contents

- 

---

## Introduction

- **Challenge:** Lack of trust in user-inputted age; potential grooming; age verification
- **Goal:** Categorize users as above or below a certain age
- **Proposed Solution:** Continuous age determination through keystroke dynamics with a statistical approach

---

## Current State of the Art

- Tverrå (2023)
- Continuous Determination
- Scaled Manhattan Distance
- 87% accuracy
- Avg. # of keystrokes: 825

---

## Methodology

- **Continuous analysis of keystrokes**
- Statistical methods
- Trust Model
- Authentication & Identification

---

## Further Improvements and Work

- Outlier removal
    - Repeat in several iterations
    - Perform different types
- Feature selection
    - Test for more/less influencing features

---

<div style="margin: auto; margin-top: 15%; width: 30%">
<h1>Questions?</h1>
</div>
