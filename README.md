# 🎓 ML-Based Placement Prediction Application

## 🔍 Overview

This is a **Machine Learning-based Placement Prediction System** that helps students evaluate their placement chances based on academic, technical, and soft skill inputs. The application uses various ML algorithms for prediction and is backed by a modern Flutter-based frontend, delivering a smooth and interactive experience.

---

## 🚀 Tech Stack

### 🧠 Machine Learning (Backend - Python with Flask)
- **Python Libraries**:
  - `NumPy`
  - `Pandas`
  - `Scikit-learn`
  - `XGBoost`
- **ML Algorithms Used**:
  - Logistic Regression
  - Random Forest
  - Decision Tree
  - XGBoost
- **Framework**:
  - `Flask` - Acts as the REST API backend and serves predictions.

### 📱 Frontend (Mobile & Web - Flutter)
- Modern and responsive UI built using **Flutter**.
- Integrated with **Firebase Authentication** for:
  - User Sign Up
  - User Login
- Interactive navigation with smooth animations and a structured layout.

---

## ✨ Key Features

### 🔐 User Authentication
- Sign Up / Log In functionality powered by Firebase.

### 🏠 Homepage Modules
- **Aptitude Test**: Assess logical and numerical reasoning.
- **Soft Skills Test**: Evaluate communication, teamwork, and adaptability.
- **Programming Test**: Assess technical coding knowledge.
- **Full Test**: Comprehensive combined test covering all above areas.

### 📈 Placement Prediction
- Users input data such as:
  - Number of Internships
  - Number of Projects
  - Aptitude Score
  - Programming Score
  - Total Questions Solved on LeetCode *(Optional)*
  - Current CGPA
  - Backlogs *(Optional)*
- Model returns:
  - **Placement Prediction (Yes/No)**
  - **Confidence Score (%)**
  - **Suggestions/Recommendations** (based on weak areas)

---
