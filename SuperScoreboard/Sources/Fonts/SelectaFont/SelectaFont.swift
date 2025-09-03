import SwiftUI

// MARK: - Selecta Font Extension
extension Font {
    /// Selecta Trial font family
    enum Selecta {
        case medium
        case regular
        case bold

        var fontName: String {
            switch self {
            case .medium:
                "SelectaTrialUnlicensed-Medium"
            case .regular:
                "SelectaTrialUnlicensed-Regular"
            case .bold:
                "SelectaTrialUnlicensed-Bold"
            }
        }

        /// Create a SwiftUI Font with the specified size
        func font(size: CGFloat) -> Font {
            Font.custom(fontName, size: size)
        }
    }

    /// Convenience method to create Selecta fonts
    static func selecta(_ weight: Selecta, size: CGFloat) -> Font {
        weight.font(size: size)
    }
}
