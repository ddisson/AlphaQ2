# AlphaQuest Tutorial Plan

This document outlines the plan for the tutorial/onboarding flow as per Phase 3.6 of the development plan.

## 1. Goal

To simply and visually explain the core interactions:
- Basic tapping/navigation.
- Selecting colors using the palette.
- Drawing with a finger.

Provide an easy way for users (or parents) to skip the tutorial.

## 2. Overall Structure & Style

- **Structure:** A multi-page flow using a SwiftUI `TabView` with the `.tabViewStyle(.page)` modifier for swipe navigation (potentially supplemented with explicit "Next" buttons).
- **Visual Style:** Strictly adhere to the `artstyleguide.md`:
    - **Colors:** Use primary palette (`#6ECFF6`, `#FFE066`, `#FF6F61`, `#8BC34A`, `#B39DDB`) for backgrounds, buttons, accents. Use neutrals/pastels as needed.
    - **Typography:** Use the chosen rounded, playful primary font (e.g., Comic Neue, Fredoka One) at large sizes (e.g., ~48pt titles, ~24-28pt body/buttons).
    - **Buttons:** Rounded rectangles/pills, bright primary colors for main actions, softer color for "Skip". Large tap targets (>44pt). Clear press states. Simple cartoonish icons.
    - **Animations:** Bouncy, spring-like transitions and interactions. Subtle particle effects (sparkles).
    - **Layout:** Simple, uncluttered, full-screen vibrant backgrounds.
- **Skip Button:** A rounded "Skip" button (e.g., light gray fill, large target) consistently placed (e.g., top-right) on all pages.

## 3. Tutorial Pages / Steps

### Page 1: Welcome & Tapping
- **Visual:** Vibrant background (e.g., Sky Blue). Large "Welcome!" title. Central friendly graphic (Placeholder: `tutorial_graphic_welcome`). Large, rounded "Next ->" button (e.g., Sunny Yellow). Subtle button pulse animation.
- **Explanation:** Text label: "Tap Next to start!"
- **Interaction:** Tap "Next" button. Bouncy feedback.

### Page 2: Choosing Colors
- **Visual:** Different vibrant background (e.g., Lavender). Prominently display `ColorPaletteView`. Placeholder graphic: `tutorial_graphic_pointing_finger`. Clear selection feedback on palette. Rounded "Next ->" button.
- **Explanation:** Text label: "Tap a color!"
- **Interaction:** Tap "Next" button. Bouncy feedback.

### Page 3: Drawing Fun
- **Visual:** Different vibrant background (e.g., Leaf Green). Clearly defined drawing area (e.g., rounded rect with soft neutral fill). Placeholder graphic: `tutorial_graphic_drawing_finger`. Rounded "Next ->" button.
- **Explanation:** Text label: "Draw with your finger!"
- **Interaction:** Tap "Next" button. Bouncy feedback.

### Page 4: Ready to Play!
- **Visual:** Different vibrant background (e.g., Coral Red). Large "Ready!"/"Let's Go!" title. Placeholder graphic: `tutorial_graphic_ready` (maybe showing A/B). Placeholder confetti/sparkle animation. Large, prominent, rounded "Start Playing!" button (e.g., Sunny Yellow).
- **Explanation:** Text label: "Let's learn letters!"
- **Interaction:** Tap "Start Playing!". Bouncy feedback, transition to main app.

## 4. Implementation Plan

1.  Create `TutorialView.swift` (container using `TabView` page style).
2.  Create placeholder view files: `TutorialPage1View.swift`, `TutorialPage2View.swift`, `TutorialPage3View.swift`, `TutorialPage4View.swift`.
3.  Implement the basic layout and navigation within `TutorialView`.
4.  Implement the static content (text, buttons, placeholder graphics) for each page view, adhering to the style guide.
5.  Integrate the actual `ColorPaletteView` into Page 2.
6.  Add the "Skip" button functionality.
7.  Add the "Start Playing" button functionality (triggering dismissal/navigation).
8.  (Later) Replace placeholder graphics/animations with final assets.
9.  (Later) Add voiceover integration.

## 5. Required Assets (Placeholders initially)

- `tutorial_graphic_welcome`
- `tutorial_graphic_pointing_finger`
- `tutorial_graphic_drawing_finger`
- `tutorial_graphic_ready`
- Specific background styles/colors per page.
- Final button styles/colors.
- Confetti/sparkle animation details. 