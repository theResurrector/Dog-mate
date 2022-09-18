//
//  RadioTableViewCell.swift
//  Dog Mate
//
//  Created by NG Anson on 18/9/22.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var radioGroup: [UIButton]! {
        didSet {
            for button in radioGroup {
                button.setImage(UIImage(named:"Radio_btn"), for: .selected)
                button.setImage(UIImage(named:"Radio_btn_unchecked"), for: .normal)
            }
        }
    }
    var radioValue: [String] = []
    var didSelectRadio: ((Any)->())?
    var model: FormFieldModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(with model: FormFieldModel) {
        self.model = model
        self.titleLabel.text = model.title
        if model.field == "gender" {
            radioGroup[0].setTitle("Male", for: .normal)
            radioGroup[1].setTitle("Female", for: .normal)
        }
        
        if model.field == "vaccination" {
            radioGroup[0].setTitle("Yes", for: .normal)
            radioGroup[1].setTitle("No", for: .normal)
        }
    }
    
    @IBAction func didTapOnRadio(_ sender: UIButton) {
        for button in radioGroup {
            button.isSelected = button.tag == sender.tag
        }
        
        if self.model?.field == "vaccination" {
            // send true or false as NSNumber
            self.didSelectRadio?(sender.tag == 0 ? 1 : 0)
        } else {
            self.didSelectRadio?(sender.titleLabel?.text ?? "")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
