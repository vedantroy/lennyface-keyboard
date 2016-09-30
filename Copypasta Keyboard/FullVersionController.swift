//
//  FullVersionController.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/29/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit
import StoreKit

class FullVersionController: UIViewController
{

	let restorePurchaseButton = UIButton()
	let purchaseButton = UIButton()

	let purchaseMessage = UILabel()
	let restoreMessage = UILabel()

	let screenColorHeader = UILabel()

	var fullVersion = SKProduct()

	// 0 = unset, 1 = failure 2 = success

	var productsLoaded = 0
	{
		didSet
		{
			if (productsLoaded == 1)
			{
				purchaseButton.setTitle("N/A", forState: .Normal)
				purchaseMessage.text = "Failed to load products"

				restoreMessage.text = "Failed to load products"
				restorePurchaseButton.setTitle("N/A", forState: .Normal)
				return
			}

			if (productsLoaded == 2)
			{
				print("The products have been successfully loaded")

				if (CopypastaProducts.store.isProductPurchased(fullVersion.productIdentifier))
				{

				} else
				{
					print("Full version not purchased")
					// See if user can make payments
					if (IAPHelper.canMakePayments())
					{
						// User can make payments
						purchaseButton.setTitle("Buy", forState: .Normal)
						purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), forControlEvents: .TouchUpInside)
						purchaseMessage.text = "Access 50+ copypastas by upgrading for \(fullVersion.price)."

						restorePurchaseButton.setTitle("Restore", forState: .Normal)
						restorePurchaseButton.addTarget(self, action: #selector(restoreButtonTapped), forControlEvents: .TouchUpInside)
						restoreMessage.text = "If you have previously upgraded on a different device, then restore your purchase."

					} else
					{
						// User cannot make payments
						purchaseMessage.text = "You cannot make payments."
						purchaseButton.setTitle("N/A", forState: .Normal)

						restorePurchaseButton.setTitle("N/A", forState: .Normal)
						restoreMessage.text = "You cannot restore purchases."

					}
				}
			}
		}
	}

	override func viewDidLoad()
	{

		screenColorHeader.text = "Enable \"Full Access\" in Settings"

		if (CopypastaProducts.store.isProductPurchased(CopypastaProducts.FullVersion))
		{
			// If the product is purchased
			actOnSuccessfulPurchase()

		} else
		{
			// Do stuff is the product is not purchased

			Helper.setupHeader(screenColorHeader, normalcolorhex: MainColors.NeutralBlue.rawValue, title: "Upgrade", parentView: self.view)

			NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(actOnSuccessfulPurchase), name: IAPHelper.IAPHelperPurchaseNotification, object: nil)

			let screenHeight = UIScreen.mainScreen().bounds.height
			let screenWidth = UIScreen.mainScreen().bounds.width

			let pressedButtonColor = "005B93"

			Helper.setupButton(purchaseButton, normalcolorhex: MainColors.NeutralBlue.rawValue, pressedcolorhex: pressedButtonColor, title: "Loading...", parentView: self.view)

			Helper.setupButton(restorePurchaseButton, normalcolorhex: MainColors.NeutralBlue.rawValue, pressedcolorhex: pressedButtonColor, title: "Loading...", parentView: self.view)

			// Setup the informative messages

			Helper.setupBasicView(purchaseMessage, parentView: self.view)

			purchaseMessage.text = "Loading..."
			purchaseMessage.font = Helper.systemButtonFont
			purchaseMessage.textAlignment = .Left
			purchaseMessage.numberOfLines = 0

			purchaseMessage.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: screenWidth * 0.1).active = true
			purchaseMessage.topAnchor.constraintEqualToAnchor(screenColorHeader.bottomAnchor, constant: screenHeight / 16).active = true
			purchaseMessage.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.4).active = true
			purchaseMessage.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.3).active = true

			purchaseButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -(screenWidth * 0.1)).active = true
			purchaseButton.leftAnchor.constraintEqualToAnchor(purchaseMessage.rightAnchor, constant: screenWidth * 0.1).active = true
			purchaseButton.centerYAnchor.constraintEqualToAnchor(purchaseMessage.centerYAnchor).active = true
			purchaseButton.titleLabel?.numberOfLines = 2
			purchaseButton.titleLabel?.textAlignment = .Center
			purchaseButton.titleLabel?.font = UIFont.systemFontOfSize(UIFont.buttonFontSize())
			purchaseButton.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)

			Helper.setupBasicView(restoreMessage, parentView: self.view)

			restoreMessage.text = "Loading..."
			restoreMessage.font = Helper.systemButtonFont
			restoreMessage.textAlignment = .Left
			restoreMessage.numberOfLines = 0

			restoreMessage.leftAnchor.constraintEqualToAnchor(purchaseMessage.leftAnchor).active = true
			restoreMessage.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.4).active = true
			restoreMessage.topAnchor.constraintEqualToAnchor(purchaseMessage.bottomAnchor).active = true
			restoreMessage.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.3).active = true

			restorePurchaseButton.rightAnchor.constraintEqualToAnchor(purchaseButton.rightAnchor).active = true
			restorePurchaseButton.leftAnchor.constraintEqualToAnchor(purchaseButton.leftAnchor).active = true
			restorePurchaseButton.centerYAnchor.constraintEqualToAnchor(restoreMessage.centerYAnchor).active = true
			restorePurchaseButton.titleLabel?.numberOfLines = 0
			restorePurchaseButton.titleLabel?.textAlignment = .Center
			restorePurchaseButton.titleLabel?.font = UIFont.systemFontOfSize(UIFont.buttonFontSize())
			restorePurchaseButton.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)

			CopypastaProducts.store.requestProducts
			{ (success, products) in
				if (success)
				{

					print("Successfully loaded products" + String(products?.count))
					// Set product loading to success

					self.fullVersion = products![0]
					self.productsLoaded = 2
				} else
				{
					// Set product loading to falure
					self.productsLoaded = 1
				}
			}
		}

	}

	func purchaseButtonTapped(sender: UIButton!)
	{
		CopypastaProducts.store.buyProduct(fullVersion)

	}

	func restoreButtonTapped(sender: UIButton!)
	{
		CopypastaProducts.store.restorePurchases()
	}

	func actOnSuccessfulPurchase()
	{
		let screenWidth = UIScreen.mainScreen().bounds.width

		Helper.setupHeader(screenColorHeader, normalcolorhex: MainColors.NeutralBlue.rawValue, title: "Keyboard Upgraded", parentView: self.view)
		screenColorHeader.numberOfLines = 2

		// Hide old UI elements
		restorePurchaseButton.hidden = true
		purchaseButton.hidden = true
		purchaseMessage.hidden = true
		restoreMessage.hidden = true

//		let screenHeight = UIScreen.mainScreen().bounds.height

		let purchaseReminder = UILabel()
		// let settingsButton = UIButton()
		let screenHeight = UIScreen.mainScreen().bounds.height
		let tabHeaderDif = (screenHeight * 0.25) - TabsController.tabBarHeight

		Helper.setupBasicView(purchaseReminder, parentView: view)
		purchaseReminder.numberOfLines = 0
		purchaseReminder.text = "Thank you for purchasing.\n \n If you have not yet enabled the keyboard or full access, see instructions. \n\n Copypasta keyboard requires full access to verify purchase of the full version. We only have access to Copypasta keyboard's keystrokes and do not record them."
		purchaseReminder.textAlignment = .Center
		purchaseReminder.font = Helper.systemButtonFont
		purchaseReminder.adjustsFontSizeToFitWidth = true

		purchaseReminder.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: screenWidth * 0.1).active = true
		purchaseReminder.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -screenWidth * 0.1).active = true
		purchaseReminder.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: tabHeaderDif / 2).active = true
		/*
		 let dummyView = UIView()
		 dummyView.translatesAutoresizingMaskIntoConstraints = false
		 view.addSubview(dummyView)

		 dummyView.topAnchor.constraintEqualToAnchor(screenColorHeader.bottomAnchor).active = true
		 dummyView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.5).active = true
		 dummyView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
		 dummyView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true

		 settingsButton.translatesAutoresizingMaskIntoConstraints = false
		 view.addSubview(settingsButton)

		 settingsButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
		 settingsButton.topAnchor.constraintEqualToAnchor(dummyView.bottomAnchor, constant: screenHeight / 64).active = true

		 settingsButton.backgroundColor = ColorHelper.hexStringToUIColor(MainColors.NeutralBlue.rawValue)
		 settingsButton.layer.masksToBounds = true
		 settingsButton.layer.cornerRadius = 4
		 settingsButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
		 settingsButton.setTitle("Go to Setup Tab", forState: .Normal)

		 settingsButton.addTarget(self, action: #selector(settingsButtonClicked), forControlEvents: .TouchUpInside)
		 settingsButton.setBackgroundColor(ColorHelper.hexStringToUIColor("005B93"), forUIControlState: .Highlighted)
		 */

	}

	/*
	 func settingsButtonClicked()
	 {

	 if let tabsController = UIApplication.sharedApplication().delegate?.window??.rootViewController as? TabsController
	 {
	 tabsController.selectedIndex = 0
	 }
	 }
	 */

}