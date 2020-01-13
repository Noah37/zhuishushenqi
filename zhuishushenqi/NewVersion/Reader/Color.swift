//
//  Color.swift
//  dlxk
//
//  Created by caony on 2019/11/30.
//  Copyright © 2019 dlxk. All rights reserved.
//

import Foundation
import UIKit

class TableViewColor {
    
    var backgroundColor:UIColor { return UIColor.Noah.TableNormalBackground }
    var rowBackgroundColor:UIColor { return UIColor.Noah.NormalBackground }
    var rowText:UIColor { return UIColor.Noah.NormalText }
    var detailText:UIColor { return UIColor.Noah.NormalDetailText }
    var headerBackground:UIColor { return UIColor.Noah.TableNormalBackground }
    var separator: UIColor { return UIColor.Noah.NormalGray }
}

class DarkTableViewColor:TableViewColor {
    override var backgroundColor:UIColor { return UIColor.Noah.TableGrayBackground }
    override var rowBackgroundColor:UIColor { return UIColor.Noah.NormalGrayBackground }
    override var rowText:UIColor { return UIColor.Noah.WhiteText }
    override var detailText:UIColor { return UIColor.Noah.DarkDetailText }
    override var headerBackground:UIColor { return UIColor.Noah.TableGrayBackground }
    override var separator: UIColor { return UIColor.Noah.WhiteText }
}

class TabBarColor {
    var backgroundColor:UIColor { return UIColor.Noah.NormalBackground }
    var titleTextColor:UIColor { return UIColor.Noah.TabBarTitle }
    var titleTextSelectedColor:UIColor { return UIColor.Noah.TabBarTitleSelected }

}

class DarkTabBarColor:TabBarColor {
    override var backgroundColor:UIColor { return UIColor.Noah.NormalGrayBackground }
    override var titleTextColor:UIColor { return UIColor.Noah.TabBarTitleDark }
    override var titleTextSelectedColor:UIColor { return UIColor.Noah.TabBarTitleDarkSelected }
}

class NavitaionBarColor {
    var backgroundColor:UIColor { return UIColor.Noah.NormalNavBackground }
    var barTintColor:UIColor { return UIColor.Noah.WhiteText }
    var tintColor:UIColor { return UIColor.Noah.OnTintRed }
}

class DarkNavitaionBarColor:NavitaionBarColor {
    override var backgroundColor:UIColor { return UIColor.Noah.NormalNavBackground }
    override var barTintColor:UIColor { return UIColor.Noah.NormalGrayBackground }
    override var tintColor:UIColor { return UIColor.Noah.WhiteText }
}

class GeneralColor {
    var faviconBackground: UIColor { return UIColor.clear }
    var passcodeDot: UIColor { return UIColor.Noah.NormalGray }
    var highlightBlue: UIColor { return UIColor.Noah.HighlightBlue }
    var destructiveRed: UIColor { return UIColor.Noah.NormalRed }
    var separator: UIColor { return UIColor.Noah.NormalGray }
    var settingsTextPlaceholder: UIColor? { return nil }
    var controlTint: UIColor { return UIColor.Noah.OnTintRed }
}

extension UIColor {
    struct Noah {
        static let NormalBackground = UIColor.white
        static let DarkCellBackground = UIColor.black
        static let NormalGray = UIColor(red:0.22, green:0.22, blue:0.24, alpha:1.00)
        static let NormalGrayBackground = UIColor(red:0.22, green:0.22, blue:0.24, alpha:1.00)
        static let TableNormalBackground = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        static let TableGrayBackground = UIColor(red:0.16, green:0.16, blue:0.18, alpha:1.00)
        static let NormalNavBackground = UIColor.red
        static let WhiteText = UIColor.white
        static let NormalText = UIColor.black
        static let NormalDetailText = UIColor.gray
        static let DarkDetailText = UIColor(white: 0.6, alpha: 1.0)
        static let HighlightBlue = UIColor.blue
        static let OnTintRed = UIColor(red:1.00, green:0.44, blue:0.45, alpha:1.00)
        static let NormalRed = UIColor.red
        static let TabBarTitle = UIColor(red: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1.0)
        static let TabBarTitleSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
        static let TabBarTitleDark = UIColor(red: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1.0)
        static let TabBarTitleDarkSelected = UIColor.white
    }
}
