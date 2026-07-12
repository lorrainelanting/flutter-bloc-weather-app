# generic_app

# Architecture Documentation

## 1. Architectural Overview
This project follows a **Clean Architecture** approach with a **Feature-First** modular structure. It is organized as a **Multi-Package (Monorepo)**, where different layers and features are separated into distinct local packages to promote scalability and testability.

## 2. Project Structure
The root directory contains several key modules:
- **`app/`**: The main application entry point. It handles app-level configurations (themes, routing) and contains the **Presentation Layer** for all features.
- **`core/`**: A shared library containing common utilities, base classes, and core logic used across the entire application.
- **`feature/`**: Contains individual feature packages (e.g., `auth`, `home`). Each feature encapsulates its own business logic and data handling.

## 3. Layered Architecture (Clean Architecture)
Each feature (and the app as a whole) is divided into three primary layers:

### A. Domain Layer (Located in `feature/<name>/lib/domain`)
The core of the application, independent of any external libraries or frameworks.
- **Entities**: Simple Dart objects representing the business models (e.g., `User`).
- **Use Cases**: Encapsulate specific business rules (e.g., `LoginWithGoogle`).
- **Repositories (Interfaces)**: Define abstract contracts for data operations that the Data layer must implement.

### B. Data Layer (Located in `feature/<name>/lib/data`)
Responsible for data retrieval and persistence.
- **Repositories (Implementations)**: Concrete implementations of the Domain interfaces.
- **Data Sources**: Handle raw data fetching from Remote APIs (e.g., Firebase, REST) or Local storage (e.g., SQLite, Prefs).
- **Models**: Data Transfer Objects (DTOs) used for JSON serialization/deserialization.
- **Mappers**: Logic to convert between Data Models and Domain Entities.
         
### C. Presentation Layer (Located in `app/lib/presentation`)
Responsible for the UI and user interaction.
- **UI (Views/Pages)**: Flutter widgets that build the screen.
- **State Management (BLoC)**: Uses the **BLoC (Business Logic Component)** pattern to manage state transitions. The UI sends **Events** to the BLoC and reacts to **States** emitted by it.