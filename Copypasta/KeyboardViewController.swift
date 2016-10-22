//
//  KeyboardViewController.swift
//  Copypasta
//
//  Created by vroy on 6/5/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController
{
	@IBOutlet var nextKeyboardButton: UIButton!

//	private var deleteCounter: Int = 0

	private let minDelInterval = 1 / CFTimeInterval(6)
	private var lastTapTime = CFAbsoluteTime(0)

	let mainQueue = dispatch_get_main_queue()
	let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

	private var tabBar = UIStackView()
	var purchaseReminder: UILabel? = nil
	private var tabScroller = UIScrollView()
	private var tabBarWidthConstraint = NSLayoutConstraint?()
	private let tabBarTotalWidth: CGFloat = 846

	private let keyboardFontSize: CGFloat = 13
	private let mainButtonPressedColor: UIColor = UIColor.init(red: 171 / 255, green: 171 / 255, blue: 171 / 255, alpha: 1)

	private var allRowButtons = [UIButton]()
	private var tabButtons = [UIButton]()
	var deleteAllButton = UIButton()

	private var keyboardState: Int = 0
	private var screenWidth: CGFloat = 0.0

	private let tabTitles: [String] = ["I'll have you \n know I am a:", "I identify \n as a:", "That's some:", "_ are \n not _", /*"Roasts", */		"More Copypastas", "Faces!"]

	private let mainButtonTitles: [[String]] = [
		["Navy Seal", "Navy Seal (Emoji)", "Atheist",
			"Pirate", "Royal Knight", "Hipster",
			"British", "SJW", "Friendly Neighbor"],

		["Attack Helicopter", "Meme", "Graph Paper",
			"Ghost Pirate", "Navy Seal", "Pringle",
			"Missile", "Walrus", "Neckbeard"],

		["goodshit", "edgy shit", "conspiracy shit",
			"wierd shit", "bullshit", "spooky shit",
			"good shitposting", "funny shit", "sexy shit"],

		["Mountain Lions/Lions", "Trilbies/Fedoras", "Espresso/Coffee",
			"Jackdow/Crow", "PC Game/Sport", "Queef/Fart",
			"Atheist/Scientist", "Jedi/Sith", "Seals/Special Forces"],

		/*
		 ["ABSOLUTELY POINTLESS!", "AT LEAST I DON'T...", "I am a fucking god",
		 "You've won nothing", "roast of the ages", "3rd Warning",
		 "Downvoted", "Your post gave me cancer", "Don't say K"],
		 */

		["My nana is still a looker", "I wasted your time", "iPhone is the best console",
			"Rekt", "Degree 6 zoo sexual", "I r8 8/8",
			"ULTRA MIX", "Copypasta Thief", "SHITMIX"],

		["( ͡° ͜ʖ ͡°)", "¯\\_(ツ)_/¯", "ಠ_ಠ",
			"( ✖ _ ✖ )", "ᕙ(˵ ಠ ਊ ಠ ˵)ᕗ", "(ノಠ益ಠ)ノ彡┻━┻",
			"╰(͡° ͜ʖ ͡°)━☆ﾟ.*･｡ﾟ", "(•_•) ( •_•)>⌐■-■ (⌐■_■)", "༼ つ ◕_◕ ༽つ"]]

	private let copypastas: [[String]] = [
		[NSLocalizedString("NSEAL1", comment: ""), NSLocalizedString("NSEAL2", comment: ""), NSLocalizedString("NSEAL3", comment: ""),
			NSLocalizedString("NSEAL4", comment: ""), NSLocalizedString("NSEAL5", comment: ""), NSLocalizedString("NSEAL6", comment: ""),
			NSLocalizedString("NSEAL7", comment: ""), NSLocalizedString("NSEAL8", comment: ""), NSLocalizedString("NSEAL9", comment: "")],

		[NSLocalizedString("IDENT1", comment: ""), NSLocalizedString("IDENT2", comment: ""), NSLocalizedString("IDENT3", comment: ""),
			NSLocalizedString("IDENT4", comment: ""), NSLocalizedString("IDENT5", comment: ""), NSLocalizedString("IDENT6", comment: ""),
			NSLocalizedString("IDENT7", comment: ""), NSLocalizedString("IDENT8", comment: ""), NSLocalizedString("IDENT9", comment: "")],

		[NSLocalizedString("GOODSHIT1", comment: ""), NSLocalizedString("GOODSHIT2", comment: ""), NSLocalizedString("GOODSHIT3", comment: ""),
			NSLocalizedString("GOODSHIT4", comment: ""), NSLocalizedString("GOODSHIT5", comment: ""), NSLocalizedString("GOODSHIT6", comment: ""),
			NSLocalizedString("GOODSHIT7", comment: ""), NSLocalizedString("GOODSHIT8", comment: ""), NSLocalizedString("GOODSHIT9", comment: "")],

		[NSLocalizedString("THING1", comment: ""), NSLocalizedString("THING2", comment: ""), NSLocalizedString("THING3", comment: ""),
			NSLocalizedString("THING4", comment: ""), NSLocalizedString("THING5", comment: ""), NSLocalizedString("THING6", comment: ""),
			NSLocalizedString("THING7", comment: ""), NSLocalizedString("THING8", comment: ""), NSLocalizedString("THING9", comment: "")],

		/*

		 [NSLocalizedString("ROAST1", comment: ""), NSLocalizedString("ROAST2", comment: ""), NSLocalizedString("ROAST3", comment: ""),
		 NSLocalizedString("ROAST4", comment: ""), NSLocalizedString("ROAST5", comment: ""), NSLocalizedString("ROAST6", comment: ""),
		 NSLocalizedString("ROAST7", comment: ""), NSLocalizedString("ROAST8", comment: ""), NSLocalizedString("ROAST9", comment: "")],
		 */

		[NSLocalizedString("OTHER1", comment: ""), NSLocalizedString("OTHER2", comment: ""), NSLocalizedString("OTHER3", comment: ""),
			NSLocalizedString("OTHER4", comment: ""), NSLocalizedString("OTHER5", comment: ""), NSLocalizedString("OTHER6", comment: ""),
			NSLocalizedString("OTHER7", comment: ""), NSLocalizedString("OTHER8", comment: ""), NSLocalizedString("OTHER9", comment: "")],

		["( ͡° ͜ʖ ͡°)", "¯\\_(ツ)_/¯", "ಠ_ಠ",
			"( ✖ _ ✖ )", "ᕙ(˵ ಠ ਊ ಠ ˵)ᕗ", "(ノಠ益ಠ)ノ彡┻━┻",
			"╰(͡° ͜ʖ ͡°)━☆ﾟ.*･｡ﾟ", "(•_•) ( •_•)>⌐■-■ (⌐■_■)", "༼ つ ◕_◕ ༽つ"]]

	override func viewDidLoad()
	{

		super.viewDidLoad()

		let IAPFetch = Keychain(service: "com.roymunsonstudios.CopypastaKeyboard")

		var purchased = false
		do
		{
			let purchaseStatusData = try IAPFetch.getData(CopypastaProducts.FullVersion)

			if let purchaseStatusData = purchaseStatusData
			{

				// Convert the NSData into a Bool
				var byterep: Int = 0
				purchaseStatusData.getBytes(&byterep, length: sizeof(Int))

				if byterep != 0
				{
					// Set purchase value to "true" if (theoretically) the product has been purchased. Else it will remain false.
					purchased = true
				}

			} else
			{
				print("The Data was NIL")

				// If the data is NIL then add update the entry to the keychain so that it says the upgrade value is false
				var purchase: Bool = false
				let purchaseData = NSData(bytes: &purchase, length: sizeof(Bool))
				try! IAPFetch.set(purchaseData, key: CopypastaProducts.FullVersion)
			}

		} catch is ErrorType
		{
			print("Error fetching data")
		}

		screenWidth = UIScreen.mainScreen().bounds.width

		// TODO: Make tab buttons scale to keyboard

		// tB1 stands for "Tab Button 1", tB2 stands for "Tab Button 2" etc..
		tabButtons = [UIButton]()

		let tB1 = UIButton()
		tabButtons.append(tB1)
		let tB2 = UIButton()
		tabButtons.append(tB2)
		let tB3 = UIButton()
		tabButtons.append(tB3)
		let tB4 = UIButton()
		tabButtons.append(tB4)
		let tB5 = UIButton()
		tabButtons.append(tB5)
		let tB6 = UIButton()
		tabButtons.append(tB6)
		/*
		 let tB7 = UIButton()
		 tabButtons.append(tB7)
		 */

		// Setup button text and properties
		for tabButton in tabButtons
		{
			tabButton.backgroundColor = UIColor.whiteColor()
			tabButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
			tabButton.layer.cornerRadius = 4.0
			tabButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
			tabButton.layer.shadowOffset = CGSizeMake(0.0, 2.0)
			tabButton.layer.shadowOpacity = 1.0
			tabButton.layer.shadowRadius = 0.0
			tabButton.layer.masksToBounds = false

			let tabButtonIndex = tabButtons.indexOf(tabButton)!

			tabButton.setTitle(tabTitles[tabButtonIndex], forState: .Normal)

			// Text formatting
			// tabButton.titleLabel?.adjustsFontSizeToFitWidth = true
			// tabButton.titleLabel?.lineBreakMode = .ByClipping
			tabButton.titleLabel?.numberOfLines = 2
			tabButton.titleLabel?.textAlignment = .Center
			tabButton.titleLabel?.font = UIFont.systemFontOfSize(keyboardFontSize)
			tabButton.tag = tabButtonIndex
			tabButton.addTarget(self, action: #selector(tabButtonPressed), forControlEvents: .TouchUpInside)
		}

		tabScroller = UIScrollView()
		view.addSubview(tabScroller)
		tabScroller.translatesAutoresizingMaskIntoConstraints = false

		tabScroller.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
		tabScroller.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
		tabScroller.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.25).active = true

		tabScroller.bounces = false
		tabScroller.showsHorizontalScrollIndicator = false
		tabScroller.directionalLockEnabled = true

		tabBar = UIStackView(arrangedSubviews: tabButtons)
		tabScroller.addSubview(tabBar)
		tabBar.translatesAutoresizingMaskIntoConstraints = false
		tabBar.spacing = 1
		tabBar.axis = .Horizontal
		tabBar.alignment = .Fill
		tabBar.distribution = .FillEqually

		if (screenWidth >= tabBarTotalWidth)
		{
			tabBarWidthConstraint = tabBar.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor)
		} else
		{
			tabBarWidthConstraint = tabBar.widthAnchor.constraintEqualToConstant(tabBarTotalWidth)
		}

		tabBarWidthConstraint?.active = true

		tabBar.leadingAnchor.constraintEqualToAnchor(tabScroller.leadingAnchor).active = true
		tabBar.trailingAnchor.constraintEqualToAnchor(tabScroller.trailingAnchor).active = true
		tabBar.bottomAnchor.constraintEqualToAnchor(tabScroller.bottomAnchor).active = true
		tabBar.topAnchor.constraintEqualToAnchor(tabScroller.topAnchor).active = true
		tabBar.heightAnchor.constraintEqualToAnchor(tabScroller.heightAnchor).active = true

		// Setup the arrays containing the 3 rows of buttons

		var rowOneButtons = [UIButton]()
		let r11 = UIButton()
		rowOneButtons.append(r11)
		let r12 = UIButton()
		rowOneButtons.append(r12)
		let r13 = UIButton()
		rowOneButtons.append(r13)

		var rowTwoButtons = [UIButton]()
		let r21 = UIButton()
		rowTwoButtons.append(r21)
		let r22 = UIButton()
		rowTwoButtons.append(r22)
		let r23 = UIButton()
		rowTwoButtons.append(r23)

		var rowThreeButtons = [UIButton]()
		let r31 = UIButton()
		rowThreeButtons.append(r31)
		let r32 = UIButton()
		rowThreeButtons.append(r32)
		let r33 = UIButton()
		rowThreeButtons.append(r33)

		// Creates array to hold all rowbuttons
		allRowButtons = rowOneButtons + rowTwoButtons + rowThreeButtons

		// Setup button properties
		for rowButton in allRowButtons
		{
			rowButton.backgroundColor = UIColor.whiteColor()
			rowButton.layer.cornerRadius = 4.0
			rowButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
			rowButton.layer.shadowOffset = CGSizeMake(0.0, 2.0)
			rowButton.layer.shadowOpacity = 1.0
			rowButton.layer.shadowRadius = 0.0
			rowButton.layer.masksToBounds = false
			rowButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
			rowButton.tag = allRowButtons.indexOf(rowButton)!
			rowButton.addTarget(self, action: #selector(rowButtonPressed), forControlEvents: .TouchUpInside)
			rowButton.titleLabel?.font = UIFont.systemFontOfSize(keyboardFontSize)
			rowButton.titleLabel?.numberOfLines = 2
			rowButton.setTitleColor(mainButtonPressedColor, forState: .Highlighted)
			rowButton.titleLabel?.textAlignment = .Center
		}

		// If full product not purchased: Grey out all buttons except the first one and make them unclickable.
		if purchased != true
		{
			for buttonIndex in 1...8
			{
				allRowButtons[buttonIndex].backgroundColor = UIColor.redColor()
				allRowButtons[buttonIndex].removeTarget(self, action: #selector(rowButtonPressed), forControlEvents: .TouchUpInside)
				allRowButtons[buttonIndex].addTarget(self, action: #selector(disabledRowButtonPressed), forControlEvents: .TouchUpInside)
			}
		}

		let rowOne = UIStackView(arrangedSubviews: rowOneButtons)
		let rowTwo = UIStackView(arrangedSubviews: rowTwoButtons)
		let rowThree = UIStackView(arrangedSubviews: rowThreeButtons)

		var rowsArray = [UIStackView]()
		rowsArray.append(rowOne)
		rowsArray.append(rowTwo)
		rowsArray.append(rowThree)

		for row in rowsArray
		{
			row.axis = .Horizontal
			row.spacing = 2
			row.distribution = .FillEqually
			row.alignment = .Fill
		}

		let rows = UIStackView(arrangedSubviews: rowsArray)
		self.view.addSubview(rows)

		rows.translatesAutoresizingMaskIntoConstraints = false
		rows.spacing = 1
		rows.axis = .Vertical
		rows.alignment = .Fill
		rows.distribution = .FillEqually

		rows.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
		rows.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
		rows.topAnchor.constraintEqualToAnchor(tabBar.bottomAnchor, constant: 3).active = true

		if purchased == true
		{
			rows.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.5).active = true
			tabScroller.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
		} else
		{
			rows.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.4).active = true

			// Set up reminder to purchase label
			purchaseReminder = UILabel()
			view.addSubview(purchaseReminder!)
			purchaseReminder!.translatesAutoresizingMaskIntoConstraints = false

			purchaseReminder!.text = "To access all the buttons in the keyboard buy the full version."
			purchaseReminder!.adjustsFontSizeToFitWidth = true
			purchaseReminder!.textAlignment = .Center

			purchaseReminder!.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
			purchaseReminder!.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
			purchaseReminder!.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
			purchaseReminder!.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.1).active = true

			tabScroller.topAnchor.constraintEqualToAnchor(purchaseReminder!.bottomAnchor).active = true

		}

		var utilityButtons = [UIButton]()
		self.nextKeyboardButton = UIButton(type: .System)
		utilityButtons.append(nextKeyboardButton)
		deleteAllButton = UIButton() // UIButton(type: .Custom)
		utilityButtons.append(deleteAllButton)
		let returnButton = UIButton()
		utilityButtons.append(returnButton)

		for utilityButton in utilityButtons
		{
			utilityButton.backgroundColor = UIColor.init(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1)
			utilityButton.layer.cornerRadius = 4.0
			utilityButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
			utilityButton.layer.shadowOffset = CGSizeMake(0.0, 2.0)
			utilityButton.layer.shadowOpacity = 1.0
			utilityButton.layer.shadowRadius = 0.0
			utilityButton.layer.masksToBounds = false

			utilityButton.setTitleColor(UIColor.init(red: 127 / 255, green: 127 / 255, blue: 127 / 255, alpha: 1), forState: .Highlighted)

			utilityButton.titleLabel?.textAlignment = .Center
		}

		nextKeyboardButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
		nextKeyboardButton.setTitle("Next Keyboard", forState: .Normal)
		nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), forControlEvents: .TouchUpInside)
		nextKeyboardButton.titleLabel?.font = UIFont.systemFontOfSize(keyboardFontSize)

		// let deleteIcon = UIImage(named: "deleteall")! as UIImage
		// deleteAllButton.setImage(deleteIcon, forState: .Normal)
		deleteAllButton.setTitle("Delete", forState: .Normal)
		deleteAllButton.titleLabel?.numberOfLines = 2
		deleteAllButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
		deleteAllButton.titleLabel?.font = UIFont.systemFontOfSize(keyboardFontSize)
		// deleteAllButton.addTarget(self, action: #selector(deletekeyPressed), forControlEvents: .TouchUpInside)

		let deleteLPGR = UILongPressGestureRecognizer(target: self, action: #selector(deleteButtonLongPress))
		deleteLPGR.minimumPressDuration = 0
		deleteLPGR.delaysTouchesBegan = true
		deleteLPGR.cancelsTouchesInView = false
		deleteAllButton.addGestureRecognizer(deleteLPGR)

		returnButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
		returnButton.setTitle("Return", forState: .Normal)
		returnButton.addTarget(self, action: #selector(returnkeyPressed), forControlEvents: .TouchUpInside)
		returnButton.titleLabel?.font = UIFont.systemFontOfSize(keyboardFontSize)

		let utilityRow = UIStackView(arrangedSubviews: utilityButtons)
		self.view.addSubview(utilityRow)
		utilityRow.translatesAutoresizingMaskIntoConstraints = false
		utilityRow.spacing = 2
		utilityRow.axis = .Horizontal
		utilityRow.alignment = .Fill
		utilityRow.distribution = .FillEqually

		utilityRow.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -1).active = true
		utilityRow.topAnchor.constraintEqualToAnchor(rows.bottomAnchor, constant: 3).active = true
		utilityRow.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: -2).active = true
		utilityRow.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: 1).active = true

		for numOfCurrentButton in 0..<9
		{

			let currentButton = allRowButtons[numOfCurrentButton]
			currentButton.setTitle(mainButtonTitles[keyboardState][numOfCurrentButton], forState: .Normal)

		}

	}

	var timer: NSTimer? = nil
	var firstInDeleteCycle = true

	func deleteButtonLongPress(gesture: UILongPressGestureRecognizer)
	{
		/*
		 if (firstInDeleteCycle)
		 {
		 delete()
		 firstInDeleteCycle = false
		 }
		 */

		if gesture.state == .Began
		{
			deleteAllButton.setTitleColor(mainButtonPressedColor, forState: .Normal)
			timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(KeyboardViewController.deleteTimerSafe), userInfo: nil, repeats: true)
		} else if gesture.state == .Ended || gesture.state == .Cancelled
		{
			deleteAllButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
			timer?.invalidate()
			timer = nil
			firstInDeleteCycle = true
		}
	}

	override func viewWillTransitionToSize(size: CGSize,
		withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
	{
		screenWidth = UIScreen.mainScreen().bounds.width

		if (size.width >= tabBarTotalWidth)
		{
			tabBarWidthConstraint?.active = false
			tabBarWidthConstraint = tabBar.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor)
			tabBarWidthConstraint?.active = true
		} else
		{
			tabBarWidthConstraint?.active = false
			tabBarWidthConstraint = tabBar.widthAnchor.constraintEqualToConstant(tabBarTotalWidth)
			tabBarWidthConstraint?.active = true
		}
	}

	override func textWillChange(textInput: UITextInput?)
	{
		// The app is about to change the document's contents. Perform any preparation here.
		print("textWillChange Called")

	}

	override func textDidChange(textInput: UITextInput?)
	{
		print("textDidChange Called")
		/*
		 // whatever else you need to do
		 if CACurrentMediaTime() - lastDeleteAllPressed < threshHold && self.textDocumentProxy.isProxy()
		 {
		 delete()
		 }
		 */

		// The app has just changed the document's contents, the document context has been updated.
		var textColor: UIColor
		let proxy = self.textDocumentProxy
		if proxy.keyboardAppearance == UIKeyboardAppearance.Dark
		{
			textColor = UIColor.whiteColor()
		} else
		{
			textColor = UIColor.blackColor()
		}
		self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
	}

	func tabButtonPressed(sender: UIButton!)
	{

		let newKeyboardState = sender.tag
		keyboardState = newKeyboardState

		for numOfCurrentButton in 0..<9
		{

			let currentButton = allRowButtons[numOfCurrentButton]
			currentButton.setTitle(mainButtonTitles[newKeyboardState][numOfCurrentButton], forState: .Normal)

		}

		for tabButton in tabButtons
		{
			tabButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
			tabButton.titleLabel?.font = UIFont.systemFontOfSize(keyboardFontSize)
		}

		sender.setTitleColor(UIColor.blueColor(), forState: .Normal)
		sender.titleLabel?.font = UIFont.boldSystemFontOfSize(keyboardFontSize)

	}

	func rowButtonPressed(sender: UIButton!)
	{

		// Fetch the string that will be outputted
		let outputString = copypastas[keyboardState][sender.tag]
		(textDocumentProxy as UIKeyInput).insertText(outputString)
	}

	func disabledRowButtonPressed(sender: UIButton!)
	{
		purchaseReminder?.textColor = UIColor.redColor()
		// Do something to alert the user too the fact that they need to purchase the full version
		let triggerTime = (Int64(NSEC_PER_SEC) * 1)
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(),
			{ () -> Void in
				self.purchaseReminder?.textColor = UIColor.blackColor()
		})
	}

	func returnkeyPressed(sender: UIButton!)
	{
		(textDocumentProxy as UIKeyInput).insertText("\n")

	}

	func deletekeyPressed(sender: UIButton!)
	{

		/*
		 let currentTime = CFAbsoluteTimeGetCurrent()
		 guard currentTime > lastTapTime + minDelInterval else
		 {
		 print("Denying tap")
		 return
		 }
		 lastTapTime = currentTime

		 delete()
		 */
	}

	private var isDeleting = false

	/*
	 func delete()
	 {
	 guard !isDeleting else
	 { return }
	 isDeleting = true
	 for _ in 1..<50
	 {
	 dispatch_async(mainQueue)
	 {
	 (self.textDocumentProxy as UIKeyInput).deleteBackward()
	 }
	 }
	 dispatch_async(mainQueue)
	 {
	 print("Deletion End")
	 self.isDeleting = false
	 }
	 }
	 */

	func deleteTimerSafe(sender: NSTimer)
	{
		dispatch_async(mainQueue)
		{
			(self.textDocumentProxy as UIKeyInput).deleteBackward()
		}

	}

}
