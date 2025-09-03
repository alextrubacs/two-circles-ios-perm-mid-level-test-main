import SwiftUI

// MARK: - Color Hex Extension
extension Color {
    
    /// Initialize Color from hex string
    /// Supports formats: "#FFFFFF", "FFFFFF", "#FFF", "FFF", "#FFFFFFFF", "FFFFFFFF"
    /// - Parameter hex: Hex color string
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString)
        
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            switch hexString.count - (hexString.hasPrefix("#") ? 1 : 0) {
            case 3: // RGB (12-bit)
                let r = (hexNumber >> 8) & 0xF
                let g = (hexNumber >> 4) & 0xF
                let b = hexNumber & 0xF
                
                self.init(
                    red: Double(r + (r << 4)) / 255.0,
                    green: Double(g + (g << 4)) / 255.0,
                    blue: Double(b + (b << 4)) / 255.0
                )
                
            case 6: // RGB (24-bit)
                self.init(
                    red: Double((hexNumber & 0xFF0000) >> 16) / 255.0,
                    green: Double((hexNumber & 0x00FF00) >> 8) / 255.0,
                    blue: Double(hexNumber & 0x0000FF) / 255.0
                )
                
            case 8: // ARGB (32-bit)
                self.init(
                    red: Double((hexNumber & 0x00FF0000) >> 16) / 255.0,
                    green: Double((hexNumber & 0x0000FF00) >> 8) / 255.0,
                    blue: Double(hexNumber & 0x000000FF) / 255.0,
                    opacity: Double((hexNumber & 0xFF000000) >> 24) / 255.0
                )
                
            default:
                // Invalid format, default to clear
                self.init(.clear)
            }
        } else {
            // Invalid hex string, default to clear
            self.init(.clear)
        }
    }
    
    /// Initialize Color from hex integer
    /// - Parameter hex: Hex color as UInt (e.g., 0xFF0000 for red)
    init(hex: UInt) {
        self.init(
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0
        )
    }
    
    /// Initialize Color from hex integer with alpha
    /// - Parameters:
    ///   - hex: Hex color as UInt (e.g., 0xFF0000 for red)
    ///   - alpha: Alpha value (0.0 to 1.0)
    init(hex: UInt, alpha: Double) {
        self.init(
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
    
    /// Convert Color to hex string
    /// - Parameter includeAlpha: Whether to include alpha in the output
    /// - Returns: Hex string representation (e.g., "#FF0000" or "#FF0000FF")
    func toHex(includeAlpha: Bool = false) -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}

// MARK: - Convenience Static Colors
extension Color {
    /// Common brand colors
    static let brandPrimary = Color(hex: "#007AFF")
    static let brandSecondary = Color(hex: "#5856D6")
    static let brandSuccess = Color(hex: "#34C759")
    static let brandWarning = Color(hex: "#FF9500")
    static let brandDanger = Color(hex: "#FF3B30")
    
    /// Common gray shades
    static let gray50 = Color(hex: "#F9FAFB")
    static let gray100 = Color(hex: "#F3F4F6")
    static let gray200 = Color(hex: "#E5E7EB")
    static let gray300 = Color(hex: "#D1D5DB")
    static let gray400 = Color(hex: "#9CA3AF")
    static let gray500 = Color(hex: "#6B7280")
    static let gray600 = Color(hex: "#4B5563")
    static let gray700 = Color(hex: "#374151")
    static let gray800 = Color(hex: "#1F2937")
    static let gray900 = Color(hex: "#111827")
}
