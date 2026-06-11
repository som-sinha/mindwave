# MindWave

A student-focused mobile toolkit that uses AI to transform uploaded course material into structured quizzes, simplified summaries, and curated study resources.

Built with Flutter and powered by Google's Gemini API via Genkit, MindWave helps learners and educators review and test knowledge in a structured, intelligent format.

---

## Features

- **AI-Generated Quizzes** — Upload a PDF or paste text and generate multiple-choice quizzes tailored to your material
- **Smart Summaries** — Get concise, AI-powered summaries for any subtopic before or after a quiz
- **Resource Recommendations** — Receive curated links for further study on any topic
- **Course Navigation** — Organize content hierarchically: Course → Topic → Subtopic
- **In-App Feedback** — Rate features and submit suggestions directly from the app
- **Secure Authentication** — Email/password sign-up and login via Firebase Auth

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter / Dart |
| AI Framework | Google Genkit |
| LLM | Gemini API (Google) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| Architecture | MVC (Model-View-Controller) |

---

## Architecture

MindWave follows the MVC pattern to separate concerns and keep the codebase modular and scalable.

```
lib/
├── models/
│   ├── course_model.dart
│   ├── topic_model.dart
│   ├── subtopic_model.dart
│   ├── quiz_model.dart
│   ├── question_model.dart
│   └── user_model.dart
├── controllers/
│   ├── app_controller.dart
│   └── auth_controller.dart
└── views/
    ├── course_list_view.dart
    ├── topic_list_view.dart
    ├── subtopic_view.dart
    ├── quiz_view.dart
    ├── review_view.dart
    ├── feedback_view.dart
    ├── add_course_view.dart
    ├── login_view.dart
    ├── signup_view.dart
    ├── auth_gate.dart
    └── splash_screen.dart
```

**Models** define the data schema for courses, topics, subtopics, quizzes, questions, and users.

**Controllers** manage app-wide state and business logic. `AppController` handles course data; `AuthController` manages authentication flows and session state.

**Views** handle all UI rendering and routing. Navigation is managed through Flutter's named route system with authentication-aware routing via `AuthGate`.

---

## Firebase Integration

**Authentication** — Firebase Auth manages user credentials, session state, and secure access to protected views. Authentication state is reactive and persists across app restarts.

**Firestore** — Cloud Firestore stores user profiles, course structures, quiz results, and feedback. Supports real-time sync and asynchronous data retrieval via stream builders.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- A Firebase project with Authentication and Firestore enabled
- A Google AI API key with Gemini access

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/som-sinha/mindwave.git
   cd mindwave
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Configure Firebase
   - Set up a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Run the FlutterFire CLI to generate `firebase_options.dart`
   ```bash
   flutterfire configure
   ```

4. Add your Gemini API key to your environment or a local config file (do not commit this)

5. Run the app
   ```bash
   flutter run
   ```

---

## User Flow

```
Sign Up / Log In
      ↓
  Course List
      ↓
  Topic List
      ↓
 Subtopic View
    ↙     ↘
Review    Quiz
(Summary) (Questions)
```

---

## Contributors

| Name | GitHub |
|---|---|
| Somaditya Sinha | [@som-sinha](https://github.com/som-sinha) |
| Arooz Paul Singh | [@Eddy-Singh](https://github.com/Eddy-Singh) |
| Sanjay Aadhitya | [@avsan-j](https://github.com/avsan-j) |
| Anahita Nikaien | [@anahitana](https://github.com/anahitana) |

---

## Course

Developed as part of COMP-4768 at Memorial University of Newfoundland.
