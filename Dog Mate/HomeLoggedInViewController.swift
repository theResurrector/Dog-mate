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
    var petData: [Pet] = []
    let reference = Database.database(url: "https://dog-mate-e7f92-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(UINib(nibName: "DogTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DogTypeCollectionViewCell")
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        navigationItem.setLeftBarButton(logoutButton, animated: true)
        let addPetButton = UIBarButtonItem(title: "Add pet", style: .plain, target: self, action: #selector(addPet))
        navigationItem.setRightBarButton(addPetButton, animated: true)
        
        fetchData()
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
        let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        vc.formType = .Pet
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func fetchData() {
        let petRef = self.reference.child("/pets")
        petRef.observe(.value) {[weak self] snapshot in
            guard let weakself = self else { return }
            if let value = snapshot.value as? [String: Any] {
                weakself.petData.append(contentsOf: weakself.convertToData(data: value))
                weakself.collectionView.reloadData()
            }
        }
    }
    
    func convertToData(data: [String: Any]) -> [Pet] {
        var pets: [Pet] = []
        for pet in data {
            if let petData = pet.value as? [String: Any] {
                var petObject = Pet()
                if let age = petData["age"] as? Int {
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
                if let dateCreated = petData["dateCreated"] as? String {
                    petObject.date_created = dateCreated
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
}

extension HomeLoggedInViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogTypeCollectionViewCell", for: indexPath) as! DogTypeCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 100
        let width = UIScreen.main.bounds.width / 2
        return CGSize(width: width, height: height)
    }
}
