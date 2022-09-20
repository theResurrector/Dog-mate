//
//  DogTypeCollectionViewCell.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit
import Kingfisher

class DogTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBreed: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelVaccinationStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(data: Pet) {
        if let url = URL(string: data.image ?? "") {
            ivImage.kf.setImage(with: url)
        }
        labelName.text = data.name
        labelBreed.text = data.breed
        labelAge.text = data.age
        labelVaccinationStatus.text = data.vaccination ? "Vaccinated" : "Not Vaccinated"
    }
}


