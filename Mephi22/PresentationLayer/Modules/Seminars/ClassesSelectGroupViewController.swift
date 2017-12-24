//
//  SelectGroupViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit
import PKHUD

class ClassesSelectGroupViewController: UIViewController {
    @IBOutlet weak var selectGroupPicker: UIPickerView!
    @IBOutlet weak var selectClassesPicker: UIPickerView!
    
    private var groupsDataSource: IGroupsDataSource?
    
    private var classesNumbers: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    // MARK: - Initialization
    public static func initVC(groupsDataSource: IGroupsDataSource) -> ClassesSelectGroupViewController {
        let selectGroupVC = UIStoryboard(name: "ClassesSelectGroup", bundle: nil).instantiateViewController(withIdentifier: "ClassesSelectGroup") as! ClassesSelectGroupViewController
        selectGroupVC.groupsDataSource = groupsDataSource

        return selectGroupVC
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(navigateToClassesCameraVieController))
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Classes"
        
        groupsDataSource?.delegate = self
        groupsDataSource?.getGroups()
        
        HUD.show(.progress)
        setupPickers()
    }
    
    // MARK: - Setup
    private func setupPickers() {
        selectGroupPicker.delegate = self
        selectGroupPicker.dataSource = self
        
        selectClassesPicker.delegate = self
        selectClassesPicker.dataSource = self
    }
    
    // MARK: - Alerts
    private func showAllert(with message: String, tryAgainAction: @escaping() -> Void) {
        let alert = UIAlertController(title: "Network error", message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default, handler: { (action) in
            tryAgainAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(tryAgainAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    @objc private func navigateToClassesCameraVieController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        let cameraAssembly = appDelegate!.rootAssembly.cameraAssembly
        let classNumber = classesNumbers[selectClassesPicker.selectedRow(inComponent: 0)]
        
        if let groupId = groupsDataSource?.groupIdAt(selectGroupPicker.selectedRow(inComponent: 0)) {
            present(cameraAssembly.classesCameraViewController(classNumber: classNumber, groupId: groupId), animated: false)
        }
    }
}

extension ClassesSelectGroupViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == selectGroupPicker {
            return groupsDataSource?.numberOfGroups() ?? 0
        } else {
            return classesNumbers.count
        }
    }
}

extension ClassesSelectGroupViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == selectGroupPicker {
            return groupsDataSource?.groupNameAt(row)
        } else {
            return classesNumbers[row]
        }
    }
}

extension ClassesSelectGroupViewController: GroupsDataSourceDelegate {
    func groupsDidUpdate() {
        DispatchQueue.main.async {
            HUD.hide()
            self.selectGroupPicker.reloadAllComponents()
        }
    }
    
    func recievedGroupLoadError(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            self.showAllert(with: errorMessage) {
                HUD.show(.progress)
                self.groupsDataSource?.getGroups()
            }
        }
    }
}

