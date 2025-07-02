import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "airplane" asset catalog image resource.
    static let airplane = DeveloperToolsSupport.ImageResource(name: "airplane", bundle: resourceBundle)

    /// The "alligator" asset catalog image resource.
    static let alligator = DeveloperToolsSupport.ImageResource(name: "alligator", bundle: resourceBundle)

    /// The "ant" asset catalog image resource.
    static let ant = DeveloperToolsSupport.ImageResource(name: "ant", bundle: resourceBundle)

    /// The "apple" asset catalog image resource.
    static let apple = DeveloperToolsSupport.ImageResource(name: "apple", bundle: resourceBundle)

    /// The "letter-a-base" asset catalog image resource.
    static let letterABase = DeveloperToolsSupport.ImageResource(name: "letter-a-base", bundle: resourceBundle)

    /// The "letter-a-character" asset catalog image resource.
    static let letterACharacter = DeveloperToolsSupport.ImageResource(name: "letter-a-character", bundle: resourceBundle)

    /// The "letter-a-eye-white-dots" asset catalog image resource.
    static let letterAEyeWhiteDots = DeveloperToolsSupport.ImageResource(name: "letter-a-eye-white-dots", bundle: resourceBundle)

    /// The "letter-a-eye-whites" asset catalog image resource.
    static let letterAEyeWhites = DeveloperToolsSupport.ImageResource(name: "letter-a-eye-whites", bundle: resourceBundle)

    /// The "letter-a-eye-whites-with-dots" asset catalog image resource.
    static let letterAEyeWhitesWithDots = DeveloperToolsSupport.ImageResource(name: "letter-a-eye-whites-with-dots", bundle: resourceBundle)

    /// The "letter-a-eyebrows" asset catalog image resource.
    static let letterAEyebrows = DeveloperToolsSupport.ImageResource(name: "letter-a-eyebrows", bundle: resourceBundle)

    /// The "letter-a-eyes-half" asset catalog image resource.
    static let letterAEyesHalf = DeveloperToolsSupport.ImageResource(name: "letter-a-eyes-half", bundle: resourceBundle)

    /// The "letter-a-eyes-open" asset catalog image resource.
    static let letterAEyesOpen = DeveloperToolsSupport.ImageResource(name: "letter-a-eyes-open", bundle: resourceBundle)

    /// The "letter-a-eyes-wide" asset catalog image resource.
    static let letterAEyesWide = DeveloperToolsSupport.ImageResource(name: "letter-a-eyes-wide", bundle: resourceBundle)

    /// The "letter-a-eyes-wide 1" asset catalog image resource.
    static let letterAEyesWide1 = DeveloperToolsSupport.ImageResource(name: "letter-a-eyes-wide 1", bundle: resourceBundle)

    /// The "letter-a-left-wink" asset catalog image resource.
    static let letterALeftWink = DeveloperToolsSupport.ImageResource(name: "letter-a-left-wink", bundle: resourceBundle)

    /// The "letter-a-mouth" asset catalog image resource.
    static let letterAMouth = DeveloperToolsSupport.ImageResource(name: "letter-a-mouth", bundle: resourceBundle)

    /// The "letter-a-pupils" asset catalog image resource.
    static let letterAPupils = DeveloperToolsSupport.ImageResource(name: "letter-a-pupils", bundle: resourceBundle)

    /// The "letter_a_box" asset catalog image resource.
    static let letterABox = DeveloperToolsSupport.ImageResource(name: "letter_a_box", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "airplane" asset catalog image.
    static var airplane: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .airplane)
#else
        .init()
#endif
    }

    /// The "alligator" asset catalog image.
    static var alligator: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .alligator)
#else
        .init()
#endif
    }

    /// The "ant" asset catalog image.
    static var ant: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ant)
#else
        .init()
#endif
    }

    /// The "apple" asset catalog image.
    static var apple: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .apple)
#else
        .init()
#endif
    }

    /// The "letter-a-base" asset catalog image.
    static var letterABase: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterABase)
