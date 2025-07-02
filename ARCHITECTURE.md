# AlphaQuest Architecture Documentation

## Project Overview
AlphaQuest is an educational iPad app for teaching children the alphabet through interactive letter recognition, pronunciation, and drawing activities.

## Updated Architecture (January 2025)

### **🎯 Core Design Principle**
**Single Responsibility & Clear Flow**: Each module has one clear purpose, eliminating duplication and structural confusion.

---

## Module Structure

### **1. Application Layer**
```
AlphaQ2/
├── AlphaQ2App.swift           # App entry point
└── Application/
    └── ContentView.swift      # Root navigation controller
```

### **2. Core Infrastructure**
```
Core/
├── Extensions/
│   ├── ButtonStyles.swift     # UI button styling
│   ├── Color+Extensions.swift # Color theming
│   └── TypographyStyles.swift # Text styling
└── Utils/
    └── Logger.swift           # Logging utilities
```

### **3. Data Layer**
```
Data/
├── Models/
│   ├── LetterData.swift           # Letter data model
│   ├── LetterCharacterData.swift  # Character visual data
│   ├── UserSettings.swift         # User preferences & progress
│   └── WordInfo.swift             # Word association data
└── Persistence/
    └── PersistenceService.swift   # Local data storage
```

### **4. Services Layer**
```
Services/
├── Audio/
│   └── AudioService.swift            # Audio playback management
└── ShapeRecognition/
    └── ShapeRecognitionService.swift # Letter shape recognition
```

### **5. Feature Modules**

#### **5.1 LetterSelection Module**
**Responsibility**: Main navigation and letter flow coordination
```
Modules/LetterSelection/
└── Views/
    ├── MainMenuView.swift     # Letter selection screen
    └── LetterFlowView.swift   # ✨ INTEGRATED FLOW COORDINATOR
```

**Key Change**: `LetterFlowView` now contains **integrated letter introduction** functionality, eliminating the need for a separate `LetterIntroductionView`.

#### **5.2 WordAssociation Module**
**Responsibility**: Show words that begin with the selected letter
```
Modules/WordAssociation/
└── Views/
    └── WordAssociationView.swift
```

#### **5.3 Painting Module**
**Responsibility**: Interactive drawing and tracing activities
```
Modules/Painting/
├── Models/
│   └── Line.swift                    # Drawing line data
└── Views/
    ├── ColorPaletteView.swift        # Color selection
    ├── DrawingCanvasView.swift       # Touch drawing canvas
    ├── Level1FillView.swift          # Fill hollow letter
    ├── Level2TraceView.swift         # Trace letter outline
    ├── Level3FreeDrawView.swift      # Free drawing with recognition
    ├── PaintingInteractionView.swift # Touch interaction handling
    ├── SuccessOverlayView.swift      # Success feedback
    └── RetryOverlayView.swift        # Retry feedback
```

#### **5.4 Tutorial Module**
**Responsibility**: User onboarding and instruction
```
Modules/Tutorial/
└── Views/
    ├── TutorialView.swift            # Tutorial coordinator
    ├── TutorialPage1View.swift       # Introduction
    ├── TutorialPage2View.swift       # Color selection tutorial
    ├── TutorialPage3View.swift       # Drawing tutorial
    └── TutorialPage4View.swift       # Navigation tutorial
```

#### **5.5 Congratulations Module**
**Responsibility**: Success celebration and completion
```
Modules/Congratulations/
└── Views/
    └── CongratulationsView.swift
```

#### **5.6 Shared Module**
**Responsibility**: Reusable UI components
```
Modules/Shared/
└── Views/
    └── Effects/
        └── ConfettiView.swift        # Celebration effects
```

---

## **🔄 Letter Learning Flow (Simplified)**

### **Previous Architecture Problem**
- ❌ **Duplicate Views**: `LetterIntroductionView` + `LetterFlowView` introduction step
- ❌ **Unclear Responsibilities**: Both handled letter display + audio
- ❌ **Potential Crashes**: File reference conflicts in Xcode

### **✅ Current Simplified Architecture**

**Single Flow Controller**: `LetterFlowView`

