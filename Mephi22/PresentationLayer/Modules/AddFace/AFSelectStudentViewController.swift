//
//  AFSelectStudentViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 09/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit
import PKHUD

class AFSelectStudentViewController: UIViewController {
    @IBOutlet weak var selectGroupPicker: UIPickerView!
    @IBOutlet weak var selectStudentPicker: UIPickerView!
    
    private var groupsDataSource: IGroupsDataSource?
    private var studentsDataSource: IStudentsDataSource?
    
    // MARK: - Initialization
    public static func initVC(groupsDataSource: IGroupsDataSource, studentsDataSource: IStudentsDataSource) -> AFSelectStudentViewController {
        let selectStudentVC = UIStoryboard(name: "AFSelectStudent", bundle: nil).instantiateViewController(withIdentifier: "AFSelectStudent") as! AFSelectStudentViewController
        selectStudentVC.groupsDataSource = groupsDataSource
        selectStudentVC.studentsDataSource = studentsDataSource
        return selectStudentVC
    }
        
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Add Face"
        
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
        selectStudentPicker.dataSource = self
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
        navigateToAFCameraVieController()
    }
    
    private func navigateToAFCameraVieController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        let cameraAssembly = appDelegate!.rootAssembly.cameraAssembly
        
        if let studentId = studentsDataSource?.studentIdAt(selectStudentPicker.selectedRow(inComponent: 0)),
            let groupId = groupsDataSource?.groupIdAt(selectGroupPicker.selectedRow(inComponent: 0)) {
            present(cameraAssembly.addFacesCameraViewController(groupId: groupId, studentId: studentId), animated: true)
        }
    }
}

extension AFSelectStudentViewController: UIPickerViewDataSource {
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

extension AFSelectStudentViewController: UIPickerViewDelegate {
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

extension AFSelectStudentViewController: GroupsDataSourceDelegate {
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

extension AFSelectStudentViewController: StudentsDataSourceDelegate {
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
