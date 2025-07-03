# 🏋️‍♂️ FitBeast – Be Fit With Us

A smart, cross-platform fitness monitoring application that uses Flutter, Firebase, and Machine Learning to provide personalized diet and workout recommendations based on user profiles, health data, and fitness goals.

<p align="center">
  <img src="https://img.shields.io/badge/flutter-v3.16-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/firebase-integrated-FFCA28?logo=firebase" />
  <img src="https://img.shields.io/badge/GetX-state%20management-green?logo=dart" />
  <img src="https://img.shields.io/badge/Python-Flask%20API-orange?logo=python" />
  <img src="https://img.shields.io/badge/ML-KMeans%20+%20KNN-9cf?logo=scikit-learn" />
  <img src="https://img.shields.io/badge/status-under%20active%20development-yellow" />  
</p>

---

## 🚀 App Overview

**FitBeast** is designed to empower users to track, analyze, and enhance their physical health. It delivers adaptive fitness plans by analyzing personal metrics and habits using an integrated ML engine.

---

## 🎯 Core Features

- 🧠 Personalized diet & workout plans (via ML API)

- 📝 Multi-step intelligent onboarding

- 🔥 Calorie tracking: intake and burn

- 💧 Water intake reminders and logs

- 😴 Sleep tracking with quality metrics

- 📈 Dynamic dashboards and progress visualization

- 🏆 Challenges, achievements, and gamification

- 🧑‍🤝‍🧑 Community: join groups, chat, and share progress

---

## 🧠 Tech Stack

| Layer          | Technology Used             |
|----------------|-----------------------------|
| **Frontend**    | Flutter (Dart), GetX (State Mgmt), Hive, GetStorage |
| **Backend**   | Firebase Auth, Firestore Database |
| **ML Engine**       | Python (KMeans, KNN), Pandas, NumPy, Scikit-learn    |
| **API Layer** | Flask (Python), Hosted on Render |

---

## 📱 Modules in Flutter App

| Module         | Description                 |
|----------------|-----------------------------|
| Onboarding	| Collects user info: age, gender, height, weight, goals|
| Dashboard	| Shows daily stats, logs, and quick actions|
| Meal Logger |	Tracks food intake (manual/barcode), syncs with ML|
| Workout Logger |	Logs exercise, calculates calories burned|
| Sleep Tracker	| Records sleep hours & quality|
| Water Tracker |	Tracks intake & sends reminders|
| Community	| Groups, peer chat, blog sharing, challenges|
| Progress Tracker |	Charts and analytics for all metrics|

---

## 🧮 Machine Learning Pipeline

The backbone of FitBeast’s intelligence lies in its dynamic Machine Learning engine, built using Python, powered by KMeans and KNN, and served through a Flask-based REST API. Here's how it all flows together:

### 🌀 1. User Clustering with K-Means
Once a user completes onboarding, their metrics (height, weight, age, gender, fitness goals, and workout habits) are used to classify them into distinct fitness personas. These clusters help us understand whether the user is aiming for weight loss, muscle gain, or maintenance, and identify others with similar profiles.

### 🤝 2. Plan Recommendation with K-Nearest Neighbors
After clustering, the system finds similar users who’ve had positive progress. Based on this, the KNN algorithm predicts a personalized diet and workout plan that’s likely to work for the new user. The prediction adapts week by week based on logged activities and adherence.

### 🔁 3. Data Flow & Integration
All user inputs—whether from onboarding, meal logging, workout tracking, or hydration logs—are stored in Firebase Firestore and Hive (offline-first). These logs are periodically bundled and sent to the ML API for fresh predictions. The response is cached locally for performance and offline support.

### 🌐 4. API Deployment
Our model is wrapped in a production-grade Flask API and deployed on Render, ensuring seamless scalability and real-time responsiveness.

---

## 🤝 Let's Connect

> Open to collaborations, freelancing, and full-time! Let’s build something awesome together.

📫 **Email**:  [desk.daemons@gmail.com](mailto:desk.daemons@gmail.com)  

💼 **LinkedIn**:  [in/pratikkor/](https://www.linkedin.com/in/pratikkor/)  

📦 **GitHub**:  [github.com/pratikkor-flutter](https://github.com/pratikkor-flutter)

---

<p align="center"> Made with ❤️ by Pratik Kor </p>
