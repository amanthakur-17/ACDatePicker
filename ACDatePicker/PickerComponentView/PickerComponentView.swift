//
//  PickerComponentView.swift
//  PizzNpints
//
//  Created by Dinesh Saini on 20/12/21.
//

import UIKit

class PickerComponentView: UIView {
    
    @IBOutlet weak var pickerTitle:UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> PickerComponentView {
        return UINib(nibName: "PickerComponentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PickerComponentView
    }

}
