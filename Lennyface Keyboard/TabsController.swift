//
//  TabsController.swift
//
//  Created by vroy on 7/27/16.
//  Copyright © 2016 vroy. All rights reserved.
//

import UIKit

class TabsController: UITabBarController
{
	internal static var tabBarHeight: CGFloat = 0

	override func viewDidLoad()
	{
		TabsController.tabBarHeight = self.tabBar.frame.height
	}

}