//
//  TowerView.swift
//  hanoi-towers
//
//  Created by sergey on 22.04.2022.
//

import Cocoa

class TowerView: NSView {
    
    var diskCount = 4
    
    var lTowers: [NSRect] = []
    var cTowers: [NSRect] = []
    var rTowers: [NSRect] = []
    var mouseRect: NSRect = NSRect()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        axes()
        
        let viewWidth = self.bounds.width
        
        NSColor.black.setFill()
        for i in lTowers.indices {
            lTowers[i].origin.x = viewWidth*1/3 - viewWidth/6 - lTowers[i].width/2
            if i > 0 {
                lTowers[i].origin.y = lTowers[i-1].origin.y+lTowers[i-1].height+1
            } else {
                lTowers[i].origin.y = self.bounds.origin.y
            }
            lTowers[i].fill()
        }
        
        for i in cTowers.indices {
            cTowers[i].origin.x = viewWidth*2/3 - viewWidth/6 - cTowers[i].width/2
            if i > 0 {
                cTowers[i].origin.y = cTowers[i-1].origin.y+cTowers[i-1].height+1
            } else {
                cTowers[i].origin.y = self.bounds.origin.y
            }
            cTowers[i].fill()
        }
        
        for i in rTowers.indices {
            rTowers[i].origin.x = viewWidth*3/3 - viewWidth/6 - rTowers[i].width/2
            if i > 0 {
                rTowers[i].origin.y = rTowers[i-1].origin.y+rTowers[i-1].height+1
            } else {
                rTowers[i].origin.y = self.bounds.origin.y
            }
            rTowers[i].fill()
        }
        
        NSColor.red.setFill()
        mouseRect.fill()
    }
    
    func axes() {
        let base = NSBezierPath()
        let origin = self.bounds.origin
        base.move(to: origin)
        base.line(to: NSPoint(x: self.bounds.width, y: origin.y))
        
        base.stroke()
        
        NSColor.red.setStroke()
        for i in 1...3 {
            let line = NSBezierPath()
            line.lineWidth = 3
            let viewWidth = self.bounds.width
            let origin = NSPoint(x: viewWidth*CGFloat(i)/3 - viewWidth/6, y: self.bounds.origin.y)
            let end = NSPoint(x: origin.x, y: self.bounds.height)
            
            line.move(to: origin)
            line.line(to: end)
            
            line.stroke()
        }
    }
    
    func setTowers() {
        lTowers.removeAll()
        cTowers.removeAll()
        rTowers.removeAll()
        for i in 1...diskCount {
            let iFl = Float(i)
            let rectWidth: CGFloat = CGFloat(256*powf(1.3, 1-iFl))
            let rectHeight: CGFloat = 32-2*CGFloat(i-1)
            let size = CGSize(width: rectWidth, height: rectHeight)
            let rect = NSRect(origin: CGPoint(), size: size)
            lTowers.append(rect)
        }
    }
    
}
