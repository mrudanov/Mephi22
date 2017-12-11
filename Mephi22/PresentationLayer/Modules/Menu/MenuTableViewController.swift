//
//  MenuViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                navigateToAddFaces()
            case 1:
                navigateToDeleteFaces()
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                return
            case 1:
                return
            default:
                return
            }
        default:
            return
        }
    }
    
    // MARK: - Navigation
    private func navigateToAddFaces() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        let addFaceAssembly = appDelegate!.rootAssembly.addFaceAssembly
        let destinationVC = addFaceAssembly.selectStudentViewController()
        
        show(destinationVC, sender: nil)
    }
    
    private func navigateToDeleteFaces() {
    }
    
    private func navigateToSeminars() {
    }
    
    private func navigateToLectures() {
    }
}
