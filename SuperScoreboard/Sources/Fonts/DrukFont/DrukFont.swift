import SwiftUI

// MARK: - Druk Wide Font Extension
extension Font {
    /// Druk Wide font family
    enum DrukWide {
        case bold
        
        var fontName: String {
            switch self {
            case .bold:
                return "DrukWideTrial-Bold"
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
    
    /// Convenience method to create Druk Wide fonts
    static func drukWide(_ weight: DrukWide, size: CGFloat) -> Font {
        return weight.font(size: size)
    }
    
    /// Convenience method to create Druk Wide fonts with text style
    static func drukWide(_ weight: DrukWide, style: Font.TextStyle) -> Font {
        return weight.font(style)
    }
}
