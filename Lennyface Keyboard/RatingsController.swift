//
//  RatingsController.swift
//
//  Created by vroy on 6/23/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit
import Social

class RatingsController: UIViewController
{

	private let headerFontSize: CGFloat = UIFont.buttonFontSize() + 12

	private let testbutton = UIButton()

	override func viewDidLoad()
	{
		let screenHeight = UIScreen.mainScreen().bounds.height

		let screenColorHeader = UILabel()
		Helper.setupHeader(screenColorHeader, normalcolorhex: MainColors.NeutralBlue.rawValue, title: "Give feedback", parentView: self.view)

		let shareOnFacebookButton = UIButton()

		Helper.setupButton(shareOnFacebookButton, normalcolorhex: "3b5998", pressedcolorhex: "293D6A", title: "Share on Facebook", parentView: self.view)

		shareOnFacebookButton.addTarget(self, action: #selector(FacebookButtonClicked), forControlEvents: .TouchUpInside)

		let shareOnTwitterButton = UIButton()

		Helper.setupButton(shareOnTwitterButton, normalcolorhex: "00aced", pressedcolorhex: "0079A5", title: "Share on Twitter", parentView: self.view)

		shareOnTwitterButton.addTarget(self, action: #selector(TwitterButtonClicked), forControlEvents: .TouchUpInside)

		let reviewOnAppstoreButton = UIButton()

		Helper.setupButton(reviewOnAppstoreButton, normalcolorhex: "36B3F5", pressedcolorhex: "206A93", title: "Rate on the Appstore", parentView: self.view)

		reviewOnAppstoreButton.addTarget(self, action: #selector(AppstoreButtonClicked), forControlEvents: .TouchUpInside)

		let seeWebsite = UIButton()

		Helper.setupButton(seeWebsite, normalcolorhex: "#333333", pressedcolorhex: "#000000", title: "The Website", parentView: self.view)

		seeWebsite.addTarget(self, action: #selector(WebsiteButtonClicked), forControlEvents: .TouchUpInside)

		let ratingButtons = UIStackView(arrangedSubviews: [shareOnFacebookButton, shareOnTwitterButton, reviewOnAppstoreButton, seeWebsite])
		self.view.addSubview(ratingButtons)

		ratingButtons.translatesAutoresizingMaskIntoConstraints = false
		ratingButtons.axis = .Vertical
		ratingButtons.alignment = .Fill
		ratingButtons.distribution = .EqualSpacing

		ratingButtons.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 1 / 2).active = true
		ratingButtons.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.5).active = true
		ratingButtons.topAnchor.constraintEqualToAnchor(screenColorHeader.bottomAnchor, constant: screenHeight / 8).active = true
		ratingButtons.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true

	}

	func FacebookButtonClicked()
	{
		if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
		{
			let fbShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)

			self.presentViewController(fbShare, animated: true, completion: nil)

		} else
		{
			let alert = UIAlertController(title: "Accounts", message: "Login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)

			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}

	func TwitterButtonClicked()
	{

		if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
		{

			let tweetShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)

			self.presentViewController(tweetShare, animated: true, completion: nil)

		} else
		{

			let alert = UIAlertController(title: "Accounts", message: "Login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)

			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))

			self.presentViewController(alert, animated: true, completion: nil)
		}
	}

	func WebsiteButtonClicked()
	{

		UIApplication.sharedApplication().openURL(NSURL(string: "https://roymunsonstudios.github.io/")!)
	}

	func AppstoreButtonClicked()
	{
		UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/lennyface-keyboard/id1168423165?ls=1&mt=8")!)
	}

}
