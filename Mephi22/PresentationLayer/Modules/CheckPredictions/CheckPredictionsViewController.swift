//
//  CheckPredictionsViewController.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 24/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit
import PKHUD

class CheckPredictionsViewController: UIViewController {
    private struct StudentDisplayModel {
        var studentId: String
        var studentName: String?
        var checked: Bool
    }
    
    private var studentsDataSource: IStudentsDataSource?
    private var students: [(StudentDisplayModel, Float)] = []
    private var recognizedStudents: [(String, Float)] = []
    private var groupId: String?
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    public static func initVC(studentsDataSource: IStudentsDataSource, recognizedStudents: [(String, Float)], groupId: String) -> CheckPredictionsViewController {
        let checkPredictionsVC = UIStoryboard(name: "CheckPredictions", bundle: nil).instantiateViewController(withIdentifier: "CheckPredictions") as! CheckPredictionsViewController
        checkPredictionsVC.studentsDataSource = studentsDataSource
        checkPredictionsVC.groupId = groupId
        checkPredictionsVC.recognizedStudents = recognizedStudents
        return checkPredictionsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Check"
        
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
        
        guard let groupId = groupId else { return }
        studentsDataSource?.delegate = self
        studentsDataSource?.getStudentsFromGroup(groupId)
        
        HUD.show(.progress)
    }
    
    private func mapStudents() {
        guard let studentsDataSource = studentsDataSource else { return }
        for i in 0..<studentsDataSource.numberOfStudents() {
            let studentId = studentsDataSource.studentIdAt(i)
            let studentName = studentsDataSource.studentNameAt(i)
            
            var isChecked = false
            var confidence: Float = -1.0
            if let index = recognizedStudents.index(where: { (id, _) -> Bool in id == studentId }) {
                isChecked = true
                (_, confidence) = recognizedStudents[index]
            }
            
            let studentToAppend = (
                StudentDisplayModel(studentId: studentId, studentName: studentName, checked: isChecked),
                confidence)
            students.append(studentToAppend)
        }
        
        studentsTableView.reloadData()
    }
    
    // MARK: - Done
    @objc private func donePressed() {
        // TODO: - Send attendance request to miphi22
        HUD.flash(.success)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard appDelegate != nil else { return }
        
        appDelegate?.rootAssembly.mainNavigationController.popViewController(animated: true)
    }
    
    // MARK: - Alert
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

extension CheckPredictionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        students[indexPath.row].0.checked = !students[indexPath.row].0.checked
        studentsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension CheckPredictionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "StudentCell")
        let text = "\(students[indexPath.row].0.studentName ?? "Unknown")"
        print(students[indexPath.row].1)
        cell.textLabel?.text = text
        cell.accessoryType = students[indexPath.row].0.checked ? .checkmark : .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recognized students"
    }
}

extension CheckPredictionsViewController: StudentsDataSourceDelegate {
    func studentsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            HUD.hide()
            self?.mapStudents()
        }
    }
    
    func recievedStudentsLoadError(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            self.showAllert(with: errorMessage) {
                guard let groupId = self.groupId else { return }
                
                HUD.show(.progress)
                self.studentsDataSource?.getStudentsFromGroup(groupId)
            }
        }
    }
}
