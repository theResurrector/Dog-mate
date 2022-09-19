//
//  HomeLoggedInViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeLoggedInViewController: UIViewController {
    var originalPetData: [Pet] = []
    var petData: [Pet] = []
    let vaccinationStatuses: [String] = ["All", "Vaccniated", "Not Vaccinated"]
    let reference = Database.database(url: "https://dog-mate-e7f92-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    let userId: String = UserDefaults.standard.string(forKey: "userid") ?? ""
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(UINib(nibName: "DogTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DogTypeCollectionViewCell")
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var isVaccinatedButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var stackViewForPicker: UIStackView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var vaccinationPickerView: UIPickerView! {
        didSet {
            vaccinationPickerView.delegate = self
            vaccinationPickerView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        navigationItem.setLeftBarButton(logoutButton, animated: true)
        fetchData()
        self.stackViewForPicker.isHidden = true
    }
    
    @objc private func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print ("Already logged out")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addPet() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddPetViewController") as! AddPetViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func updateProfile() {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "AddPetViewController") as! AddPetViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func fetchData() {
        let petRef = self.reference.child("/pets")
        petRef.observe(.value) {[weak self] snapshot in
            guard let weakself = self else { return }
            if let value = snapshot.value as? [String: Any] {
                weakself.petData.removeAll()
                weakself.originalPetData.append(contentsOf: weakself.convertToData(data: value))
                weakself.petData.append(contentsOf: weakself.convertToData(data: value))
                weakself.collectionView.reloadData()
            }
        }
        
        let userRef = self.reference.child("/users/\(userId)")
        userRef.observe(.value) {[weak self] snapshot in
            guard let weakself = self else { return }
            if let value = snapshot.value as? [String: Any] {
                if let pet = value["pet"] as? String, !pet.isEmpty {
                    let updateProfileButton = UIBarButtonItem(title: "Update Profile", style: .plain, target: self, action: #selector(weakself.updateProfile))
                    weakself.navigationItem.setRightBarButton(updateProfileButton, animated: true)
                } else {
                    let addPetButton = UIBarButtonItem(title: "Add pet", style: .plain, target: self, action: #selector(weakself.addPet))
                    weakself.navigationItem.setRightBarButton(addPetButton, animated: true)
                }
            }
        }
    }
    
    func reloadData(status: Int) {
        self.petData = self.originalPetData
        if status == 1 {
            self.petData = self.petData.filter({ $0.vaccination == true})
        } else if status == 2 {
            self.petData = self.petData.filter({ $0.vaccination == false})
        }
        self.collectionView.reloadData()
    }
    
    func convertToData(data: [String: Any]) -> [Pet] {
        var pets: [Pet] = []
        for pet in data {
            if let petData = pet.value as? [String: Any] {
                var petObject = Pet()
                if let name = petData["name"] as? String {
                    petObject.name = name
                }
                if let age = petData["age"] as? String {
                    petObject.age = age
                }
                if let breed = petData["breed"] as? String {
                    petObject.breed = breed
                }
                if let desc = petData["desc"] as? String {
                    petObject.desc = desc
                }
                if let image = petData["image"] as? String {
                    petObject.image = image
                }
                if let dateCreated = petData["dateCreated"] as? Int {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    petObject.date_created = dateFormatter.string(from: Date(milliseconds: Int64(dateCreated)))
                }
                if let vaccination = petData["vaccination"] as? NSNumber {
                    petObject.vaccination = vaccination.boolValue
                }
                if let owner = petData["owner"] as? String {
                    petObject.owner = owner
                }
                pets.append(petObject)
            }
        }
        pets = pets.filter { $0.owner != Auth.auth().currentUser?.uid}
        return pets
    }
    
    @IBAction func vaccinationStatusButtonTapped(_ sender: UIButton) {
        self.stackViewForPicker.isHidden = false
    }
    
    @IBAction func vaccinationStatusSelectedButton(_ sender: Any) {
        let selectedValue = vaccinationPickerView.selectedRow(inComponent: 0)
        self.reloadData(status: selectedValue)
        self.stackViewForPicker.isHidden = true
    }
    
}

extension HomeLoggedInViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogTypeCollectionViewCell", for: indexPath) as! DogTypeCollectionViewCell
        cell.layer.cornerRadius = 24
        cell.clipsToBounds = true
        
        cell.updateCell(data: petData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 250
        let width = (view.frame.width - 32) / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = petData[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PetDetailsViewController") as! PetDetailsViewController
        vc.petData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeLoggedInViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vaccinationStatuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vaccinationStatuses[row]
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
        
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