```swift
LetterFlowView {
    enum LetterFlowStep {
        case introduction      // ← INTEGRATED (no separate view)
        case wordAssociation   // → WordAssociationView
        case level1Fill        // → Level1FillView
        case level2Trace       // → Level2TraceView
        case level3FreeDraw    // → Level3FreeDrawView
        case congratulations   // → CongratulationsView
    }
}
```

**Introduction Step**: Now directly embedded in `LetterFlowView`:
- Shows letter image/character
- Plays pronunciation audio
- Handles animation
- Provides "Continue" button

---

## **📱 Navigation Architecture**

```
MainMenuView
    ↓ (letter selection)
LetterFlowView
    ├── Introduction (integrated)
    ├── WordAssociationView
    ├── Level1FillView
    ├── Level2TraceView
    ├── Level3FreeDrawView
    └── CongratulationsView
```

---

## **🎨 UI Architecture Patterns**

### **1. View Composition**
- Each view focuses on a single screen/functionality
- Reusable components in `Shared/` module
- Consistent styling through `Core/Extensions/`

### **2. State Management**
- `@State` for local view state
- `@EnvironmentObject` for shared services (AudioService)
- `PersistenceService` for data persistence

### **3. Navigation Pattern**
- **Callback-based navigation**: Views call `onComplete()` callbacks
- **Notification-based updates**: Painting levels use `NotificationCenter`
- **Full-screen presentation**: `MainMenuView` → `LetterFlowView`

---

## **🔧 Key Architectural Decisions**

### **1. Integration vs Separation**
- **✅ CHOSEN**: Integrated letter introduction into flow coordinator
- **❌ REJECTED**: Separate `LetterIntroductionView` (caused duplication)

### **2. Flow Management**
- **✅ CHOSEN**: Single `LetterFlowView` manages entire letter journey
- **❌ REJECTED**: Multiple coordinators (would increase complexity)

### **3. Communication Patterns**
- **Callbacks**: For simple parent-child communication
- **Notifications**: For painting level completions (decoupled)
- **Environment Objects**: For shared services

---

## **📁 File Organization**

### **Modules by Feature**
Each major feature gets its own module:
- Clear separation of concerns
- Easy to navigate and maintain
- Logical grouping of related files

### **Shared Resources**
```
Resources/
├── Audio/
│   ├── Letters/Letter_A_sounds/    # Letter pronunciation
│   ├── Music/                      # Background music
│   └── SFX/                        # Sound effects
└── Assets.xcassets/
    ├── LetterCharacters/           # Letter images
    ├── Letter_a_words/             # Word association images
    └── Character_face_animation/   # Animation assets
```

---

## **🚀 Benefits of New Architecture**

### **1. Eliminated Duplication**
- ❌ **Before**: Two views handling letter introduction
- ✅ **After**: Single, integrated flow in `LetterFlowView`

### **2. Clearer Responsibilities**
- **LetterFlowView**: Flow coordination + letter introduction
- **Other Views**: Specific functionality only

### **3. Reduced Complexity**
- Fewer files to maintain
- Simpler navigation logic
- No file reference conflicts

### **4. Better Performance**
- Reduced view hierarchy
- Fewer object allocations
- Smoother transitions

---

## **🎯 Future Expansion Plan**

### **Adding New Letters**
1. Update `LetterDataProvider` with new letter data
2. Add audio files to `Resources/Audio/Letters/`
3. Add letter images to `Assets.xcassets/LetterCharacters/`
4. No code changes needed (data-driven architecture)

### **Adding New Languages**
1. Localized audio files in `Resources/Audio/Letters/`
2. Localized text in `Localizable.strings`
3. Cultural adaptations in letter character designs

### **Adding New Activity Types**
1. Create new view in appropriate module
2. Add new case to `LetterFlowStep` enum
3. Update `LetterFlowView.currentStepView()` method

---

## **📊 Technical Stack**

- **UI Framework**: SwiftUI
- **Audio**: AVFoundation/AVAudioSession
- **Drawing**: Custom touch handling with UIKit integration
- **Persistence**: UserDefaults for local storage
- **Shape Recognition**: Custom algorithm for letter validation
- **Platform**: iPad (iOS 17.5+)
- **Orientation**: Landscape only

---

*This architecture documentation reflects the simplified structure implemented in January 2025, eliminating the duplicate letter introduction views and creating a cleaner, more maintainable codebase.* 