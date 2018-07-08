//
// Provides View for Single Card.
//
//  Created by Vasanthakumar Annadurai on 28/06/18.
//  Copyright © 2018 Vasanthakumar Annadurai. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    // MARK: Properties.
    var color: CardViewModel.Color = CardViewModel.Color.green{
        didSet{
            setNeedsDisplay()
        }
    }
    var symbol: CardViewModel.Symbol = CardViewModel.Symbol.oval{
        didSet{
            setNeedsDisplay()
        }
    }
    var number: CardViewModel.Number = CardViewModel.Number.three{
        didSet{
            setNeedsDisplay()
        }
    }
    var shading: CardViewModel.Shading = CardViewModel.Shading.open{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var isSelected: Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    var isMatched: Bool? = false{
        didSet{
            setNeedsDisplay()
        }
    }
    
    // MARK: UIView Methods.
    override func draw(_ rect: CGRect) {
        // Draw Rounded Background.
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        Constants.cardBackgroundColor.setFill()
        roundedRect.fill()
        
        let noOfSymbolsCG = CGFloat(self.noOfSymbols)
        
        // Total width required to draw all symbols including margin between them.
        let totalSymbolsWidth = ((noOfSymbolsCG * individualSymbolWidth) + ((noOfSymbolsCG - 1) * marginBetweenSymbols))
        
        // Starting X Point to start drawing the symbols.
        var startX = (drawingRect.origin.x + ((drawingRect.width - totalSymbolsWidth) / 2))
        
        // Draw symbols.
        for _ in 0..<noOfSymbols{
            let symbolDrawingRect = CGRect(x: startX, y: drawingRect.origin.y, width: individualSymbolWidth, height: individualSymbolHeight)
            
            // Draw Symbol
            let symbolPath = drawSymbol(symbol, inRect: symbolDrawingRect)
            // Draw Shadding.
            drawShading(shading, forPath: symbolPath, inRect: symbolDrawingRect, withColor: color.colorLiteral)
            
            startX += (individualSymbolWidth + marginBetweenSymbols)
        }
        
        // Draw Matched & Selection status.
        if let matched = isMatched{
            layer.borderWidth = Constants.borderWidthForCardSelectedState
            if(matched){
                layer.borderColor = Constants.colorForCardMatchedState
            }else{
                layer.borderColor = Constants.colorForCardUnMatchedState
            }
        }else if isSelected{
            layer.borderWidth = Constants.borderWidthForCardSelectedState
            layer.borderColor = Constants.colorForCardSelectedState
        }else{
            layer.borderWidth = 0.0
        }
    }
    
    // MARK: Private Methods.
    private func drawSymbol(_ symbol: CardViewModel.Symbol, inRect rect: CGRect)-> UIBezierPath{
        let path: UIBezierPath
        
        switch symbol{
        case .oval:
            path = UIBezierPath(ovalIn: rect)
            
        case .squiggle:
            path = UIBezierPath()
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addCurve(to: CGPoint(x: rect.minX, y: rect.minY),
                          controlPoint1: CGPoint(x: (rect.minX - rect.width), y: rect.threeFourthY), controlPoint2: CGPoint(x: rect.threeFourthX, y: rect.oneFourthY))
            path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                          controlPoint1: CGPoint(x: (rect.maxX + rect.width), y: rect.oneFourthY), controlPoint2: CGPoint(x: rect.oneFourthX, y: rect.threeFourthY))
            
        case .diamond:
            path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.close()
        }
        
        return path
    }
    
    private func drawShading(_ shading: CardViewModel.Shading, forPath path: UIBezierPath, inRect rect: CGRect, withColor color: UIColor){
        switch shading {
        case .solid:
            color.setFill()
            path.fill()
            
        case .open:
            path.lineWidth = symbolPathLineWidth
            color.setStroke()
            path.stroke()
            
        case .striped:
            path.lineWidth = symbolPathLineWidth
            color.setStroke()
            path.stroke()
            
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            path.addClip()
            let stripedPath = UIBezierPath()
            var currentY = rect.minY
            while currentY < rect.maxY{
                stripedPath.move(to: CGPoint(x: rect.minX, y: currentY))
                stripedPath.addLine(to: CGPoint(x: rect.maxX, y: currentY))
                
                currentY += marginBetweenStrippes
            }
            stripedPath.lineWidth = strippedPathLineWidth
            color.setStroke()
            stripedPath.stroke()
            context?.restoreGState()
        }
    }
    
    // MARK: IB SUPPORT PROPERTIES.
    // Since Enum properties can't be expoted into InterfaceBuilder, we are using below stored properties only for IB purpose.
    @available(*, unavailable)
    @IBInspectable var colorName: String? {
        willSet {
            if let newColor = CardViewModel.Color(rawValue: newValue?.lowercased() ?? "") {
                color = newColor
            }
        }
    }
    @available(*, unavailable)
    @IBInspectable var symbolName: String? {
        willSet {
            if let newSymbol = CardViewModel.Symbol(rawValue: newValue?.lowercased() ?? "") {
                symbol = newSymbol
            }
        }
    }
    @available(*, unavailable)
    @IBInspectable var numberValue: Int = 1{
        willSet {
            if let newnumber = CardViewModel.Number(rawValue: newValue) {
                number = newnumber
            }
        }
    }
    @available(*, unavailable)
    @IBInspectable var shadingName: String? {
        willSet {
            if let newShading = CardViewModel.Shading(rawValue: newValue?.lowercased() ?? "") {
                shading = newShading
            }
        }
    }
}

