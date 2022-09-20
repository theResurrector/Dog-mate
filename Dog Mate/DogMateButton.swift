//
//  DogMateButton.swift
//  Dog Mate
//
//  Created by NG Anson on 20/9/22.
//

import UIKit

@IBDesignable
class DogMateButton: UIButton {
    var borderWidth = 2.0
    var borderColor = UIColor.black.cgColor
    @IBInspectable
    var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 2.0
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.titleLabel?.textColor = UIColor.black
    }
}
