//
//  ColorsExtension.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // MARK: - Main Colors

    static var snBackground: UIColor { UIColor(named: "Background") ?? UIColor.white }
    static var snBackgroundCell: UIColor { UIColor(named: "BackgroundCell") ?? UIColor.lightGray }
    static var snMainColor: UIColor { UIColor(named: "MainColor") ?? UIColor.blue }
    static var snText: UIColor { UIColor(named: "TextColor") ?? UIColor.blue }
    static var snCellBorder: UIColor { UIColor(named: "CellBorderColor") ?? UIColor.blue }


    // MARK: - Notes Colors

    static var snColor1: UIColor { UIColor(named: "NotesColor1") ?? UIColor.red }
    static var snColor2: UIColor { UIColor(named: "NotesColor2") ?? UIColor.orange }
    static var snColor3: UIColor { UIColor(named: "NotesColor3") ?? UIColor.yellow }
    static var snColor4: UIColor { UIColor(named: "NotesColor4") ?? UIColor.green }
    static var snColor5: UIColor { UIColor(named: "NotesColor5") ?? UIColor.systemMint  }
    static var snColor6: UIColor { UIColor(named: "NotesColor6") ?? UIColor.blue }
    static var snColor7: UIColor { UIColor(named: "NotesColor7") ?? UIColor.purple }
    static var snColor8: UIColor { UIColor(named: "NotesColor8") ?? UIColor.magenta }
    static var snColor9: UIColor { UIColor(named: "NotesColor9") ?? UIColor.systemPurple }
    static var snColor10: UIColor { UIColor(named: "NotesColor10") ?? UIColor.systemPink }

}