// MARK: Extension
extension CardView{
    struct Constants {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cardBackgroundColor: UIColor = UIColor.white
        static let colorForCardSelectedState: CGColor = UIColor.yellow.cgColor
        static let colorForCardMatchedState: CGColor = UIColor.green.cgColor
        static let colorForCardUnMatchedState: CGColor = UIColor.red.cgColor
        static let borderWidthForCardSelectedState: CGFloat = 3.0
        
        // Margin to edges.
        static let horizontalMarginToBoundWidth: CGFloat = 0.1
        static let verticalMarginToBoundHeight: CGFloat = 0.1
        
        // Margin between shapes
        static let marginBetweenSymbolsToBoundWidth: CGFloat = 0.05
        static let maximumSymbolCount: CGFloat = 3
        
        static let symbolPathLineWidthToBoundWidth: CGFloat = 0.01
        static let strippedPathLineWidthToBoundHeight: CGFloat = 0.01
        static let marginBetweenStrippesToBoundHeight: CGFloat = 0.05
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
    private var noOfSymbols: Int {
        return number.rawValue
    }
    
    // Margin to edges.
    private var horizontalMarginToEdges: CGFloat{
        return bounds.width * Constants.horizontalMarginToBoundWidth
    }
    private var verticalMarginToEdges: CGFloat{
        return bounds.height * Constants.verticalMarginToBoundHeight
    }
    // Drawing Rect (Bounds - Margin)
    private var drawingRect: CGRect{
        return bounds.insetBy(dx: horizontalMarginToEdges, dy: verticalMarginToEdges)
    }
    private var marginBetweenSymbols: CGFloat{
        return bounds.width * Constants.marginBetweenSymbolsToBoundWidth
    }
    // Indiviual symbol width (Assiuming we have maximum symbols)
    private var individualSymbolWidth: CGFloat{
        return (drawingRect.width - ((Constants.maximumSymbolCount - 1) * marginBetweenSymbols))/Constants.maximumSymbolCount
    }
    private var individualSymbolHeight: CGFloat{
        return drawingRect.height
    }
    private var symbolPathLineWidth: CGFloat{
        return bounds.width * Constants.symbolPathLineWidthToBoundWidth;
    }
    private var strippedPathLineWidth: CGFloat{
        return bounds.height * Constants.strippedPathLineWidthToBoundHeight;
    }
    private var marginBetweenStrippes: CGFloat{
        return bounds.height * Constants.marginBetweenStrippesToBoundHeight;
    }
}

extension CGRect{
    // 1/4th of X
    var oneFourthX: CGFloat{
        return minX + (width * (1/4))
    }
    // 3/4th of X
    var threeFourthX: CGFloat{
        return minX + (width * (3/4))
    }
    // 1/4th of X
    var oneFourthY: CGFloat{
        return minY + (height * (1/4))
    }
    // 3/4th of X
    var threeFourthY: CGFloat{
        return minY + (height * (3/4))
    }
}
