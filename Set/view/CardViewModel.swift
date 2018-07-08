//
//  A ViewModel used to construct Card View.
//
//  Created by Vasanthakumar Annadurai on 04/07/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct CardViewModel{
    
    let color: Color
    let symbol: Symbol
    let number: Number
    let shading: Shading
    let isSelected: Bool
    let isMatched: Bool?
    
    enum Color: String {
        case red
        case green
        case blue
        
        var colorLiteral: UIColor{
            switch self {
            case .red:
                return UIColor.red
            case .green:
                return UIColor.green
            case .blue:
                return UIColor.blue
            }
        }
    }
    
    enum Symbol: String {
        case oval
        case squiggle
        case diamond
    }
    
    enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum Shading: String {
        case solid
        case open
        case striped
    }
    
}
