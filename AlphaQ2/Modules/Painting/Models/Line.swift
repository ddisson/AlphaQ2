#if os(iOS)
import UIKit // For UIColor
#elseif os(macOS)
import AppKit // For NSColor
#endif
import SwiftUI // For CGPoint, Color

/// Represents a single continuous line drawn by the user.
struct Line: Identifiable {
    let id = UUID()
    var points: [CGPoint] = []
    // Add properties for color and line width
    var color: Color = .black // Default to black
    var lineWidth: CGFloat = 5.0 // Default width
    // We will add color and lineWidth later when integrating the palette
    // var color: Color = .black
    // var lineWidth: CGFloat = 5.0
}

#if os(iOS)
typealias PlatformColor = UIColor
#elseif os(macOS)
typealias PlatformColor = NSColor
#endif 
