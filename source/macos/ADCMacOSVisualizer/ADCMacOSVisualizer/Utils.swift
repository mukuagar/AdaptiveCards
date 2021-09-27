import AdaptiveCards
import Cocoa

extension NSColor {
    static func color(from hexString: String) -> NSColor? {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        guard hexString.count == 6 || hexString.count == 8 else {
            print("Not valid HexCode: \(hexString)")
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        // Need to revisit and validate
        switch hexString.count {
        case 6: return NSColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                               green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                               blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                               alpha: CGFloat(1.0))
            
        case 8: return NSColor(red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                               green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                               blue: CGFloat((rgbValue & 0x000000FF)) / 255.0,
                               alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0)
        
        default:
            print("Not valid HexCode: \(hexString)")
            return nil
        }
    }
}

struct Constants {
    // HexCodeFormat: #AARRGGBB
    static let lightThemeDefault = "#F2000000"
    static let lightThemeDefaultBorder = "#F2000000"
    static let lightThemeDefaultHover = "#CC000000"
    static let lightThemeDefaultPressed = "#B2000000"
    static let lightThemeDefaultPressedBorderColor = "#B2000000"
    static let lightThemeDefaultTextColor = "#F2FFFFFF"
    static let lightThemeDefaultSelectedTextColor = "#F2FFFFFF"
    
    static let lightThemePositive = "#FFFFFFFF"
    static let lightThemePositiveBorder = "#FF185E46"
    static let lightThemePositiveHover = "FF185E46"
    static let lightThemePositivePressed = "#FF134231"
    static let lightThemePositivePressedBorderColor = "#FF134231"
    static let lightThemePositiveTextColor = "#FF185E46"
    static let lightThemePositiveSelectedTextColor = "#F2FFFFFF"
    
    static let lightThemeDestructive = "#FFFFFFFF"
    static let lightThemeDestructiveBorder = "#FFAB0A15"
    static let lightThemeDestructiveHover = "FFAB0A15"
    static let lightThemeDestructivePressed = "#FF780D13"
    static let lightThemeDestructivePressedBorderColor = "#FF780D13"
    static let lightThemeDestructiveTextColor = "#FFAB0A15"
    static let lightThemeDestructiveSelectedTextColor = "#F2FFFFFF"
    
    static let darkThemeDefault = "#F2FFFFFF"
    static let darkThemeDefaultBorder = "#F2FFFFFF"
    static let darkThemeDefaultHover = "#CCFFFFFF"
    static let darkThemeDefaultPressed = "#B2FFFFFF"
    static let darkThemeDefaultPressedBorderColor = "#B2FFFFFF"
    static let darkThemeDefaultTextColor = "#F2000000"
    static let darkThemeDefaultSelectedTextColor = "#F2000000"
    
    static let darkThemePositive = "#FF1A1A1A"
    static let darkThemePositiveBorder = "#FF3CC29A"
    static let darkThemePositiveHover = "FF185E46"
    static let darkThemePositivePressed = "#FF134231"
    static let darkThemePositivePressedBorderColor = "#FF134231"
    static let darkThemePositiveTextColor = "#FF3CC29A"
    static let darkThemePositiveSelectedTextColor = "#F2FFFFFF"
    
    static let darkThemeDestructive = "#FF1A1A1A"
    static let darkThemeDestructiveBorder = "#FFFC8B98"
    static let darkThemeDestructiveHover = "FFAB0A15"
    static let darkThemeDestructivePressed = "#FF780D13"
    static let darkThemeDestructivePressedBorderColor = "#FF780D13"
    static let darkThemeDestructiveTextColor = "#FFFC8B98"
    static let darkThemeDestructiveSelectedTextColor = "#F2FFFFFF"
}
