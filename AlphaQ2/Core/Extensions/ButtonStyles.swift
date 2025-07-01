import SwiftUI

// MARK: - Primary Button Style

/// Primary button style following the Pixar-inspired art style guide
/// Features: Rounded corners, bold colors, bouncy animations, large tap targets
struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = .buttonPrimary
    var textColor: Color = .neutralWhite
    var isLarge: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TypographyStyles.buttonPrimary)
            .foregroundColor(textColor)
            .frame(minHeight: isLarge ? 60 : 50) // Large tap targets for children
            .frame(maxWidth: .infinity)
            .padding(.horizontal, isLarge ? 24 : 20)
            .background(
                RoundedRectangle(cornerRadius: isLarge ? 30 : 25)
                    .fill(backgroundColor)
                    .shadow(
                        color: backgroundColor.opacity(0.3),
                        radius: configuration.isPressed ? 2 : 8,
                        x: 0,
                        y: configuration.isPressed ? 2 : 4
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style

/// Secondary button style for less prominent actions
struct SecondaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = .buttonSecondary
    var textColor: Color = .neutralWhite
    var isLarge: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TypographyStyles.buttonSecondary)
            .foregroundColor(textColor)
            .frame(minHeight: isLarge ? 55 : 45)
            .padding(.horizontal, isLarge ? 20 : 16)
            .background(
                RoundedRectangle(cornerRadius: isLarge ? 27 : 22)
                    .fill(backgroundColor)
                    .shadow(
                        color: backgroundColor.opacity(0.2),
                        radius: configuration.isPressed ? 1 : 6,
                        x: 0,
                        y: configuration.isPressed ? 1 : 3
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Capsule Button Style

/// Pill-shaped button style for navigation and action buttons
struct CapsuleButtonStyle: ButtonStyle {
    var backgroundColor: Color = .primarySunnyYellow
    var textColor: Color = .neutralBlack
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TypographyStyles.buttonSecondary)
            .foregroundColor(textColor)
            .frame(minHeight: 50)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(backgroundColor)
                    .shadow(
                        color: backgroundColor.opacity(0.3),
                        radius: configuration.isPressed ? 2 : 6,
                        x: 0,
                        y: configuration.isPressed ? 1 : 3
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Icon Button Style

/// Round icon button style for compact actions
struct IconButtonStyle: ButtonStyle {
    var backgroundColor: Color = .primarySkyBlue
    var size: CGFloat = 60
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .foregroundColor(.neutralWhite)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(backgroundColor)
                    .shadow(
                        color: backgroundColor.opacity(0.3),
                        radius: configuration.isPressed ? 2 : 8,
                        x: 0,
                        y: configuration.isPressed ? 2 : 4
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

// MARK: - Success Button Style

/// Special button style for success/completion states
struct SuccessButtonStyle: ButtonStyle {
    var backgroundColor: Color = .success
    var textColor: Color = .neutralWhite
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TypographyStyles.buttonPrimary)
            .foregroundColor(textColor)
            .frame(minHeight: 60)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(backgroundColor)
                    .overlay(
                        // Add subtle sparkle effect for success
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [.neutralWhite.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: backgroundColor.opacity(0.4),
                        radius: configuration.isPressed ? 3 : 10,
                        x: 0,
                        y: configuration.isPressed ? 2 : 5
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Warning Button Style

/// Button style for retry/warning states
struct WarningButtonStyle: ButtonStyle {
    var backgroundColor: Color = .warning
    var textColor: Color = .neutralBlack
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TypographyStyles.buttonSecondary)
            .foregroundColor(textColor)
            .frame(minHeight: 55)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 27)
                    .fill(backgroundColor)
                    .shadow(
                        color: backgroundColor.opacity(0.3),
                        radius: configuration.isPressed ? 2 : 6,
                        x: 0,
                        y: configuration.isPressed ? 1 : 3
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Disabled Button Style

/// Button style for disabled states
struct DisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(TypographyStyles.buttonSecondary)
            .foregroundColor(.neutralMediumGray)
            .frame(minHeight: 50)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.disabled.opacity(0.3))
            )
            .opacity(0.6)
    }
}

// MARK: - Button Style Extensions

extension ButtonStyle where Self == PrimaryButtonStyle {
    /// Primary button style with default coral red background
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
    
    /// Primary button style with custom background color
    static func primary(backgroundColor: Color, textColor: Color = .neutralWhite, isLarge: Bool = true) -> PrimaryButtonStyle {
        PrimaryButtonStyle(backgroundColor: backgroundColor, textColor: textColor, isLarge: isLarge)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    /// Secondary button style with default sky blue background
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
    
    /// Secondary button style with custom background color
    static func secondary(backgroundColor: Color, textColor: Color = .neutralWhite, isLarge: Bool = false) -> SecondaryButtonStyle {
        SecondaryButtonStyle(backgroundColor: backgroundColor, textColor: textColor, isLarge: isLarge)
    }
}

extension ButtonStyle where Self == CapsuleButtonStyle {
    /// Capsule button style with default sunny yellow background
    static var capsule: CapsuleButtonStyle {
        CapsuleButtonStyle()
    }
    
    /// Capsule button style with custom background color
    static func capsule(backgroundColor: Color, textColor: Color = .neutralBlack) -> CapsuleButtonStyle {
        CapsuleButtonStyle(backgroundColor: backgroundColor, textColor: textColor)
    }
}

extension ButtonStyle where Self == IconButtonStyle {
    /// Icon button style with default sky blue background
    static var icon: IconButtonStyle {
        IconButtonStyle()
    }
    
    /// Icon button style with custom background color and size
    static func icon(backgroundColor: Color, size: CGFloat = 60) -> IconButtonStyle {
        IconButtonStyle(backgroundColor: backgroundColor, size: size)
    }
}

extension ButtonStyle where Self == SuccessButtonStyle {
    /// Success button style with default green background
    static var success: SuccessButtonStyle {
        SuccessButtonStyle()
    }
}

extension ButtonStyle where Self == WarningButtonStyle {
    /// Warning button style with default yellow background
    static var warning: WarningButtonStyle {
        WarningButtonStyle()
    }
}

extension ButtonStyle where Self == DisabledButtonStyle {
    /// Disabled button style
    static var disabled: DisabledButtonStyle {
        DisabledButtonStyle()
    }
}

// MARK: - View Modifiers for Buttons

extension View {
    /// Apply primary button styling
    func primaryButtonStyle() -> some View {
        self.buttonStyle(.primary)
    }
    
    /// Apply secondary button styling
    func secondaryButtonStyle() -> some View {
        self.buttonStyle(.secondary)
    }
    
    /// Apply capsule button styling
    func capsuleButtonStyle() -> some View {
        self.buttonStyle(.capsule)
    }
    
    /// Apply icon button styling
    func iconButtonStyle() -> some View {
        self.buttonStyle(.icon)
    }
    
    /// Apply success button styling
    func successButtonStyle() -> some View {
        self.buttonStyle(.success)
    }
    
    /// Apply warning button styling
    func warningButtonStyle() -> some View {
        self.buttonStyle(.warning)
    }
    
    /// Apply disabled button styling
    func disabledButtonStyle() -> some View {
        self.buttonStyle(.disabled)
    }
} 