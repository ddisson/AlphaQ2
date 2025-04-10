# AlphaQuest Project Folder Structure

This document outlines the agreed-upon folder structure for the AlphaQuest project, based on the MVVM + Services architectural pattern.

*   **AlphaQ2** (Main Project Group)
    *   `Application` (Contains `AlphaQ2App.swift`, `AppDelegate` if needed)
    *   `Assets.xcassets` (For images, colors, app icons, etc.)
    *   `Core` (Fundamental utilities, extensions, constants)
        *   `Extensions` (e.g., `Color+Extensions.swift`)
        *   `Utils` (e.g., `GeometryHelpers.swift`)
        *   `Constants` (e.g., `AppConstants.swift`)
    *   `Data` (Models, Persistence logic)
        *   `Models` (e.g., `LetterData.swift`, `UserSettings.swift`, `DrawingPoint.swift`)
        *   `Persistence` (e.g., `PersistenceService.swift` for UserDefaults access)
    *   `Modules` (Feature-specific code, following MVVM)
        *   `LetterSelection`
            *   `Views`
            *   `ViewModels`
        *   `LetterIntroduction`
            *   `Views`
            *   `ViewModels`
        *   `WordAssociation`
            *   `Views`
            *   `ViewModels`
        *   `Painting`
            *   `Views` (e.g., `PaintingCanvasView.swift`, `ColorPaletteView.swift`, `PaintingLevelView.swift`)
            *   `ViewModels` (e.g., `PaintingViewModel.swift`)
            *   `DrawingEngine` (Logic for drawing, masking, threshold calculations)
        *   `Tutorial`
            *   `Views`
            *   `ViewModels`
        *   `Congratulations`
            *   `Views`
            *   `ViewModels`
        *   `ParentSettings`
            *   `Views`
            *   `ViewModels`
    *   `Services` (Shared functionalities, independent of specific modules)
        *   `Audio` (e.g., `AudioService.swift`)
        *   `ShapeRecognition` (e.g., `ShapeRecognitionService.swift` for Level 3)
    *   `Resources` (Non-code assets)
        *   `Fonts` (Custom fonts, if used)
        *   `DataFiles` (e.g., `LetterData.json`, if using external data source)
    *   `Preview Content` (Assets and providers specifically for SwiftUI Previews)

This structure aims to promote separation of concerns, maintainability, and testability. 