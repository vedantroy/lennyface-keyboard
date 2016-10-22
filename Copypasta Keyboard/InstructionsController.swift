//
//  InstructionsController.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/23/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit

extension UILabel
{

	func underLine()
	{

		if let textUnwrapped = self.text
		{

			let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
			let underlineAttributedString = NSAttributedString(string: textUnwrapped, attributes: underlineAttribute)
			self.attributedText = underlineAttributedString

		}

	}

}

class InstructionsController: UIViewController
{

	private let trialVersionHeading = UILabel()
	private let fullVersionHeading = UILabel()

	private let trialVersionText = UITextView()
	private let fullVersionText = UITextView()

	private let instructionsText = "Use Trial Version"
	private let headerFontSize: CGFloat = UIFont.buttonFontSize() + 12

	override func viewDidLoad()
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		let screenHeight = UIScreen.mainScreen().bounds.height
		// screenColorHeader = screenHeight * 0.25
		//

		let dividerMargin = (screenHeight - (screenHeight * 0.25) - TabsController.tabBarHeight) / 6

		let screenColorHeader = UILabel()
		Helper.setupHeader(screenColorHeader, normalcolorhex: MainColors.NeutralBlue.rawValue, title: "Instructions", parentView: self.view)

		fullVersionHeading.text = "Use Free Version"
		formatHeaderLabel(fullVersionHeading)
		fullVersionHeading.centerYAnchor.constraintEqualToAnchor(screenColorHeader.bottomAnchor, constant: dividerMargin * 0.5).active = true

		Helper.setupInformativeTextView(trialVersionText, text: "Press setup button below and follow directions to enable the keyboard.", parentView: view)
		trialVersionText.topAnchor.constraintEqualToAnchor(fullVersionHeading.bottomAnchor).active = true
		trialVersionText.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -screenWidth * 0.1).active = true
		trialVersionText.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: screenWidth * 0.1).active = true
		trialVersionText.scrollEnabled = false

		Helper.setupInformativeTextView(fullVersionText, text: "Get the full version from the upgrade tab. Enable the keyboard and allow full access in the setup tab.\n\n Copypasta keyboard requires full access to verify purchase of the full version. We only have access to Copypasta keyboard's keystrokes and do not record them.", parentView: view)
		fullVersionText.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -(TabsController.tabBarHeight + dividerMargin * 0.5)).active = true
		fullVersionText.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -screenWidth * 0.1).active = true
		fullVersionText.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: screenWidth * 0.1).active = true
		fullVersionText.scrollEnabled = false

		trialVersionHeading.text = "Use Upgraded Version"
		formatHeaderLabel(trialVersionHeading)
		trialVersionHeading.bottomAnchor.constraintEqualToAnchor(fullVersionText.topAnchor).active = true

	}

	private func formatHeaderLabel(inputLabel: UILabel)
	{
		let screenWidth = UIScreen.mainScreen().bounds.width

		let boldFont = UIFont.boldSystemFontOfSize(UIFont.labelFontSize() + 3)

		view.addSubview(inputLabel)
		inputLabel.font = boldFont
		inputLabel.translatesAutoresizingMaskIntoConstraints = false
		inputLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -screenWidth * 0.1).active = true
		inputLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: screenWidth * 0.1).active = true
		inputLabel.adjustsFontSizeToFitWidth = true
		inputLabel.textAlignment = .Center
		inputLabel.textColor = UIColor.blackColor()
	}

}