#else
        .init()
#endif
    }

    /// The "letter-a-character" asset catalog image.
    static var letterACharacter: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterACharacter)
#else
        .init()
#endif
    }

    /// The "letter-a-eye-white-dots" asset catalog image.
    static var letterAEyeWhiteDots: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyeWhiteDots)
#else
        .init()
#endif
    }

    /// The "letter-a-eye-whites" asset catalog image.
    static var letterAEyeWhites: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyeWhites)
#else
        .init()
#endif
    }

    /// The "letter-a-eye-whites-with-dots" asset catalog image.
    static var letterAEyeWhitesWithDots: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyeWhitesWithDots)
#else
        .init()
#endif
    }

    /// The "letter-a-eyebrows" asset catalog image.
    static var letterAEyebrows: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyebrows)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-half" asset catalog image.
    static var letterAEyesHalf: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyesHalf)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-open" asset catalog image.
    static var letterAEyesOpen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyesOpen)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-wide" asset catalog image.
    static var letterAEyesWide: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyesWide)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-wide 1" asset catalog image.
    static var letterAEyesWide1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAEyesWide1)
#else
        .init()
#endif
    }

    /// The "letter-a-left-wink" asset catalog image.
    static var letterALeftWink: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterALeftWink)
#else
        .init()
#endif
    }

    /// The "letter-a-mouth" asset catalog image.
    static var letterAMouth: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAMouth)
#else
        .init()
#endif
    }

    /// The "letter-a-pupils" asset catalog image.
    static var letterAPupils: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterAPupils)
#else
        .init()
#endif
    }

    /// The "letter_a_box" asset catalog image.
    static var letterABox: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .letterABox)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "airplane" asset catalog image.
    static var airplane: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .airplane)
#else
        .init()
#endif
    }

    /// The "alligator" asset catalog image.
    static var alligator: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .alligator)
#else
        .init()
#endif
    }

    /// The "ant" asset catalog image.
    static var ant: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ant)
#else
        .init()
#endif
    }

    /// The "apple" asset catalog image.
    static var apple: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .apple)
#else
        .init()
#endif
    }

    /// The "letter-a-base" asset catalog image.
    static var letterABase: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterABase)
#else
        .init()
#endif
    }

    /// The "letter-a-character" asset catalog image.
    static var letterACharacter: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterACharacter)
#else
        .init()
#endif
    }

    /// The "letter-a-eye-white-dots" asset catalog image.
    static var letterAEyeWhiteDots: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyeWhiteDots)
#else
        .init()
#endif
    }

    /// The "letter-a-eye-whites" asset catalog image.
    static var letterAEyeWhites: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyeWhites)
#else
        .init()
#endif
    }

    /// The "letter-a-eye-whites-with-dots" asset catalog image.
    static var letterAEyeWhitesWithDots: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyeWhitesWithDots)
#else
        .init()
#endif
    }

    /// The "letter-a-eyebrows" asset catalog image.
    static var letterAEyebrows: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyebrows)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-half" asset catalog image.
    static var letterAEyesHalf: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyesHalf)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-open" asset catalog image.
    static var letterAEyesOpen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyesOpen)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-wide" asset catalog image.
    static var letterAEyesWide: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyesWide)
#else
        .init()
#endif
    }

    /// The "letter-a-eyes-wide 1" asset catalog image.
    static var letterAEyesWide1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAEyesWide1)
#else
        .init()
#endif
    }

    /// The "letter-a-left-wink" asset catalog image.
    static var letterALeftWink: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterALeftWink)
#else
        .init()
#endif
    }

    /// The "letter-a-mouth" asset catalog image.
    static var letterAMouth: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAMouth)
#else
        .init()
#endif
    }

    /// The "letter-a-pupils" asset catalog image.
    static var letterAPupils: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterAPupils)
#else
        .init()
#endif
    }

    /// The "letter_a_box" asset catalog image.
    static var letterABox: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .letterABox)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

