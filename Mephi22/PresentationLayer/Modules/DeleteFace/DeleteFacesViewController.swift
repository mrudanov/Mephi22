//
//  DeleteFacesViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 21/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit
import PKHUD

class DeleteFacesViewController: UIViewController {
    @IBOutlet weak var selectGroupPicker: UIPickerView!
    @IBOutlet weak var selectStudentPicker: UIPickerView!
    
    private var groupsDataSource: IGroupsDataSource?
    private var studentsDataSource: IStudentsDataSource?
    
    // MARK: - Initialization
    public static func initVC(groupsDataSource: IGroupsDataSource, studentsDataSource: IStudentsDataSource) -> DeleteFacesViewController {
        let deleteFacesVC = UIStoryboard(name: "DeleteFaces", bundle: nil).instantiateViewController(withIdentifier: "DeleteFacesVC") as! DeleteFacesViewController
        deleteFacesVC.groupsDataSource = groupsDataSource
        deleteFacesVC.studentsDataSource = studentsDataSource
        return deleteFacesVC
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Delete Faces"
        
        groupsDataSource?.delegate = self
        studentsDataSource?.delegate = self
        groupsDataSource?.getGroups()
        
        HUD.show(.progress)
        setupPickers()
    }
    
    // MARK: - Setup
    private func setupPickers() {
        selectGroupPicker.delegate = self
        selectGroupPicker.dataSource = self
        
        selectStudentPicker.delegate = self
        selectGroupPicker.delegate = self
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
}

extension DeleteFacesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == selectStudentPicker {
            return studentsDataSource?.numberOfStudents() ?? 0
        } else {
            return groupsDataSource?.numberOfGroups() ?? 0
        }
    }
}

extension DeleteFacesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == selectStudentPicker {
            return studentsDataSource?.studentNameAt(row)
        } else {
            return groupsDataSource?.groupNameAt(row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == selectGroupPicker {
            if let selectedGroupId = self.groupsDataSource?.groupIdAt(row) {
                HUD.show(.progress)
                studentsDataSource?.getStudentsFromGroup(selectedGroupId)
            }
        }
    }
}

extension DeleteFacesViewController: GroupsDataSourceDelegate {
    func groupsDidUpdate() {
        DispatchQueue.main.async {
            self.selectGroupPicker.reloadAllComponents()
            let selectedGroup = self.selectGroupPicker.selectedRow(inComponent: 0)
            if let selectedGroupId = self.groupsDataSource?.groupIdAt(selectedGroup) {
                HUD.show(.progress)
                self.studentsDataSource?.getStudentsFromGroup(selectedGroupId)
            }
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

extension DeleteFacesViewController: StudentsDataSourceDelegate {
    func studentsDidUpdate() {
        DispatchQueue.main.async {
            self.selectStudentPicker.reloadAllComponents()
            HUD.hide()
        }
    }
    
    func recievedStudentsLoadError(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            self.showAllert(with: errorMessage) {
                let selectedGroup = self.selectGroupPicker.selectedRow(inComponent: 0)
                if let selectedGroupId = self.groupsDataSource?.groupIdAt(selectedGroup) {
                    HUD.show(.progress)
                    self.studentsDataSource?.getStudentsFromGroup(selectedGroupId)
                }
            }
        }
    }
}
