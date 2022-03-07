//
//  MessageBox.swift
//  RealtimeDB
//
//  Created by Admin on 07/03/22.
//

import Foundation
import UIKit

class receiverMsgBox: UIView{
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: rect.minX-5, y: rect.maxY ))
        
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX+10, y: rect.maxY-10))

         bezierPath.addLine(to: CGPoint(x: rect.minX+10, y: rect.minY+5))
         bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+15, y: rect.minY), controlPoint: CGPoint(x: rect.minX+10, y: rect.minY))
         bezierPath.addLine(to: CGPoint(x: rect.minX+15, y: rect.minY))

         bezierPath.addLine(to: CGPoint(x:rect.maxX-5, y:rect.minY))
         bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY+5), controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
         bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+5))

         bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY-5))
         bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX-5, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
         bezierPath.addLine(to: CGPoint(x: rect.maxX-5, y: rect.maxY))

        UIColor.cyan.setFill()
    
        bezierPath.fill()
        bezierPath.close()
        
        
    }
    
}


class SenderMsgBox: UIView{
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: rect.maxX+5, y: rect.minY))
            
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX-10, y: 10))

        bezierPath.addLine(to: CGPoint(x: rect.maxX-10, y: rect.maxY-5))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.maxX-15, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX-10, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX-15, y: rect.maxY))

        bezierPath.addLine(to: CGPoint(x:rect.minX+5, y:rect.maxY))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY-5), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY-5))


        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY+5))
        bezierPath.addQuadCurve(to: CGPoint(x: rect.minX+5, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.minX+5, y: rect.minY))

        UIColor.lightGray.setFill()
    
        bezierPath.fill()
        bezierPath.close()
        
        
    }
    
}

