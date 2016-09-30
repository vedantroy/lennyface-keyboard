//
//  ColorHelper.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/24/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper
{

	static internal func hexStringToUIColor (hex: String) -> UIColor
	{
		var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString

		if (cString.hasPrefix("#"))
		{
			cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
		}

		if ((cString.characters.count) != 6)
		{
			return UIColor.grayColor()
		}

		var rgbValue: UInt32 = 0
		NSScanner(string: cString).scanHexInt(&rgbValue)

		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}

}

enum MainColors: String
{
	case NegativeRed = "D7263D"
	case PositiveGreen = "32CD56"
	case NeutralBlue = "3b5998"
	// case MainBlue = "0197F6""
}