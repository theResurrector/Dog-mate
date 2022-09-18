//
//  TextFieldTableViewCell.swift
//  Dog Mate
//
//  Created by NG Anson on 11/9/22.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    var shouldFinishEditing: ((String) -> ())?
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(model: FormFieldModel) {
        self.textField.placeholder = model.placeHolder
    }
    
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.shouldFinishEditing?(newString)
        
        return true
    }
}

struct FormFieldModel {
    var title: String = ""
    var placeHolder: String = ""
    var field: String = ""
}
