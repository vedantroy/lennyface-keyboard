//
//  Helper.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/29/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit

extension UIButton
{
	private func imageWithColor(color: UIColor) -> UIImage
	{
		let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()

		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}

	func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState)
	{
		self.setBackgroundImage(imageWithColor(color), forState: state)
	}
}

class Helper
{

	private static let headerFontSize: CGFloat = UIFont.buttonFontSize() + 12
	internal static let systemButtonFont: UIFont = UIFont.systemFontOfSize(UIFont.buttonFontSize())

	internal static func setupButton(sender: UIButton, normalcolorhex: String, pressedcolorhex: String, title: String, parentView: UIView)
	{
		sender.translatesAutoresizingMaskIntoConstraints = false
		parentView.addSubview(sender)
		sender.backgroundColor = ColorHelper.hexStringToUIColor(normalcolorhex)
		sender.setBackgroundColor(ColorHelper.hexStringToUIColor(pressedcolorhex), forUIControlState: .Highlighted)
		sender.layer.masksToBounds = true
		sender.layer.cornerRadius = 4
		sender.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
		sender.setTitle(title, forState: .Normal)
		sender.titleLabel?.adjustsFontSizeToFitWidth = true
	}

	internal static func setupHeader(sender: UILabel, normalcolorhex: String, title: String, parentView: UIView)
	{
		sender.translatesAutoresizingMaskIntoConstraints = false
		parentView.addSubview(sender)

		sender.widthAnchor.constraintEqualToAnchor(parentView.widthAnchor).active = true
		sender.heightAnchor.constraintEqualToAnchor(parentView.heightAnchor, multiplier: 0.25).active = true
		sender.trailingAnchor.constraintEqualToAnchor(parentView.trailingAnchor).active = true
		sender.topAnchor.constraintEqualToAnchor(parentView.topAnchor).active = true

		sender.textColor = UIColor.whiteColor()
		sender.textAlignment = .Center
		sender.font = UIFont.boldSystemFontOfSize(Helper.headerFontSize)
		sender.adjustsFontSizeToFitWidth = true
		sender.backgroundColor = ColorHelper.hexStringToUIColor(normalcolorhex)

		sender.text = title

	}

	internal static func setupInformativeTextView(sender: UITextView, text: String, parentView: UIView)
	{
		sender.translatesAutoresizingMaskIntoConstraints = false
		parentView.addSubview(sender)
		sender.text = text
		sender.editable = false
		sender.selectable = false
		sender.textAlignment = .Center
		sender.font = Helper.systemButtonFont
	}

	internal static func setupBasicView(sender: UIView, parentView: UIView)
	{
		sender.translatesAutoresizingMaskIntoConstraints = false
		parentView.addSubview(sender)
	}

	internal static func pinHorizontalAnchorsToSuperView(sender: UIView, parentView: UIView)
	{
		sender.trailingAnchor.constraintEqualToAnchor(parentView.trailingAnchor).active = true
		sender.leadingAnchor.constraintEqualToAnchor(parentView.leadingAnchor).active = true
	}

}