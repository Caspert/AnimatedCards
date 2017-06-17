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
    
    // Set number of cards (1 front + rest) - important that the size is not greater then cardAttributes
    var totalNumberOfCards = 4

    var divisor: CGFloat!
    var score = 0
    
    // Scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    let cardInteritemSpacing: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create deck of cards (20)
        initDeckOfCards()
        
        // Lay out the first four cards to the user
        layoutCards()
        
        // Calculate 35 degrees
        divisor = (view.frame.width / 2) / 0.61
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create deck of cards and fill in the blanks
    func initDeckOfCards() {
        // Create for each entity an UIView Card and add data to it
        for (index, card) in playCards.enumerated() {
//            print("Create UIView and filling in the blanks")
//            print("Item \(index): \(card.category)")
            
            // Create an instance of CardView()
            let cardView = CardView()
//            let cardView = CardView(frame: self.view.bounds)
//            let cardView = CardView(frame: CGRect(x: 0, y: 0, width: 240, height: 320))

            
            // Fill with data
            cardView.category.text = playCards[index].category
            cardView.title.text = playCards[index].title
//            cardView.icon.image = UIImage(named: playCards[index].icon)
            cardView.question.text = playCards[index].question
            
            
            // Add view to an array of UIView (CardView)
            cardViews.append(cardView)
            
        }
    }
    
    // Layout the cards
    func layoutCards() {
        
        // Select first card of array
        let firstCard = cardViews[0]
        
        // Add firstcard as subview of card
        self.view.addSubview(firstCard)
        
        // Set attributes
        firstCard.layer.zPosition = CGFloat(cardViews.count)
        firstCard.center = self.view.center

        
        // Add tap gesture to trigger dragged function
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognizer:)))
        firstCard.addGestureRecognizer(gestureRecognizer)
        
        
        // Add pan gesture to trigger dragged function
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        firstCard.addGestureRecognizer(panGesture)

        
        // Position next cards
        for i in 1...(totalNumberOfCards - 1) {
            print("hello", i)
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
            card.center.x = self.view.center.x
            card.frame.origin.y = cardViews[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            
            // Workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == (totalNumberOfCards - 1) {
                card.frame.origin.y += 1.5
            }
            
            self.view.addSubview(card)
            
        }
        
        // Make sure that the first card in the deck is at the front
        self.view.bringSubview(toFront: firstCard)
        
        // Store current card globally
        self.selectedCard = firstCard
        
    }
    
    // Show next card - showNextCard() just adds the next card to the 4 visible cards and animates each card to move forward
    func showNextCard() {
        
        // Define duration of animation
        let animationDuration: TimeInterval = 0.2
        
        if cardViews.count <= 1 {
            reachedEndOfStack()
            return
        }
        
        // Loop through each card to move forward one by one
        for i in 1...(totalNumberOfCards - 1) {
            
            if i > (cardViews.count - 1) {
                continue
            }
            
            let card = cardViews[i]
            
            // Set attributes for next card coming
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            
            // Animate cards
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                
                if i == 1 {
                    card.center = self.view.center
                } else {
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.cardViews[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
                    card.addGestureRecognizer(panGesture)
                    
                    // Update stored card as current card globally
                    self.selectedCard = card
                }
            })

        }
        
        // Add a new card (now the 4th card in the deck) to the very back
        if totalNumberOfCards > (cardViews.count - 1) {
            if cardViews.count != 1 {
                self.view.bringSubview(toFront: cardViews[1])
            }
            return
        }
        
        let newCard = cardViews[totalNumberOfCards]
        
        // Set attributes
        newCard.layer.zPosition = CGFloat(cardViews.count - totalNumberOfCards)
        
        let downscale = cardAttributes[(totalNumberOfCards - 1)].downscale
        let alpha = cardAttributes[(totalNumberOfCards - 1)].alpha
        
        // Initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = cardViews[1].frame.origin.y - (CGFloat(totalNumberOfCards) * cardInteritemSpacing)
        self.view.addSubview(newCard)
        
        
        // Animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (Double(totalNumberOfCards - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.cardViews[1].frame.origin.y - (CGFloat(self.totalNumberOfCards - 1) * self.cardInteritemSpacing) + 1.5
        }, completion: nil)
        
        // First card needs to be in the front for proper interactivity
        self.view.bringSubview(toFront: cardViews[1])
        
    }
    
    // Reset button for dev
    @IBAction func reset(_ sender: Any) {
        resetCard()
    }
    
    // Add gesture controls for active card
    func handlePan(sender: UIPanGestureRecognizer){
        
        // The view the gesture recognizer is attached to
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // Add rotation to the cards
        // 100/2 = 50/0.61 = 81.967
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        // Dragging card to the right or left
        // Change card feedback color
        if xFromCenter > 0 {
            self.selectedCard?.view.backgroundColor = UIColor.green
            card.backgroundColor = UIColor.green
        } else {
            self.selectedCard?.view.backgroundColor = UIColor.red
            card.backgroundColor = UIColor.red
        }
        
        
        // If gesture has ended
        if sender.state == UIGestureRecognizerState.ended {
            
            // Define yes or no sections on screen - 75 from left side and right side
            if card.center.x < 75 {
                // Move off to the left side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedCard?.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    self.selectedCard?.alpha = 0
                }, completion: { (_) in
                    self.removeOldFrontCard()
                })
                showNextCard()
                return
            } else if card.center.x > (view.frame.width - 75) {
                // Move off to the right side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedCard?.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    self.selectedCard?.alpha = 0
                }, completion: { (_) in
                    self.removeOldFrontCard()
                    self.score+=1
                })
                showNextCard()
                return
            }
            
            resetCard()
            
        }
        
    }
    
    func removeOldFrontCard() {
        cardViews[0].removeFromSuperview()
        cardViews.remove(at: 0)
    }
    
    // Reset card to deck
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.selectedCard?.center = self.view.center
            self.selectedCard?.view.backgroundColor = UIColor.white
            self.selectedCard?.alpha = 1
            self.selectedCard?.transform = CGAffineTransform.identity
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
        print("Score is: \(score)")
    }


}

