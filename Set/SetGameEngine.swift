//
//  SetEngine - Model for our Set Game.
//
//  Created by Vasanthakumar Annadurai on 12/06/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import Foundation

class SetGameEngine {
    
    // MARK: Variables
    private(set) var deck = [Card]()
    private(set) var playingCards = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var score = 0
    // Returns nil -> If We don't have enough cards (3 cards) to match, TRUE -> If we have three cards & they match, FALSE -> If we have three cards & they don't match.
    var isWeHaveEnoughCardsToMathIfYesThenItsStatus: Bool?{
        if(selectedCards.count == 3){
            // We have three cards already selected.
            let isMatch = isSelectedCardsFormASet(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2])
            return isMatch
        }
        return nil
    }
    
    // MARK: Init
    init() {
        createDeckOfCards()
        deck.suffle()
        initializePlayingCards()
    }
    
    // MARK: Functions
    // Choose Card.
    func chooseCard(at index: Int){
        assert(playingCards.indices.contains(index), "SetGameEngine.chooseCard(at: \(index):  chosen index is not in the playing cards")
        
        let choosenCard = playingCards[index]
        
        // If we have enough cards to match - Then check if they form Set.
        if let isMatch = isWeHaveEnoughCardsToMathIfYesThenItsStatus {
            // If they match - Replace the matched cards & reset the selectedCards, else just reset the selectedCards.
            if(isMatch){
                replaceSelectedCardsBecauseTheyMatch()
                score += 3
            }else{
                score -= 5
            }
            selectedCards = []
        }
        
        if !matchedCards.contains(choosenCard) {
            if let indexInSelectedCard = selectedCards.index(of: choosenCard){
                // User has choosen a card which is already selected - Thus deselect the chosen card.
                selectedCards.remove(at: indexInSelectedCard)
                score -= 1
            }
            else{
                // User has choosen a new card.
                selectedCards.append(choosenCard)
            }
        }
    }
    
    // Deal 3 More Cards.
    func deal3MoreCards(){
        // Check if currently selected cards match.
        if let isMatch = isWeHaveEnoughCardsToMathIfYesThenItsStatus, isMatch == true{
            replaceSelectedCardsBecauseTheyMatch()
            selectedCards = []
        }else{
            // Else - Take three cards from deck & add it to playingCards.
            for _ in 0..<3{
                if !deck.isEmpty{
                    playingCards.append(deck.remove(at: 0))
                }
            }
        }
    }
    
    // MARK: Private Methods
    // Create Deck of cards with 81 Cards (Combination of unique features).
    private func createDeckOfCards(){
        for color in Card.Color.all{
            for symbol in Card.Symbol.all{
                for number in Card.Number.all{
                    for shading in Card.Shading.all{
                        let card = Card(color: color, symbol: symbol, number: number, shading: shading)
                        deck.append(card)
                    }
                }
            }
        }
    }
    
    // Initially Take 12 cards from deck & add it to playing cards.
    private func initializePlayingCards(){
        for _ in 0..<12{
            playingCards.append(deck.remove(at: 0))
        }
    }
    
    // Return TRUE - If selected cards form a set else FALSE.
    // Set Rules - A 'Set' consists of three cards in which each feature is EITHER the same on each card OR is different on each card.
    // That is to say, any feature in the 'Set' of three cards is either common to all three cards or is different on each card.
    private func isSelectedCardsFormASet(card1: Card, card2: Card, card3: Card)->Bool{
        let uniqueColors: Set<Card.Color> = [card1.color, card2.color, card3.color]
        let uniqueSymbols: Set<Card.Symbol> = [card1.symbol, card2.symbol, card3.symbol]
        let uniqueNumbers: Set<Card.Number> = [card1.number, card2.number, card3.number]
        let uniqueShadings: Set<Card.Shading> = [card1.shading, card2.shading, card3.shading]
        
        // Count should be 1 (All Same) Or 3 (All Different).
        return (uniqueColors.count != 2 && uniqueSymbols.count != 2 && uniqueNumbers.count != 2 && uniqueShadings.count != 2)
    }
    
    // Call this method, when selected cards are matched & needs to be replaced with new cards from deck.
    private func replaceSelectedCardsBecauseTheyMatch(){
        for selectedCard in selectedCards{
            if let indexInPlayingCard = playingCards.index(of: selectedCard){
                let removedCard = playingCards.remove(at: indexInPlayingCard)
                matchedCards.append(removedCard)
                if !deck.isEmpty{
                    playingCards.insert(deck.remove(at: 0), at: indexInPlayingCard)
                }
            }
        }
    }
}

extension Int{
    // Returns Random Int between 0..<self
    var arc4random: Int{
        if self>0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if(self < 0){
            return Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

extension Array{
    // Suffle the Array (1000 Times)
    mutating func suffle(){
        for _ in 1...1000{
            for index in self.indices{
                let randomIndex = self.count.arc4random
                let temp = self[index]
                self[index] = self[randomIndex]
                self[randomIndex] = temp
            }
        }
    }
}
