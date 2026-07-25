# HollandKompas 🧭

**Learn Dutch in Arabic** — a modern Dutch-learning platform for Arabic speakers, featuring structured courses, video and audio lessons, quizzes, flashcards, and progress tracking. Built with a single Flutter codebase for Web, Android, and iOS.

![Status](https://img.shields.io/badge/status-in%20development-yellow)
![Platform](https://img.shields.io/badge/platform-Web%20%7C%20Android%20%7C%20iOS-blue)
![Built with Flutter](https://img.shields.io/badge/built%20with-Flutter-02569B)

---

## Overview

**HollandKompas** is a Dutch language learning platform designed specifically for Arabic-speaking learners who want a clear and structured path to mastering Dutch.

The platform combines courses, themed lessons, vocabulary training, quizzes, flashcards, and progress tracking into a single Arabic-first experience with full RTL support. Whether you're preparing for life, work, or study in the Netherlands, HollandKompas helps you learn Dutch step by step.

---

## Status

🚧 **Actively in Development**

The platform is currently under active development and new features are being added continuously.

---

## Tech Stack

| Layer                     | Technology                                                     |
| ------------------------- | -------------------------------------------------------------- |
| App (Web / Android / iOS) | Flutter                                                        |
| State Management          | Riverpod                                                       |
| Routing                   | go_router                                                      |
| Backend                   | Supabase (PostgreSQL, Auth, Storage, Realtime, Edge Functions) |
| Local Storage             | Hive                                                           |
| Video Lessons             | youtube_player_iframe                                          |
| Audio Lessons             | just_audio                                                     |
| Hosting                   | Firebase Hosting                                               |
| Marketing Website         | Vercel / Netlify                                               |
| CI/CD                     | GitHub Actions                                                 |

---

## Features

### Authentication

* Email & password registration
* Secure login
* Password reset
* Email verification

### Courses & Lessons

* Structured learning path
* Course → Theme → Lesson hierarchy
* Video lessons
* Audio lessons
* Lesson completion tracking

### Quizzes

* Multiple-choice questions
* Fill-in-the-blank exercises
* Instant feedback and scoring

### Vocabulary & Flashcards

* Searchable vocabulary bank
* Categorized word lists
* Interactive flashcards
* Revision and practice mode

### Student Dashboard

* Learning statistics
* Progress tracking
* Continue where you left off
* Course completion overview

### Offline-First Experience

* Cached content access
* Learning without internet
* Automatic synchronization when online

### Arabic-First Design

* Full RTL support
* Optimized Arabic user experience
* Responsive design across all devices

---

## Getting Started

### Prerequisites

* Flutter SDK (Stable Channel)
* Supabase Project

### Clone the Repository

```bash
git clone https://github.com/shroida/hollandkompas.git

cd hollandkompas
```

### Install Dependencies

```bash
flutter pub get
```

### Environment Configuration

Create an `env.json` file (do not commit it to Git):

```json
{
  "SUPABASE_URL": "your_supabase_url",
  "SUPABASE_ANON_KEY": "your_supabase_anon_key"
}
```

### Run Locally

```bash
flutter run -d chrome --dart-define-from-file=env.json
```

### Production Build

```bash
flutter build web --wasm --release --dart-define-from-file=env.json
```

---

## Project Structure

```text
lib/
│
├── core/
│   ├── theme
│   ├── router
│   ├── constants
│   ├── connectivity
│   └── breakpoints
│
├── data/
│   ├── supabase
│   ├── hive
│   └── repositories
│
├── features/
│   ├── auth
│   ├── courses
│   ├── lessons
│   ├── quizzes
│   ├── flashcards
│   └── dashboard
│
└── shared/
    └── widgets
```

---

## Roadmap

### Sprint 0–2

* Project setup
* Authentication
* Offline-first architecture
* Core infrastructure

### Sprint 3–7

* Courses module
* Lessons module
* Quizzes
* Vocabulary bank
* Flashcards
* Student dashboard

### Sprint 8–11

* Content management workflow
* Security improvements
* Subscription system
* Quality assurance
* Deployment

### Future Releases (v2)

* Certificates of completion
* AI-powered Dutch tutor
* Speaking practice
* Pronunciation checker
* App Store & Google Play releases

---

## Vision

HollandKompas aims to become the leading Dutch-learning platform for Arabic speakers by providing high-quality educational content, modern learning tools, and an accessible learning experience across all devices.

---

## Author

**Mohamed Walid**
Founder & Lead Developer

GitHub: https://github.com/shroida

LinkedIn: https://linkedin.com/in/mohamed-walid-2a9061241

---

## License

This project is currently proprietary and under active development.

License details will be announced in a future release.
