//
//  MenuAssembly.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 10/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import Foundation
import UIKit

class MenuAssembly {
    func menuViewController() -> MenuTableViewController {
        return UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "Menu") as! MenuTableViewController
    }
    
    func menuNavigationController() -> UINavigationController {
        let navigationController = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation") as! UINavigationController
        return navigationController
    }
}
