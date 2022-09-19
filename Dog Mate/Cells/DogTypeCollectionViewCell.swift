//
//  DogTypeCollectionViewCell.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit

class DogTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBreed: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelVaccinationStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(data: Pet) {
        labelName.text = data.name
        labelBreed.text = data.breed
        labelAge.text = data.age
        labelVaccinationStatus.text = data.vaccination ? "Vaccinated" : "Not Vaccinated"
    }
}


