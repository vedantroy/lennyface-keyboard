//
//  SetupController.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/23/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit

enum InstructionsText: String
{
	case Enable = "\n \n \n Open Settings \n \n Tap \"General\" \n \n Tap \"Keyboard\" \n \n Tap \"Keyboards\" \n \n Tap \"Add New Keyboard...\" \n \n Tap \"Copypasta Keyboard\""
	case FullAccess = "\n \n \n Open \"Settings\" \n \n Tap \"General\" \n \n Tap \"Keyboard\" \n \n Tap \"Keyboards\" \n \n Tap \"Copypasta\" \n \n Toggle \"Allow Full Access\""
	case Unset = "UNSET"
}

class SetupController: UIViewController
{

	private let screenColorHeader = UILabel()
	private let settingsInstructions = UITextView()
	private let purchaseReminder = UITextView()
	let settingsButton = UIButton()
	let fullAccessNote = UILabel()

	var enabled = false
	var purchased = false

	private var screenHeight: CGFloat = 0.0

	private let headerFontSize: CGFloat = UIFont.buttonFontSize() + 12

	override func viewDidLoad()
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		screenHeight = UIScreen.mainScreen().bounds.height

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)

		Helper.setupHeader(screenColorHeader, normalcolorhex: MainColors.NeutralBlue.rawValue, title: "UNSET", parentView: view)
		screenColorHeader.numberOfLines = 2

		Helper.setupInformativeTextView(settingsInstructions, text: InstructionsText.Unset.rawValue, parentView: view)

		settingsInstructions.topAnchor.constraintEqualToAnchor(screenColorHeader.bottomAnchor).active = true
		settingsInstructions.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.5).active = true
		settingsInstructions.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
		settingsInstructions.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true

		Helper.setupInformativeTextView(purchaseReminder, text: "Upgrade to the full version to access 50+ copypastas.", parentView: view)

		purchaseReminder.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: screenWidth * 0.1).active = true
		purchaseReminder.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -screenWidth * 0.1).active = true
		purchaseReminder.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.5).active = true
		purchaseReminder.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true

		settingsButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(settingsButton)

		settingsButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
		settingsButton.topAnchor.constraintEqualToAnchor(settingsInstructions.bottomAnchor, constant: screenHeight / 64).active = true

		settingsButton.backgroundColor = ColorHelper.hexStringToUIColor(MainColors.NeutralBlue.rawValue)
		settingsButton.layer.masksToBounds = true
		settingsButton.layer.cornerRadius = 4
		settingsButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)

		settingsButton.addTarget(self, action: #selector(settingsButtonClicked), forControlEvents: .TouchUpInside)
		settingsButton.setBackgroundColor(ColorHelper.hexStringToUIColor("005B93"), forUIControlState: .Highlighted)

		Helper.setupBasicView(fullAccessNote, parentView: view)
		fullAccessNote.topAnchor.constraintEqualToAnchor(settingsButton.bottomAnchor).active = true
		fullAccessNote.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: screenWidth * 0.1).active = true
		fullAccessNote.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -screenWidth * 0.1).active = true
		fullAccessNote.text = "If full access is already enabled then you can ignore this."
		fullAccessNote.numberOfLines = 0
		fullAccessNote.adjustsFontSizeToFitWidth = true
		fullAccessNote.textAlignment = .Center
		fullAccessNote.hidden = true

		/*
		 // Some test code
		 let testButtonPurchase = UIButton()
		 testButtonPurchase.translatesAutoresizingMaskIntoConstraints = false
		 view.addSubview(testButtonPurchase)
		 testButtonPurchase.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
		 testButtonPurchase.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
		 testButtonPurchase.setTitle("Simulate Purchase", forState: .Normal)
		 testButtonPurchase.addTarget(self, action: #selector(testPurchaseClicked), forControlEvents: .TouchUpInside)
		 testButtonPurchase.backgroundColor = UIColor.blackColor()

		 let testButtonDestroy = UIButton()
		 testButtonDestroy.translatesAutoresizingMaskIntoConstraints = false
		 view.addSubview(testButtonDestroy)
		 testButtonDestroy.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
		 testButtonDestroy.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
		 testButtonDestroy.setTitle("Simulate Destroy Purchase", forState: .Normal)
		 testButtonDestroy.addTarget(self, action: #selector(testDestroyClicked), forControlEvents: .TouchUpInside)
		 testButtonDestroy.backgroundColor = UIColor.blackColor()

		 //		testButtonDestroy.hidden = true
		 //		testButtonPurchase.hidden = true
		 */
	}

	func isKeyboardExtensionEnabled() -> Bool
	{
		guard let appBundleIdentifier = NSBundle.mainBundle().bundleIdentifier else
		{
			fatalError("isKeyboardExtensionEnabled(): Cannot retrieve bundle identifier.")
		}

		guard let keyboards = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()["AppleKeyboards"] as? [String] else
		{
			fatalError("isKeyboardExtensionEnabled(): Cannot get access to keyboard list.")
		}

		let keyboardExtensionBundleIdentifierPrefix = appBundleIdentifier + "."
		for keyboard in keyboards
		{
			if keyboard.hasPrefix(keyboardExtensionBundleIdentifierPrefix)
			{
				return true
			}
		}

		return false
	}

	func applicationDidBecomeActive()
	{
		screenHeaderSetup()
	}

	func screenHeaderSetup()
	{

		if (isKeyboardExtensionEnabled())
		{
			enabled = true

			if (CopypastaProducts.store.isProductPurchased(CopypastaProducts.FullVersion))
			{
				purchased = true

				// Hide the purchase reminder (since they already purchased) set the settings text to enable full access
				fullAccessNote.hidden = false
				purchaseReminder.hidden = true
				settingsInstructions.hidden = false
				settingsInstructions.text = InstructionsText.FullAccess.rawValue
				settingsButton.setTitle("Enable Full Access", forState: .Normal)
				screenColorHeader.text = "Keyboard Enabled\n (Full Version)"

			} else
			{
				purchased = false
				purchaseReminder.hidden = false
				settingsInstructions.hidden = true
				settingsButton.setTitle("Upgrade", forState: .Normal)
				screenColorHeader.text = "Keyboard Enabled\n (Free Version) "
			}
		} else
		{
			enabled = false
			settingsButton.setTitle("Go to Settings", forState: .Normal)
			settingsInstructions.hidden = false
			settingsInstructions.text = InstructionsText.Enable.rawValue
			purchaseReminder.hidden = true
			screenColorHeader.text = "Enable Keyboard"

		}

	}

	func settingsButtonClicked()
	{
		if (enabled == true && purchased == false)
		{
			if let tabsController = UIApplication.sharedApplication().delegate?.window??.rootViewController as? TabsController
			{
				tabsController.selectedIndex = 2
			}
		} else
		{
			if let settingsURL = NSURL(string: "prefs:root=General&path=Keyboard")
			{
				UIApplication.sharedApplication().openURL(settingsURL)
			}
		}

	}

	/*

	 func testPurchaseClicked(sender: UIButton!)
	 {
	 print("Set keychain value to true")
	 let IAPFetch = Keychain(service: "com.roymunsonstudios.CopypastaKeyboard")
	 var purchase: Bool = true
	 let purchaseData = NSData(bytes: &purchase, length: sizeof(Bool))
	 try! IAPFetch.set(purchaseData, key: CopypastaProducts.FullVersion)
	 print("The key is: " + CopypastaProducts.FullVersion)
	 }

	 func testDestroyClicked(sender: UIButton!)
	 {
	 print("Set keychain value to false")
	 let IAPFetch = Keychain(service: "com.roymunsonstudios.CopypastaKeyboard")
	 var purchase: Bool = false
	 let purchaseData = NSData(bytes: &purchase, length: sizeof(Bool))
	 try! IAPFetch.set(purchaseData, key: CopypastaProducts.FullVersion)
	 print("The key is: " + CopypastaProducts.FullVersion)
	 }
	 */

}
