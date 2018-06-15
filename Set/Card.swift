//
//  Card Model.
//
//  Created by Vasanthakumar Annadurai on 12/06/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import Foundation

struct Card: Equatable{
    
    let color: Color
    let symbol: Symbol
    let number: Number
    let shading: Shading
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.symbol == rhs.symbol &&
            lhs.number == rhs.number &&
            lhs.shading == rhs.shading
    }
    
    enum Color {
        case Red
        case Green
        case Blue
        
        static let all = [Color.Red, .Green, .Blue]
    }
    
    enum Symbol {
        case Oval
        case Squiggle
        case Diamond
        
        static let all = [Symbol.Oval, .Squiggle, .Diamond]
    }
    
    enum Number {
        case One
        case Two
        case Three
        
        static let all = [Number.One, .Two, .Three]
    }
    
    enum Shading {
        case Solid
        case Open
        case Striped
        
        static let all = [Shading.Solid, .Open, .Striped]
    }
    
}
