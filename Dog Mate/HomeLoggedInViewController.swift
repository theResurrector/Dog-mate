//
//  HomeLoggedInViewController.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit
import FirebaseAuth

class HomeLoggedInViewController: UIViewController {
    var data: [String] = []
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
    }
}

extension HomeLoggedInViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
