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