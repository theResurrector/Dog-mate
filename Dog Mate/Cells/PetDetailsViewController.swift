//
//  PetDetailsViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit

class PetDetailsViewController: UIViewController {
    enum CellType {
        case image
        case details
    }
    
    struct CellItem {
        var type: CellType
        var value: Any?
        
        init(type: CellType, value: Any?) {
            self.type = type
            self.value = value
        }
    }
    
    var petData: Pet?
    var dataSource: [CellItem] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
            tableView.register(UINib(nibName: "TitleSubtitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleSubtitleTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
    }

    func setupData() {
        if let pet = petData {
            if let image = pet.image, !image.isEmpty {
                if let imageUrl = URL(string: image) {
                    dataSource.append(CellItem(type: .image, value: FormFields(title: "Image", value: imageUrl)))
                }
            }
            if let name = pet.name {
                dataSource.append(CellItem(type: .details, value: FormFields(title: "Name", value: name)))
            }
            if let breed = pet.breed {
                dataSource.append(CellItem(type: .details, value: FormFields(title: "Breed", value: breed)))
            }
            if let age = pet.age {
                dataSource.append(CellItem(type: .details, value: FormFields(title: "Age", value: age)))
            }
            if let desc = pet.desc {
                dataSource.append(CellItem(type: .details, value: FormFields(title: "Description", value: desc)))
            }
            dataSource.append(CellItem(type: .details, value: FormFields(title: "Vaccinated", value: pet.vaccination)))
                
            if let dateCreated = pet.date_created {
                dataSource.append(CellItem(type: .details, value: FormFields(title: "Date Created", value: dateCreated)))
            }
        }
    }
}

extension PetDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let type = dataSource[row].type
        let value = dataSource[row].value
        
        if type == .image {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            if let field = value as? FormFields {
                if let image = field.value as? URL {
                    cell.setImage(url: image)
                }
            }
            return cell
        }
        
        if type == .details {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleSubtitleTableViewCell", for: indexPath) as! TitleSubtitleTableViewCell
            
            if let field = value as? FormFields {
                cell.titleLabel.text = field.title
                if let stringValue = field.value as? String {
                    cell.subtitleLabel.text = stringValue
                } else if let intValue = field.value as? Int {
                    cell.subtitleLabel.text = "\(intValue)"
                } else if let boolValue = field.value as? Bool {
                    cell.subtitleLabel.text = boolValue ? "Yes" : "No"
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
