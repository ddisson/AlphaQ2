import SwiftUI

// Make the extension internal (default) or public so it's accessible across modules.

extension Color {
    /// Initializes Color from a hexadecimal string representation.
    /// Supports formats like "#RRGGBB", "#RRGGBBAA", "#RGB", "RRGGBB", etc.
    ///
    /// - Parameter hex: The hexadecimal string (e.g., "#FF6F61", "8BC34A", "#B39DDBFF").
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            // Return a default color (e.g., black or clear) or handle error appropriately
            (a, r, g, b) = (255, 0, 0, 0) // Defaulting to black for simplicity
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - AlphaQuest Color Palette

extension Color {
    
    // MARK: - Primary Colors (Art Style Guide)
    
    /// Sky Blue - Primary brand color (#6ECFF6)
    static let primarySkyBlue = Color(hex: "#6ECFF6")
    
    /// Sunny Yellow - Bright, cheerful accent (#FFE066)
    static let primarySunnyYellow = Color(hex: "#FFE066")
    
    /// Coral Red - Warm, friendly attention color (#FF6F61)
    static let primaryCoralRed = Color(hex: "#FF6F61")
    
    /// Leaf Green - Natural, growth-oriented color (#8BC34A)
    static let primaryLeafGreen = Color(hex: "#8BC34A")
    
    /// Lavender - Soft, calming accent (#B39DDB)
    static let primaryLavender = Color(hex: "#B39DDB")
    
    // MARK: - Secondary/Accent Colors (Softer Variations)
    
    /// Light Sky Blue - Soft variation of primary sky blue
    static let secondarySkyBlue = Color(hex: "#B3E5FC")
    
    /// Light Sunny Yellow - Pastel variation of sunny yellow  
    static let secondarySunnyYellow = Color(hex: "#FFF9C4")
    
    /// Light Coral Red - Soft variation of coral red
    static let secondaryCoralRed = Color(hex: "#FFCCCB")
    
    /// Light Leaf Green - Pastel variation of leaf green
    static let secondaryLeafGreen = Color(hex: "#DCEDC8")
    
    /// Light Lavender - Soft variation of lavender
    static let secondaryLavender = Color(hex: "#E1BEE7")
    
    // MARK: - Neutral Colors
    
    /// Soft light gray for backgrounds (#F4F4F4)
    static let neutralLightGray = Color(hex: "#F4F4F4")
    
    /// Medium gray for secondary elements (#CFCFCF)
    static let neutralMediumGray = Color(hex: "#CFCFCF")
    
    /// Pure white for contrast
    static let neutralWhite = Color.white
    
    /// Soft black for text
    static let neutralBlack = Color.black
    
    // MARK: - Semantic Colors
    
    /// Primary button background color
    static let buttonPrimary = primaryCoralRed
    
    /// Secondary button background color  
    static let buttonSecondary = primarySkyBlue
    
    /// Success color for achievements
    static let success = primaryLeafGreen
    
    /// Warning color for retry states
    static let warning = primarySunnyYellow
    
    /// Info color for tutorials
    static let info = primarySkyBlue
    
    /// Disabled state color
    static let disabled = neutralMediumGray
    
    // MARK: - Background Colors
    
    /// Main app background
    static let backgroundMain = neutralLightGray
    
    /// Card/container background
    static let backgroundCard = neutralWhite
    
    /// Overlay background (semi-transparent)
    static let backgroundOverlay = Color.black.opacity(0.4)
    
    // MARK: - Interactive States
    
    /// Color for pressed/active states
    static func pressed(_ baseColor: Color) -> Color {
        // Darken the base color for pressed state
        return baseColor.opacity(0.8)
    }
    
    /// Color for hover states
    static func hover(_ baseColor: Color) -> Color {
        // Lighten the base color for hover state
        return baseColor.opacity(0.9)
    }
}

// MARK: - Gradient Colors

extension Color {
    /// Sky blue gradient from light to darker blue
    static var skyBlueGradient: LinearGradient {
        LinearGradient(
            colors: [.primarySkyBlue.opacity(0.8), .primarySkyBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Lavender gradient from light to darker purple
    static var lavenderGradient: LinearGradient {
        LinearGradient(
            colors: [.primaryLavender.opacity(0.8), .primaryLavender],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Leaf green gradient from light to darker green
    static var leafGreenGradient: LinearGradient {
        LinearGradient(
            colors: [.primaryLeafGreen.opacity(0.8), .primaryLeafGreen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Coral red gradient from light to darker red
    static var coralRedGradient: LinearGradient {
        LinearGradient(
            colors: [.primaryCoralRed.opacity(0.8), .primaryCoralRed],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
} 