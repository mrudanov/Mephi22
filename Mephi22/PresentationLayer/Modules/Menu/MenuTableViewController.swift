//
//  MenuViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    private enum Destination {
        case addFaces, deleteFaces, classes
    }

    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                navigateToNextViewController(.addFaces)
            case 1:
                navigateToNextViewController(.deleteFaces)
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                navigateToNextViewController(.classes)
            default:
                return
            }
        default:
            return
        }
    }
    
    // MARK: - Navigation
    private func navigateToNextViewController(_ destination: Destination) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        let rootAssembly = appDelegate!.rootAssembly
        switch destination {
        case .addFaces:
            show(rootAssembly.addFaceAssembly.selectStudentViewController(), sender: nil)
        case .deleteFaces:
            show(rootAssembly.deleteFacesAssembly.deleteFacesViewController(), sender: nil)
        case .classes:
            show(rootAssembly.classesAssembly.classesSelectGroupViewController(), sender: nil)
        }
    }
}
