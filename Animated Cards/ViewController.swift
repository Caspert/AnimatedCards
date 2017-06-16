//
//  ViewController.swift
//  Animated Cards
//
//  Created by Casper Biemans on 16-06-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Declare outlets
    @IBOutlet weak var deck: UIView!
    
    // Hold filled cards
    var cardViews = [CardView]()
    
    var playCards:[Card] = [
        Card(category: "Gear", title: "Ronin M vs. Glidecam", icon: "Icon", question: "Do you prefer a Ronin-M over a Glidecam?"),
        Card(category: "Music", title: "Flume", icon: "Icon", question: "What do you think of Flume?"),
        Card(category: "Video", title: "Rory Kramer", icon: "Icon", question: "Do you know Rory Kramer?"),
        Card(category: "Travel", title: "Casey Neistat", icon: "Icon", question: "Does Casey Neistat live in New York?"),
        Card(category: "Fashion", title: "Summer '17", icon: "Icon", question: "What would you where this summer?"),
        Card(category: "Music", title: "Favorite track", icon: "Icon", question: "What is your favorite track off all time?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create deck of cards (20)
        initDeckOfCards()
        self.deck.addSubview(cardViews[0])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create deck of cards and fill in the blanks
    func initDeckOfCards() {
//        print("Before: \(cardViews.count)")
        
        // Create for each entity an UIView Card and add data to it
        for (index, card) in playCards.enumerated() {
//            print("Create UIView and filling in the blanks")
//            print("Item \(index): \(card.category)")
            
            // Create CardView()
            let cardView = CardView()
            
            // Fill with data
            cardView.category.text = playCards[index].category
            cardView.title.text = playCards[index].title
//            cardView.icon.image = UIImage(named: playCards[index].icon)
            cardView.question.text = playCards[index].question
            
            
            // Add view to an array of UIView (CardView)
            cardViews.append(cardView)
            
        }
//        print("After: \(cardViews.count)")

    }


}

