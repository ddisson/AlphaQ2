# AlphaQuest Audio File Guide

This guide explains how to add, manage, and use audio files (background music, sound effects, voiceovers) within the AlphaQuest project.

## 1. Supported Formats

The `AudioService` uses Apple's `AVFoundation`, which supports a variety of common audio formats. Recommended formats include:

- **`.mp3`**: Good compression for background music and longer voiceovers.
- **`.m4a` (AAC)**: Apple's preferred format, good quality and compression.
- **`.wav`**: Uncompressed, high quality, suitable for short sound effects where immediate playback is critical (though larger file size).
- **`.caf`**: Core Audio Format, flexible, good for short sounds.

Choose a format appropriate for the type of sound (music vs. short effect) and consider the balance between file size and quality.

## 2. File Location

While audio files can technically reside anywhere, placing them in a dedicated folder within the Xcode project structure is recommended for organization.

- **Suggestion:** Create a group (folder reference) within the `Resources` group in Xcode, named something like `Audio` or `Sounds`.
  ```
  AlphaQ2
  └── Resources
      └── Audio
          ├── Music
          │   └── background_music.mp3
          ├── Letters
          │   ├── letter_a_sound.mp3
          │   └── letter_b_sound.mp3
          ├── Words
          │   ├── word_apple_sound.mp3
          │   └── word_ant_sound.mp3
          └── SFX
              ├── sfx_success_level1.mp3
              └── sfx_failure_try_again.mp3
              └── sfx_paint_stroke.mp3
  ```

## 3. Adding Files to Xcode

1.  **Drag and Drop:** Drag the audio file(s) from Finder into the desired group (e.g., `Resources/Audio`) in the Xcode Project Navigator.
2.  **Add Options:** A dialog box will appear. Ensure the following options are set:
    *   **Destination:** Check "Copy items if needed".
    *   **Added folders:** Choose "Create groups" (usually default).
    *   **Add to targets:** **Crucially, make sure your main app target (e.g., "AlphaQ2") is checked.** This ensures the audio file is included in the **"Copy Bundle Resources"** build phase and will be available inside the app bundle at runtime.
3.  **Verify (Optional):** You can double-check by selecting the Project -> Target -> Build Phases -> Copy Bundle Resources section. Your audio file should appear in the list.

## 4. Naming Conventions

Consistency makes finding and using files easier. The `AudioService` currently uses helper functions that expect specific naming patterns. Adhering to these (or modifying the service if needed) is important:

- **Letter Sounds:** `letter_[letter]_sound.[ext]` (e.g., `letter_a_sound.mp3`, `letter_b_sound.m4a`)
- **Word Sounds:** `word_[word]_sound.[ext]` (e.g., `word_apple_sound.mp3`, `word_ant_sound.wav`)
- **UI Sounds:** `sfx_[description].[ext]` (e.g., `sfx_success_level1.mp3`, `sfx_failure_try_again.caf`, `sfx_paint_stroke.wav`)
- **Background Music:** Use descriptive names (e.g., `background_music_main.mp3`).

Use lowercase and underscores for clarity.

## 5. Using AudioService

The `AudioService` (typically accessed via `@EnvironmentObject`) provides methods to play sounds:

- `playBackgroundMusic(filename: String)`: Pass the full filename (e.g., `"background_music_main.mp3"`).
- `playSoundEffect(filename: String)`: Pass the full filename (e.g., `"sfx_success_level1.mp3"`).
- `playLetterSound(letter: String)`: Pass the letter string (e.g., `"A"`). Assumes filename `letter_a_sound.[ext]`.
- `playWordSound(word: String)`: Pass the word string (e.g., `"Apple"`). Assumes filename `word_apple_sound.[ext]`.
- `playUISound(soundName: String)`: Pass the descriptive part (e.g., `"success_level1"`). Assumes filename `sfx_success_level1.[ext]`.

**Example (in a SwiftUI View):**
```swift
struct SomeView: View {
    @EnvironmentObject private var audioService: AudioService
    
    var body: some View {
        Button("Play A") {
            audioService.playLetterSound(letter: "A") 
        }
    }
}
```

## 6. Updating/Changing Files

If an audio file needs to be replaced or updated:

1.  **Remove Old File:** Select the old audio file in the Xcode Project Navigator and delete it (Move to Trash).
2.  **Add New File:** Add the new file using the same steps as in Section 3, ensuring it has the **exact same filename** if you don't want to change the code that calls it.
3.  **If Renaming:** If the new file has a different name, you *must* also update the corresponding string passed to the `AudioService` function call(s) in the Swift code.
4.  **Clean Build:** It's often helpful to clean the build folder (Product -> Clean Build Folder) after changing bundled resources. 