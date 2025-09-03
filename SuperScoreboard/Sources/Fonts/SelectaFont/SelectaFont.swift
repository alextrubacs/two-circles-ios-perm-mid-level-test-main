import SwiftUI

// MARK: - Selecta Font Extension
extension Font {
    /// Selecta Trial font family
    enum Selecta {
        case thin
        case thinItalic
        case light
        case lightItalic
        case regular
        case italic
        case medium
        case mediumItalic
        case bold
        case boldItalic
        case black
        case blackItalic
        
        var fontName: String {
            switch self {
            case .thin:
                return "SelectaTrialUnlicensed-Thin"
            case .thinItalic:
                return "SelectaTrialUnlicensed-ThinItalic"
            case .light:
                return "SelectaTrialUnlicensed-Light"
            case .lightItalic:
                return "SelectaTrialUnlicensed-LightItalic"
            case .regular:
                return "SelectaTrialUnlicensed-Regular"
            case .italic:
                return "SelectaTrialUnlicensed-Italic"
            case .medium:
                return "SelectaTrialUnlicensed-Medium"
            case .mediumItalic:
                return "SelectaTrialUnlicensed-MediumItalic"
            case .bold:
                return "SelectaTrialUnlicensed-Bold"
            case .boldItalic:
                return "SelectaTrialUnlicensed-BoldItalic"
            case .black:
                return "SelectaTrialUnlicensed-Black"
            case .blackItalic:
                return "SelectaTrialUnlicensed-BlackItalic"
            }
        }
        
        /// Create a SwiftUI Font with the specified size
        func font(size: CGFloat) -> Font {
            return Font.custom(fontName, size: size)
        }
        
        /// Create a SwiftUI Font with the specified text style
        func font(_ style: Font.TextStyle) -> Font {
            return Font.custom(fontName, size: style.size)
        }
    }
    
    /// Convenience method to create Selecta fonts
    static func selecta(_ weight: Selecta, size: CGFloat) -> Font {
        return weight.font(size: size)
    }
    
    /// Convenience method to create Selecta fonts with text style
    static func selecta(_ weight: Selecta, style: Font.TextStyle) -> Font {
        return weight.font(style)
    }
}

// MARK: - Font.TextStyle Extension
extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        @unknown default:
            return 17
        }
    }
}
