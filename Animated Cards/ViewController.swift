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
    var selectedCard:CardView?
    
    var playCards:[Card] = [
        Card(category: "Gear", title: "Ronin M vs. Glidecam", icon: "Icon", question: "Do you prefer a Ronin-M over a Glidecam?"),
        Card(category: "Music", title: "Flume", icon: "Icon", question: "What do you think of Flume?"),
        Card(category: "Video", title: "Rory Kramer", icon: "Icon", question: "Do you know Rory Kramer?"),
        Card(category: "Travel", title: "Casey Neistat", icon: "Icon", question: "Does Casey Neistat live in New York?"),
        Card(category: "Fashion", title: "Summer '17", icon: "Icon", question: "What would you where this summer?"),
        Card(category: "Music", title: "Favorite track", icon: "Icon", question: "What is your favorite track off all time?")
    ]
    
    var divisor: CGFloat!
    
    // Scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    let cardInteritemSpacing: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create deck of cards (20)
        initDeckOfCards()
//        self.deck.addSubview(cardViews[0])
        
//        cardViews[0].view.backgroundColor = UIColor.yellow
//        cardViews[0].view.center.x = self.deck.center.x / 2
//        cardViews[0].view.center.y = self.deck.center.y / 2
        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognizer:)))
//        cardViews[0].view.addGestureRecognizer(gestureRecognizer)
        
        
        // Lay out the first four cards to the user
        layoutCards()
        
        // Calculate 45 degrees
        divisor = (view.frame.width / 2) / 0.61

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
//            let cardView = CardView()
            let cardView = CardView(frame: self.view.bounds)

            
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
    
    // Layout the cards
    func layoutCards() {
        
        // Select first card of array
        let firstCard = cardViews[0]
        
        // Add firstcard as subview of card
        self.deck.addSubview(firstCard)
        
        // Set attributes
        firstCard.layer.zPosition = CGFloat(cardViews.count)
//        firstCard.center = self.card.center
//        firstCard.center = self.deck.center
//        firstCard.view.center.x = self.deck.center.x / 2
//        firstCard.view.center.y = self.deck.center.y / 2

        
        // Add tap gesture to trigger dragged function
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognizer:)))
        firstCard.view.addGestureRecognizer(gestureRecognizer)
        
        
        // Add pan gesture to trigger dragged function
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        firstCard.view.addGestureRecognizer(panGesture)

        
        // Position next cards
        for i in 1...3 {
            
            if i > (cardViews.count - 1) {
                continue
            }
            
            let card = cardViews[i]
            
            // Set position begind previous
            card.layer.zPosition = CGFloat(cardViews.count - i)
            
            // Set attributes for other cards
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            // Position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.deck.center.x
            card.frame.origin.y = cardViews[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            
            // Workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            
            self.deck.addSubview(card)
            
        }
        
        // Make sure that the first card in the deck is at the front
        self.deck.bringSubview(toFront: firstCard)
        
        self.selectedCard = firstCard
        
    }
    
    
    // Reset button for dev
    @IBAction func reset(_ sender: Any) {
        resetCard()
    }
    
    // Add gesture controls for active card
    func handlePan(sender: UIPanGestureRecognizer){
//        print("Hello World!")
        // selectedCard was by default card
        deck = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = deck.center.x - view.center.x
        deck.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // Add rotation to the cards
        // 100/2 = 50/0.61 = 81.967
        deck.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        
        // Change card feedback color
        if xFromCenter > 0 {
            self.deck.backgroundColor = UIColor.green
        } else {
            self.deck.backgroundColor = UIColor.red
        }
        
        
        // If gesture has ended
        if sender.state == UIGestureRecognizerState.ended {
            
            // Define yes or no sections on screen - 75 from left side and right side
            if deck.center.x < 75 {
                // Move off to the left side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    self.deck.center = CGPoint(x: self.deck.center.x - 200, y: self.deck.center.y + 75)
                    self.deck.alpha = 0
                })
//                showNextCard()
                return
            } else if deck.center.x > (view.frame.width - 75) {
                // Move off to the right side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    self.deck.center = CGPoint(x: self.deck.center.x + 200, y: self.deck.center.y + 75)
                    self.deck.alpha = 0
                })
//                showNextCard()
                return
            }
            
            resetCard()
            
        }
    }
    
    
    // Reset card to deck
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
//            self.card.center = self.view.center
//            self.card.alpha = 1
////            self.card.backgroundColor = UIColor.lightGray
//            self.card.backgroundColor = UIColor.white
//            self.card.transform = CGAffineTransform.identity
        })
    }
    
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Reached end of stack
    func reachedEndOfStack() {
        print("There are no more cards")
    }


}

