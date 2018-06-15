//
//  ViewController for our Set Game.
//
//  Created by Vasanthakumar Annadurai on 12/06/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Variables
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var deal3MoreCardsButton: UIButton!
    
    private var game: SetGameEngine!
    
    // MARK: Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: Functions
    // Gets invoked on touch if card.
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender){
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    // Gets invoked on touch if newGame.
    @IBAction func onTouchNewGame(_ sender: UIButton) {
        setUp()
    }
    
    // Gets invoked on touch of Deal3MoreCards.
    @IBAction func onTouchDeal3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    // MARK: Private Methods
    private func setUp(){
        game = SetGameEngine()
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        let isThereEnoughCardsToMathIfYesThenItsStatus = game.isWeHaveEnoughCardsToMathIfYesThenItsStatus
        
        for index in cardButtons.indices{
            let cardButton = cardButtons[index]
            // Check if we have playingCard at the given index else hide the button.
            if index < game.playingCards.count {
                let card = game.playingCards[index]
                let attributedTitle = createAttributedTitleForCard(card: card)
                cardButton.isHidden = false
                cardButton.setAttributedTitle(attributedTitle, for: UIControlState.normal)
                
                // Draw border depending on selcted state.
                let isSelected = game.selectedCards.contains(card)
                if(isSelected){
                    cardButton.layer.borderWidth = 3.0
                    // Check if we have enough cards to match, if so the update button depending on matched state.
                    if let isMatched = isThereEnoughCardsToMathIfYesThenItsStatus{
                        cardButton.layer.borderColor = isMatched ? UIColor.green.cgColor : UIColor.red.cgColor
                    }else{
                        cardButton.layer.borderColor = UIColor.yellow.cgColor
                    }
                }else{
                    cardButton.layer.borderWidth = 0.0
                }
            }else{
                cardButton.isHidden = true
            }
        }
        
        scoreLabel.text = "Score: \(game.score)"
        
        let isWeHaveCardInDeck = !game.deck.isEmpty
        let isWeHaveRoomInUIToFitThreeNewCards = cardButtons.filter{$0.isHidden}.count>=3 // No of cards currently hidden.
        let isCurrentSelectionFormASet = isThereEnoughCardsToMathIfYesThenItsStatus ?? false // There is always room for 3 more cards if the 3 currently-selected cards are a match since we replace them.
        if (isWeHaveCardInDeck && (isWeHaveRoomInUIToFitThreeNewCards || isCurrentSelectionFormASet)){
            deal3MoreCardsButton.isHidden = false
        }else{
            deal3MoreCardsButton.isHidden = true
        }
    }
    
    // A Method creates Attributed Title for CardButton from CardModel.
    private func createAttributedTitleForCard(card: Card) -> NSAttributedString{
        var cardTitle = ""
        var attributes: [NSAttributedStringKey: Any] = [:]
        
        if let color = ModelToView.color[card.color], let symbol = ModelToView.symbol[card.symbol],
            let alpha = ModelToView.alpha[card.shading], let strokeWidth = ModelToView.strokeWidth[card.shading]{
            // Title.
            switch card.number{
            case .One: cardTitle = symbol
            case .Two: cardTitle = "\(symbol)\n\(symbol)"
            case .Three: cardTitle = "\(symbol)\n\(symbol)\n\(symbol)"
            }
            
            // Attributes
            attributes[NSAttributedStringKey.foregroundColor] = color.withAlphaComponent(alpha)
            attributes[NSAttributedStringKey.strokeWidth] = strokeWidth
            attributes[NSAttributedStringKey.strokeColor] = color
        }
        
        let attributedContent = NSAttributedString(string: cardTitle, attributes: attributes)
        return attributedContent
    }
}

struct ModelToView{
    static let color = [Card.Color.Red : UIColor.red, .Green : UIColor.green, .Blue : UIColor.blue]
    static let symbol = [Card.Symbol.Oval : "●", .Squiggle : "■", .Diamond : "▲"]
    static let alpha: [Card.Shading: CGFloat] = [Card.Shading.Solid : 1.0, .Open : 1.0, .Striped : 0.15]
    static let strokeWidth = [Card.Shading.Solid : 0, .Open : 5, .Striped : -5]
}

