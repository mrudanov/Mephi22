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
    
    private var deleteFaceInteractor: IDeleteFaceInteractor?
    
    // MARK: - Initialization
    public static func initVC(groupsDataSource: IGroupsDataSource, studentsDataSource: IStudentsDataSource, deleteFaceInteractor: IDeleteFaceInteractor) -> DeleteFacesViewController {
        let deleteFacesVC = UIStoryboard(name: "DeleteFaces", bundle: nil).instantiateViewController(withIdentifier: "DeleteFacesVC") as! DeleteFacesViewController
        
        deleteFacesVC.groupsDataSource = groupsDataSource
        deleteFacesVC.studentsDataSource = studentsDataSource
        deleteFacesVC.deleteFaceInteractor = deleteFaceInteractor
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
    
    // MARK: - Buttons
    @IBAction func deleteStudentPressed() {
        let selectedStudentIndex = selectStudentPicker.selectedRow(inComponent: 0)
        let studentId = studentsDataSource?.studentIdAt(selectedStudentIndex)
        guard studentId != nil else { return }
        
        let selectedGroupIndex = selectGroupPicker.selectedRow(inComponent: 0)
        let groupId = groupsDataSource?.groupIdAt(selectedGroupIndex)
        guard groupId != nil else { return }
        
        showAllert(title: "Are you sure?",
                   message: "Delete selected student from recognizer?",
                   actionTitle: "Delete student",
                   style: .destructive) {
                    HUD.show(.progress)
                    self.deleteFaceInteractor?.deleteStudentFromRecognizer(studentId!, groupId: groupId!) { error in
                        self.deleteStudentCompletion(studentId: studentId!, groupId: groupId!, errorMessage: error)
                    }
        }
    }
    
    @IBAction func deleteGroupPressed() {
        let selectedIndex = selectGroupPicker.selectedRow(inComponent: 0)
        let groupId = groupsDataSource?.groupIdAt(selectedIndex)
        guard groupId != nil else { return }
        
        showAllert(title: "Are you sure?",
                   message: "Delete selected group from recognizer?",
                   actionTitle: "Delete group",
                   style: .destructive) {
                    HUD.show(.progress)
                    self.deleteFaceInteractor?.daleteGroupFromRecognizer(groupId!) { error in
                        self.deleteGroupCompletion(groupId: groupId!, errorMessage: error)
                    }
        }
    }
    
    // MARK: - Completions
    private func deleteGroupCompletion(groupId: String, errorMessage: String?) {
        DispatchQueue.main.async {
            if let errorMessage = errorMessage {
                self.showAllert(title: "Can't delete group!",
                                message: errorMessage,
                                actionTitle: "Try again!",
                                style: .default) {
                                    self.deleteFaceInteractor?.daleteGroupFromRecognizer(groupId) { error in
                                        self.deleteGroupCompletion(groupId: groupId, errorMessage: errorMessage)
                                    }
                }
            } else {
                self.groupsDataSource?.getGroups()
            }
        }
    }
    
    private func deleteStudentCompletion(studentId: String,groupId: String, errorMessage: String?) {
        DispatchQueue.main.async {
            if let errorMessage = errorMessage {
                self.showAllert(title: "Can't delete student!",
                                message: errorMessage,
                                actionTitle: "Try again!",
                                style: .default) {
                                    self.deleteFaceInteractor?.deleteStudentFromRecognizer(studentId, groupId: groupId) { error in
                                        self.deleteStudentCompletion(studentId: studentId, groupId: groupId, errorMessage: error)
                                    }
                }
            } else {
                self.studentsDataSource?.getStudentsFromGroup(groupId)
            }
        }
    }
    
    // MARK: - Alerts
    private func showAllert(title: String, message: String, actionTitle: String, style: UIAlertActionStyle, action: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: actionTitle, style: style, handler: { _ in
            action()
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
            self.showAllert(title: "Network error", message: errorMessage, actionTitle: "Try again", style: .default) {
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
            self.showAllert(title: "Network error", message: errorMessage, actionTitle: "Try again", style: .destructive) {
                let selectedGroup = self.selectGroupPicker.selectedRow(inComponent: 0)
                if let selectedGroupId = self.groupsDataSource?.groupIdAt(selectedGroup) {
                    HUD.show(.progress)
                    self.studentsDataSource?.getStudentsFromGroup(selectedGroupId)
                }
            }
        }
    }
}
