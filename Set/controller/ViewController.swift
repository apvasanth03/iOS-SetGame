//
//  ViewController for our Set Game.
//
//  Created by Vasanthakumar Annadurai on 12/06/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardContainerViewDelegation {
    
    // MARK: Variables
    @IBOutlet weak var cardCollectionView: CardContainerView!{
        didSet{
            cardCollectionView.delegatee = self
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var deal3MoreCardsButton: UIButton!
    
    private var game: SetGameEngine!
    
    // MARK: UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // Mark: CardContainerViewDelegation Functions.
    func onCardTapped(at index: Int) {
        game.chooseCard(at: index)
        updateViewFromModel()
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
        // Cards.
        var cardVMs = [CardViewModel]()
        for card in game.playingCards{
            let isSelected = game.selectedCards.contains(card)
            let isMatched = isSelected ? game.isWeHaveEnoughCardsToMathIfYesThenItsStatus : nil
            if let cardVM = ModelToView.convertCardModelToViewModel(card: card, isSelected: isSelected, isMatched: isMatched){
                cardVMs.append(cardVM)
            }
        }
        cardCollectionView.cardVMs = cardVMs
        
        // Score Label.
        scoreLabel.text = "Score: \(game.score)"
        
        // Deal 3 More Cards.
        let isWeHaveCardInDeck = !game.deck.isEmpty
        if (isWeHaveCardInDeck){
            deal3MoreCardsButton.isHidden = false
        }else{
            deal3MoreCardsButton.isHidden = true
        }
    }
}

struct ModelToView{
    
    static let color = [Card.Color.Red : CardViewModel.Color.red, .Green : .green, .Blue : .blue]
    static let symbol = [Card.Symbol.Oval : CardViewModel.Symbol.oval, .Squiggle : .squiggle, .Diamond : .diamond]
    static let number = [Card.Number.One: CardViewModel.Number.one, .Two: .two, .Three: .three]
    static let shading = [Card.Shading.Solid: CardViewModel.Shading.solid, .Open:.open, .Striped:.striped]
    
    static func convertCardModelToViewModel(card: Card, isSelected: Bool, isMatched: Bool?) -> CardViewModel?{
        var cardVM: CardViewModel? = nil
        if let color = ModelToView.color[card.color], let symbol = ModelToView.symbol[card.symbol],
            let number = ModelToView.number[card.number], let shading = ModelToView.shading[card.shading]{
            cardVM = CardViewModel(color: color, symbol: symbol, number: number, shading: shading, isSelected: isSelected, isMatched: isMatched)
        }
        return cardVM
    }
}

