//
//  AddPetViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddPetViewController: UIViewController {
    enum CellType {
        case imageLoader
        case formFields
        case radioGroup
    }
    
    struct CellItem {
        var type: CellType
        var value: Any?
        
        init(type: CellType, value: Any?) {
            self.type = type
            self.value = value
        }
    }
    
    var dataSource: [[CellItem]] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
            tableView.register(UINib(nibName: "RadioTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var reference: DatabaseReference = Database.database(url: "https://dog-mate-e7f92-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFields()
    }
    
    func setupFields() {
        let name = CellItem(type:.formFields, value: FormFields(field: "name", placeholder: "Name"))
        let description = CellItem(type:.formFields, value: FormFields(field: "desc", placeholder: "Description"))
        let breed = CellItem(type:.formFields, value: FormFields(field: "breed", placeholder: "Breed"))
        let gender = CellItem(type:.radioGroup, value: FormFields(title: "Gender", field: "gender"))
        let age = CellItem(type:.formFields, value: FormFields(field: "age", placeholder: "Age"))
        let vaccinationStatus = CellItem(type:.radioGroup, value: FormFields(title: "Vaccinated?", field: "vaccination"))
        let formFields = [name, description, gender, breed, age, vaccinationStatus]
        dataSource.append(formFields)
    }
    
    func completePetProfile() {
        var dict: [String: Any] = [:]
        var missingValue = 0
        for data in dataSource[0] {
            if let formField = data.value as? FormFields {
                if let value = formField.value as? String, !value.isEmpty {
                    dict[formField.field] = value
                } else if let intValue = formField.value as? Int {
                    dict[formField.field] = intValue
                } else if let boolValue = formField.value as? NSNumber {
                    dict[formField.field] = boolValue
                } else {
                    missingValue += 1
                    return
                }
            }
        }
        
        if missingValue == 0 {
            let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
            dict["dateCreated"] = Int(Date().timeIntervalSince1970*1000)
            dict["owner"] = userId
            let uniquePetId = UUID().uuidString

            reference.child("pets/\(uniquePetId)").setValue(dict)
            reference.child("users/\(userId)").updateChildValues(["pet": uniquePetId])
            
            if self.navigationController?.viewControllers.count ?? 0 == 3 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        completePetProfile()
    }
    
}

extension AddPetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let type = dataSource[section][row].type
        let value = dataSource[section][row].value
        
        if type == .formFields {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            
            if let field = value as? FormFields {
                let model = FormFieldModel(placeHolder: field.placeholder ?? "")
                cell.update(model: model)
                
                cell.shouldFinishEditing = ({ [weak self] text in
                    guard let weakself = self else { return }
                    if var formField = weakself.dataSource[section][row].value as? FormFields {
                        formField.value = text
                        weakself.dataSource[section][row].value = formField
                    }
                })
            }
            return cell
        } else if type == .radioGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTableViewCell", for: indexPath) as! RadioTableViewCell
            
            if let field = value as? FormFields {
                let model = FormFieldModel(title: field.title , field: field.field)
                cell.updateCell(with: model)
                
            }
            
            cell.didSelectRadio = ({[weak self] selectedValue in
                guard let weakself = self else { return }
                if var formField = weakself.dataSource[section][row].value as? FormFields {
                    formField.value = selectedValue
                    weakself.dataSource[section][row].value = formField
                }
            })
            return cell
        }
        
        return UITableViewCell()
    }
}
