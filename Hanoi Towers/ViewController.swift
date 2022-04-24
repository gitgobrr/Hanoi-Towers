//
//  ViewController.swift
//  hanoi-towers
//
//  Created by sergey on 22.04.2022.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        towerView.wantsLayer = true
        towerView.layer?.backgroundColor = CGColor(gray: 1, alpha: 0.6)
        
        towerView.diskCount = 4
        numberOfDisks.stringValue = "Number of disks: \(towerView.diskCount)"
        
        towerView.setTowers()
        towerView.display()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    var moveCount: Int {
        get {
            var str = numberOfMoves.stringValue
            str.removeFirst(7)
            
            return Int(str)!
        }
        set {
            numberOfMoves.stringValue = "Moves: \(newValue)"
        }
    }
    
    
    
    var tRect: NSRect = NSRect()
    
    @IBOutlet weak var towerView: TowerView!
    
    @IBOutlet weak var numberOfDisks: NSTextField!
    
    @IBOutlet weak var numberOfMoves: NSTextField!
    
    @IBAction func addDisk(_ sender: Any) {
        guard towerView.diskCount < 8 else { return }
        towerView.diskCount += 1
        numberOfDisks.stringValue = "Number of disks: \(towerView.diskCount)"
        moveCount = 0
        towerView.setTowers()
        towerView.display()
    }
    
    @IBAction func removeDisk(_ sender: Any) {
        guard towerView.diskCount > 1 else { return }
        towerView.diskCount -= 1
        numberOfDisks.stringValue = "Number of disks: \(towerView.diskCount)"
        moveCount = 0
        towerView.setTowers()
        towerView.display()
    }
    
    
    @IBAction func reset(_ sender: Any) {
        moveCount = 0
        numberOfMoves.stringValue = "Moves: \(moveCount)"
        towerView.setTowers()
        towerView.display()
    }
    
    override func mouseDown(with event: NSEvent) {
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        
        let viewWidth = towerView.bounds.width
        let viewHeight = towerView.bounds.height
        
        
        var l: ClosedRange<CGFloat>!
        var m: ClosedRange<CGFloat>!
        var r: ClosedRange<CGFloat>!
        for i in 1...3 {
            switch i {
            case 1:
                l = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            case 2:
                m = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            default:
                r = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            }
        }
        
        let heightRange = self.view.bounds.height-viewHeight...self.view.bounds.height
        
        switch (x,y) {
        case (l,heightRange):
            if !towerView.lTowers.isEmpty {
                tRect = towerView.lTowers.removeLast()
                towerView.mouseRect = tRect
                towerView.display()
            }
        case (m,heightRange):
            if !towerView.cTowers.isEmpty {
                tRect = towerView.cTowers.removeLast()
                towerView.mouseRect = tRect
                towerView.display()
            }
        case (r,heightRange):
            if !towerView.rTowers.isEmpty {
                tRect = towerView.rTowers.removeLast()
                towerView.mouseRect = tRect
                towerView.display()
            }
        default:
            break
        }
        
    }
    
    override func mouseUp(with event: NSEvent) {
        towerView.mouseRect = NSRect()
        guard !tRect.isEmpty else {return}
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        
        let viewWidth = towerView.bounds.width
        let viewHeight = towerView.bounds.height
        
        var l: ClosedRange<CGFloat>!
        var m: ClosedRange<CGFloat>!
        var r: ClosedRange<CGFloat>!
        for i in 1...3 {
            switch i {
            case 1:
                l = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            case 2:
                m = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            default:
                r = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            }
        }

        let heightRange = self.view.bounds.height-viewHeight...self.view.bounds.height
        
        switch (x,y) {
        case (l,heightRange):
            if let lowestWidth = towerView.lTowers.last?.width {
                guard tRect.width < lowestWidth else {
                    reRect(tRect)
                    return
                }
            }
            towerView.lTowers.append(tRect)
            towerView.display()
            
            if case l = tRect.origin.x {} else {
                moveCount += 1
            }
            tRect = NSRect()
        case (m,heightRange):
            if let lowestWidth = towerView.cTowers.last?.width {
                guard tRect.width < lowestWidth else {
                    reRect(tRect)
                    return
                }
            }
            towerView.cTowers.append(tRect)
            towerView.display()
            if case m = tRect.origin.x {} else {
                moveCount += 1
            }
            tRect = NSRect()
        case (r,heightRange):
            if let lowestWidth = towerView.rTowers.last?.width {
                guard tRect.width < lowestWidth else {
                    reRect(tRect)
                    return
                }
            }
            towerView.rTowers.append(tRect)
            towerView.display()
            if case r = tRect.origin.x {} else {
                moveCount += 1
            }
            tRect = NSRect()
        default:
            reRect(tRect)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard !tRect.isEmpty else {return}
        
        
        let mouseInTowerview = view.convert(event.locationInWindow, to: towerView)
        
        let x = mouseInTowerview.x
        let y = mouseInTowerview.y
        
        towerView.mouseRect = tRect
        towerView.mouseRect.origin.x = x-towerView.mouseRect.width/2
        towerView.mouseRect.origin.y = y-towerView.mouseRect.height/2
        towerView.display()
    }
    
    func reRect(_ rect: NSRect) {
        let x = rect.origin.x
        
        let viewWidth = towerView.bounds.width
        var l: ClosedRange<CGFloat>!
        var m: ClosedRange<CGFloat>!
        var r: ClosedRange<CGFloat>!
        for i in 1...3 {
            switch i {
            case 1:
                l = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            case 2:
                m = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            default:
                r = viewWidth*CGFloat(i)/3-viewWidth/3...viewWidth*CGFloat(i)/3
            }
        }
        
        switch x {
        case l:
            towerView.lTowers.append(rect)
            towerView.display()
            tRect = NSRect()
        case m:
            towerView.cTowers.append(rect)
            towerView.display()
            tRect = NSRect()
        case r:
            towerView.rTowers.append(rect)
            towerView.display()
            tRect = NSRect()
        default:
            break
        }
        
    }
    
}

