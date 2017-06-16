//
//  CardView.swift
//  Animated Cards
//
//  Created by Casper Biemans on 16-06-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var question: UILabel!
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Load the nib named 'CardView' into memory, finding it in the main bundle.
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        
        // Adding the 'contentView' to self (self represents the instance of a WeatherView which is a 'UIView').
        addSubview(view)
        
        // Style the custom view
//        view.backgroundColor = UIColor.red
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
//        self.backgroundColor = UIColor.red

    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
