# AlphaQuest Project Architecture

This document outlines the chosen architectural pattern and core dependencies for the AlphaQuest project.

## 1. Architectural Pattern: MVVM + Services

We will adopt the **MVVM (Model-View-ViewModel)** pattern supplemented by dedicated **Service** layers for shared functionalities.

*   **Models (`Data/Models`)**: Represent the application's data structures (e.g., `LetterData`, `UserSettings`). They are simple data holders with no logic.
*   **Views (`Modules/*/Views`)**: SwiftUI views responsible solely for UI presentation and user input forwarding. They observe the ViewModel for state changes and remain passive ("dumb").
*   **ViewModels (`Modules/*/ViewModels`)**: `ObservableObject` classes containing the presentation logic, state management, and data preparation for their corresponding Views. They interact with Models and Services.
*   **Services (`Services`)**: Encapsulate specific, reusable functionalities or complex business logic (e.g., `AudioService`, `PersistenceService`, `ShapeRecognitionService`, `DrawingEngine`). ViewModels utilize these services, typically via dependency injection to enhance testability.
*   **Core (`Core`)**: Houses fundamental utilities, extensions, and constants shared across the application.

**Rationale**: This pattern promotes:
    *   **Separation of Concerns**: Clear boundaries between UI, presentation logic, data, and services.
    *   **Testability**: ViewModels and Services can be unit-tested independently of the UI.
    *   **Maintainability**: Easier to understand, modify, and extend individual components.

## 2. Core Dependencies (MVP)

For the Minimum Viable Product (MVP), we will primarily rely on Apple's native frameworks:

*   **SwiftUI**: The core framework for building the user interface and handling user interactions.
*   **AVFoundation**: Used by the `AudioService` for managing playback of background music, voiceovers, and sound effects.
*   **CoreGraphics / QuartzCore**: May be utilized within the `DrawingEngine` or `PaintingCanvasView` for path creation, masking, hit-testing, and rendering on the `Canvas`.
*   **Foundation**: Provides fundamental data types, collections, and access to `UserDefaults` via the `PersistenceService`.

**Third-Party Libraries**: No external third-party libraries are planned for the core MVP functionality (drawing, simple shape recognition). We will build these features using native frameworks first. This decision can be revisited if specific requirements prove too complex or time-consuming to implement natively.

## 3. Testing Strategy

*   **Unit Tests**: Focus on testing ViewModels, Services, and Models.
*   **UI Tests**: Can be added later to verify user flows and UI interactions, though manual testing will be primary during early development.

This architecture provides a solid foundation for building the AlphaQuest game. 