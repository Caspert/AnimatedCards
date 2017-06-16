//
//  Card.swift
//  Animated Cards
//
//  Created by Casper Biemans on 16-06-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import Foundation

class Card {
    
    // Declare properties
    var category = ""
    var title = ""
    var icon = ""
    var question = ""
    
    init(category:String, title:String, icon:String, question:String) {
        self.category = category
        self.title = title
        self.icon = icon
        self.question = question
    }
    
}
