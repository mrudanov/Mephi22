//
//  SelectGroupViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit
import PKHUD

class SeminarsSelectGroupViewController: UIViewController {
    @IBOutlet weak var selectGroupPicker: UIPickerView!
    @IBOutlet weak var selectSeminarPicker: UIPickerView!
    
    private var groupsDataSource: IGroupsDataSource?
    
    private var seminarNumbers: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    
    // MARK: - Initialization
    public static func initVC(groupsDataSource: IGroupsDataSource) -> SeminarsSelectGroupViewController {
        let selectGroupVC = UIStoryboard(name: "SeminarsSelectGroup", bundle: nil).instantiateViewController(withIdentifier: "SeminarsSelectGroup") as! SeminarsSelectGroupViewController
        selectGroupVC.groupsDataSource = groupsDataSource

        return selectGroupVC
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Seminars"
        
        groupsDataSource?.delegate = self
        groupsDataSource?.getGroups()
        
        HUD.show(.progress)
        setupPickers()
    }
    
    // MARK: - Setup
    private func setupPickers() {
        selectGroupPicker.delegate = self
        selectGroupPicker.dataSource = self
        
        selectSeminarPicker.delegate = self
        selectSeminarPicker.dataSource = self
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
    @IBAction func nextButtonPressed(_ sender: RoundedUIButton) {
        navigateToClassesCameraVieController()
    }
    
    private func navigateToClassesCameraVieController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        let cameraAssembly = appDelegate!.rootAssembly.cameraAssembly
        let seminarNumber = seminarNumbers[selectSeminarPicker.selectedRow(inComponent: 0)]
        
        if let groupId = groupsDataSource?.groupIdAt(selectGroupPicker.selectedRow(inComponent: 0)) {
            present(cameraAssembly.classesCameraViewController(classNumber: seminarNumber, groupId: groupId), animated: false)
        }
    }
}

extension SeminarsSelectGroupViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == selectGroupPicker {
            return groupsDataSource?.numberOfGroups() ?? 0
        } else {
            return seminarNumbers.count
        }
    }
}

extension SeminarsSelectGroupViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == selectGroupPicker {
            return groupsDataSource?.groupNameAt(row)
        } else {
            return seminarNumbers[row]
        }
    }
}

extension SeminarsSelectGroupViewController: GroupsDataSourceDelegate {
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

