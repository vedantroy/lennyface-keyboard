//
//  CopypastaProducts.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/29/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import Foundation

public struct CopypastaProducts
{

	// TODO:  Change this to the BundleID chosen when registering this app's App ID in the Apple Member Center.
	private static let Prefix = "com.roymunsonstudios.CopypastaKeyboard."

	public static let FullVersion = Prefix + "FullVersionKeyboard"

	private static let productIdentifiers: Set<ProductIdentifier> = [CopypastaProducts.FullVersion]

	// TODO: This is the code that would be used if you added iPhoneRage, NightlyRage, and UpdogRage to the list of purchasable
	// products in iTunesConnect.
	/*
	 public static let GirlfriendOfDrummerRage = Prefix + "GirlfriendOfDrummerRage"
	 public static let iPhoneRage              = Prefix + "iPhoneRage"
	 public static let NightlyRage             = Prefix + "NightlyRage"
	 public static let UpdogRage               = Prefix + "UpdogRage"

	 private static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.GirlfriendOfDrummerRage,
	 RageProducts.iPhoneRage,
	 RageProducts.NightlyRage,
	 RageProducts.UpdogRage]
	 */
	public static let store = IAPHelper(productIds: CopypastaProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String?
{
	return productIdentifier.componentsSeparatedByString(".").last
}
