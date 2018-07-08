//
//  A Container class responsible to create Card View & arrange them in Grid like layout.
//
//  Created by Vasanthakumar Annadurai on 04/07/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import UIKit

protocol CardContainerViewDelegation {
    func onCardTapped(at index: Int)
}

class CardContainerView: UIView {
    
    // MARK: Properties.
    var cardVMs:[CardViewModel] = []{
        didSet{
            setNeedsLayout()
        }
    }
    var delegatee: CardContainerViewDelegation?
    private var cardViews:[CardView] = []
    private var grid: Grid = Grid(layout: Grid.Layout.aspectRatio(Constants.aspectRatioForTheCardView))
    
    struct Constants {
        static let aspectRatioForTheCardView: CGFloat = 3/2
        static let marginBetweenCardsToItsFrame: CGFloat = 0.05
    }
    
    // MARK: UIView Methods.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Create / Remove Card SubViews.
        // Create Card SubView - If number of cards has been increased then we need to create view for those cards.
        // Remove Card SubViews - If number of cards has been reduced then we need to remove previously added cards views if any.
        if cardViews.count < cardVMs.count{
            for _ in (cardViews.count..<cardVMs.count){
                let cardView = CardView(frame: CGRect.zero)
                cardViews.append(cardView)
                addSubview(cardView)
                cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchCard(regonizer:))))
            }
        }else if cardViews.count > cardVMs.count{
            // Note - Remove from end else we will get index out of bound exception.
            for index in (cardVMs.count..<cardViews.count).reversed(){
                let cardViewToRemove = cardViews.remove(at: index)
                cardViewToRemove.removeFromSuperview()
            }
        }
        
        // Update grid with current frame & cards cound to calculate new frames for cards.
        grid.frame = bounds
        grid.cellCount = cardVMs.count
        
        // Update Card View with Model.
        for index in cardVMs.indices{
            if var cardFrame = grid[index]{
                // Add margin between cards.
                cardFrame = cardFrame.insetBy(dx: Constants.marginBetweenCardsToItsFrame * cardFrame.width, dy: Constants.marginBetweenCardsToItsFrame * cardFrame.height)
                
                let cardView = cardViews[index]
                let cardVM = cardVMs[index]
                cardView.frame = cardFrame
                updateCardViewWithModel(cardView: cardView, cardVM: cardVM)
            }
        }
    }
    
    // MARK: Action Methods.
    @objc func touchCard(regonizer: UITapGestureRecognizer){
        if let touchedCard = regonizer.view as? CardView{
            if let indexOfTouchedCard = cardViews.index(of: touchedCard){
                delegatee?.onCardTapped(at: indexOfTouchedCard)
            }
        }
    }
    
    // MARK: Private Methods.
    private func updateCardViewWithModel(cardView: CardView, cardVM: CardViewModel){
        cardView.color = cardVM.color
        cardView.symbol = cardVM.symbol
        cardView.number = cardVM.number
        cardView.shading = cardVM.shading
        cardView.isSelected = cardVM.isSelected
        cardView.isMatched = cardVM.isMatched
    }
}
