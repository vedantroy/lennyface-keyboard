//
//  IAPHelper.swift
//  Copypasta Keyboard
//
//  Created by vroy on 6/29/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (success: Bool, products: [SKProduct]?) -> ()

public class IAPHelper: NSObject
{

	private let productIdentifiers: Set<ProductIdentifier>
	private var purchasedProductIdentifiers = Set<ProductIdentifier>()

	private var productsRequest: SKProductsRequest?
	private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?

	static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"

	// let IAPKeychain = KeychainWrapper(serviceName: "COPYPASTA_IAP")

	public init(productIds: Set<ProductIdentifier>)
	{
		self.productIdentifiers = productIds

		// Get keychain service
		let IAPKeychain = Keychain(service: "com.roymunsonstudios.CopypastaKeyboard")

		// Loop through product IDs to check if previously purchased
		for productIdentifier in productIds
		{

			var purchasedData: NSData?

			// Fetch NSData from the keychain
			do
			{
				purchasedData = try IAPKeychain.getData(productIdentifier)
			}
			catch is ErrorType
			{
				print("Catch-all: failure fetching data!")
			}

			print("Fetching data from key: " + productIdentifier)
			// Unwrap Optional NSData
			if let purchasedData = purchasedData
			{

				// Convert the NSData into a Bool
				var purchased = false
				var bytemess: Int = 0
				purchasedData.getBytes(&bytemess, length: sizeof(Int))
				if bytemess != 0
				{
					purchased = true
				}

				// Use the bool to determine if a product is purchased
				if purchased
				{
					// The full version has been purchased
					purchasedProductIdentifiers.insert(productIdentifier)
				} else
				{
					// The full version has not been purchased
				}

			} else
			{
				// The product has never been installed before on the device. Add a fullVersion key that is "false"
				var purchase: Bool = false
				let purchaseData = NSData(bytes: &purchase, length: sizeof(Bool))

				try! IAPKeychain.set(purchaseData, key: productIdentifier)

			}

		}

		super.init()

		SKPaymentQueue.defaultQueue().addTransactionObserver(self)
	}
}

// MARK: - StoreKit API

extension IAPHelper
{

	public func requestProducts(completionHandler: ProductsRequestCompletionHandler)
	{
		productsRequest?.cancel()
		productsRequestCompletionHandler = completionHandler

		productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
		productsRequest!.delegate = self
		productsRequest!.start()

	}

	public func buyProduct(product: SKProduct)
	{
		print("Buying \(product.productIdentifier)...")
		let payment = SKPayment(product: product)
		SKPaymentQueue.defaultQueue().addPayment(payment)
	}

	public func isProductPurchased(productIdentifier: ProductIdentifier) -> Bool
	{
		return purchasedProductIdentifiers.contains(productIdentifier)
	}

	public class func canMakePayments() -> Bool
	{
		return SKPaymentQueue.canMakePayments()
	}

	public func restorePurchases()
	{
		SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
	}
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate
{
	public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse)
	{
//		print("Loaded list of products...")
		let products = response.products
		productsRequestCompletionHandler?(success: true, products: products)
		clearRequestAndHandler()

		/*
		 for p in products {
		 print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
		 }
		 */

	}

	public func request(request: SKRequest, didFailWithError error: NSError)
	{
		print("Failed to load list of products.")
		print("Error: \(error.localizedDescription)")
		productsRequestCompletionHandler?(success: false, products: nil)
		clearRequestAndHandler()
	}

	private func clearRequestAndHandler()
	{
		productsRequest = nil
		productsRequestCompletionHandler = nil
	}
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver
{

	public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
	{
		for transaction in transactions
		{
			switch (transaction.transactionState)
			{
			case .Purchased:
				completeTransaction(transaction)
				break
			case .Failed:
				failedTransaction(transaction)
				break
			case .Restored:
				restoreTransaction(transaction)
				break
			case .Deferred:
				break
			case .Purchasing:
				break
			}
		}
	}

	private func completeTransaction(transaction: SKPaymentTransaction)
	{
		print("completeTransaction...")
		deliverPurchaseNotificationForIdentifier(transaction.payment.productIdentifier)
		SKPaymentQueue.defaultQueue().finishTransaction(transaction)
	}

	private func restoreTransaction(transaction: SKPaymentTransaction)
	{
		guard let productIdentifier = transaction.originalTransaction?.payment.productIdentifier else
		{ return }

		print("restoreTransaction... \(productIdentifier)")
		deliverPurchaseNotificationForIdentifier(productIdentifier)
		SKPaymentQueue.defaultQueue().finishTransaction(transaction)
	}

	private func failedTransaction(transaction: SKPaymentTransaction)
	{
		print("failedTransaction...")

		if transaction.error!.code != SKErrorCode.PaymentCancelled.rawValue
		{
			print("Transaction Error: \(transaction.error?.localizedDescription)")
		}

		SKPaymentQueue.defaultQueue().finishTransaction(transaction)
	}

	private func deliverPurchaseNotificationForIdentifier(identifier: String?)
	{
		guard let identifier = identifier else
		{ return }

		purchasedProductIdentifiers.insert(identifier)

		let IAPKeychain = Keychain(service: "com.roymunsonstudios.CopypastaKeyboard")

		var purchase: Bool = true
		let purchaseData = NSData(bytes: &purchase, length: sizeof(Bool))

		try! IAPKeychain.set(purchaseData, key: identifier)

		// The object would normally be "identifier" but since I only have one IAP I just use nil
		NSNotificationCenter.defaultCenter().postNotificationName(IAPHelper.IAPHelperPurchaseNotification, object: nil)
	}
}
