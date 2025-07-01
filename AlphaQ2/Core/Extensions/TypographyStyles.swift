import SwiftUI

/// Typography system for AlphaQuest following the Pixar-inspired art style guide.
/// Provides consistent font styles across the entire application.
struct TypographyStyles {
    
    // MARK: - Font Definitions
    
    /// Primary font for headings and emphasis - rounded, playful style
    static let primaryFontName = "Fredoka-Bold" // Fallback to system rounded if not available
    
    /// Secondary font for body text and smaller elements
    static let secondaryFontName = "Nunito-Medium" // Fallback to system if not available
    
    // MARK: - Title Styles (36-48pt)
    
    /// Large title for main screens (48pt)
    static let largeTitle = Font.custom(primaryFontName, size: 48)
        .fallback(Font.system(size: 48, weight: .bold, design: .rounded))
    
    /// Regular title for sections (36pt)
    static let title = Font.custom(primaryFontName, size: 36)
        .fallback(Font.system(size: 36, weight: .bold, design: .rounded))
    
    // MARK: - Heading Styles
    
    /// Main heading style (32pt)
    static let heading1 = Font.custom(primaryFontName, size: 32)
        .fallback(Font.system(size: 32, weight: .bold, design: .rounded))
    
    /// Secondary heading (28pt)
    static let heading2 = Font.custom(primaryFontName, size: 28)
        .fallback(Font.system(size: 28, weight: .semibold, design: .rounded))
    
    // MARK: - Body Text Styles (24-28pt)
    
    /// Large body text for main content (28pt)
    static let bodyLarge = Font.custom(secondaryFontName, size: 28)
        .fallback(Font.system(size: 28, weight: .medium, design: .default))
    
    /// Regular body text (24pt)
    static let body = Font.custom(secondaryFontName, size: 24)
        .fallback(Font.system(size: 24, weight: .medium, design: .default))
    
    /// Small body text for subtitles (20pt)
    static let bodySmall = Font.custom(secondaryFontName, size: 20)
        .fallback(Font.system(size: 20, weight: .regular, design: .default))
    
    // MARK: - Button Text Styles (24pt)
    
    /// Primary button text
    static let buttonPrimary = Font.custom(primaryFontName, size: 24)
        .fallback(Font.system(size: 24, weight: .bold, design: .rounded))
    
    /// Secondary button text
    static let buttonSecondary = Font.custom(secondaryFontName, size: 22)
        .fallback(Font.system(size: 22, weight: .semibold, design: .default))
    
    /// Small button text
    static let buttonSmall = Font.custom(secondaryFontName, size: 18)
        .fallback(Font.system(size: 18, weight: .medium, design: .default))
    
    // MARK: - Special Purpose Styles
    
    /// Caption text for very small elements
    static let caption = Font.custom(secondaryFontName, size: 16)
        .fallback(Font.system(size: 16, weight: .regular, design: .default))
    
    /// Letter display - extra large for showcasing letters
    static let letterDisplay = Font.custom(primaryFontName, size: 120)
        .fallback(Font.system(size: 120, weight: .black, design: .rounded))
}

// MARK: - Font Extension for Fallback Support

extension Font {
    /// Provides fallback functionality for custom fonts
    func fallback(_ fallbackFont: Font) -> Font {
        // In a production app, you'd check if the custom font is available
        // For now, we'll use the system fonts as they're guaranteed to work
        return fallbackFont
    }
}

// MARK: - Text Style Modifiers

extension Text {
    /// Apply large title style
    func largeTitleStyle() -> some View {
        self.font(TypographyStyles.largeTitle)
    }
    
    /// Apply title style
    func titleStyle() -> some View {
        self.font(TypographyStyles.title)
    }
    
    /// Apply heading 1 style
    func heading1Style() -> some View {
        self.font(TypographyStyles.heading1)
    }
    
    /// Apply heading 2 style
    func heading2Style() -> some View {
        self.font(TypographyStyles.heading2)
    }
    
    /// Apply large body style
    func bodyLargeStyle() -> some View {
        self.font(TypographyStyles.bodyLarge)
    }
    
    /// Apply body style
    func bodyStyle() -> some View {
        self.font(TypographyStyles.body)
    }
    
    /// Apply small body style
    func bodySmallStyle() -> some View {
        self.font(TypographyStyles.bodySmall)
    }
    
    /// Apply primary button text style
    func buttonPrimaryStyle() -> some View {
        self.font(TypographyStyles.buttonPrimary)
    }
    
    /// Apply secondary button text style
    func buttonSecondaryStyle() -> some View {
        self.font(TypographyStyles.buttonSecondary)
    }
    
    /// Apply small button text style
    func buttonSmallStyle() -> some View {
        self.font(TypographyStyles.buttonSmall)
    }
    
    /// Apply caption style
    func captionStyle() -> some View {
        self.font(TypographyStyles.caption)
    }
    
    /// Apply letter display style for showcasing letters
    func letterDisplayStyle() -> some View {
        self.font(TypographyStyles.letterDisplay)
    }
}

// MARK: - View Extensions for Typography

extension View {
    /// Apply large title typography style
    func largeTitleStyle() -> some View {
        self.font(TypographyStyles.largeTitle)
    }
    
    /// Apply title typography style
    func titleStyle() -> some View {
        self.font(TypographyStyles.title)
    }
    
    /// Apply heading 1 typography style
    func heading1Style() -> some View {
        self.font(TypographyStyles.heading1)
    }
    
    /// Apply heading 2 typography style
    func heading2Style() -> some View {
        self.font(TypographyStyles.heading2)
    }
    
    /// Apply body large typography style
    func bodyLargeStyle() -> some View {
        self.font(TypographyStyles.bodyLarge)
    }
    
    /// Apply body typography style
    func bodyStyle() -> some View {
        self.font(TypographyStyles.body)
    }
    
    /// Apply body small typography style
    func bodySmallStyle() -> some View {
        self.font(TypographyStyles.bodySmall)
    }
    
    /// Apply caption typography style
    func captionStyle() -> some View {
        self.font(TypographyStyles.caption)
    }
} 