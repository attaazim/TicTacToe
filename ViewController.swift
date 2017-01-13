//
//  ViewController.swift
//  Swift-Tac-Toe
//
//  Created by Attaullah Azim on 20/07/2016.
//  Copyright © 2016 Attaullah Azim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var ticTacImg1: UIImageView! = nil
    @IBOutlet var ticTacImg2: UIImageView! = nil
    @IBOutlet var ticTacImg3: UIImageView! = nil
    @IBOutlet var ticTacImg4: UIImageView! = nil
    @IBOutlet var ticTacImg5: UIImageView! = nil
    @IBOutlet var ticTacImg6: UIImageView! = nil
    @IBOutlet var ticTacImg7: UIImageView! = nil
    @IBOutlet var ticTacImg8: UIImageView! = nil
    @IBOutlet var ticTacImg9: UIImageView! = nil

    @IBOutlet var ticTacBtn1: UIButton! = nil
    @IBOutlet var ticTacBtn2: UIButton! = nil
    @IBOutlet var ticTacBtn3: UIButton! = nil
    @IBOutlet var ticTacBtn4: UIButton! = nil
    @IBOutlet var ticTacBtn5: UIButton! = nil
    @IBOutlet var ticTacBtn6: UIButton! = nil
    @IBOutlet var ticTacBtn7: UIButton! = nil
    @IBOutlet var ticTacBtn8: UIButton! = nil
    @IBOutlet var ticTacBtn9: UIButton! = nil
    
    @IBOutlet var resetBtn: UIButton! = nil
    
    @IBOutlet var userMsg: UILabel! = nil
    
    var plays = Dictionary<Int, Int> ()
    var done = false
    var aiDeciding = false
    
    var timer = NSTimer()
    var countDown = 1
    
    @IBAction func UIButtonClicked(sender: UIButton) {
        userMsg.hidden = true
        if ((plays[sender.tag]) == nil) && !(aiDeciding) && !(done) {
            setImageForSpot(sender.tag, player:1)
        }
        checkForWin()
        delay()
        //aiTurn()
    }
    
    func setImageForSpot(spot: Int, player: Int) {
        var playerMark = player == 1 ? "x" : "o"
        plays[spot] = player
        switch spot {
        case 1:
            ticTacImg1.image = UIImage(named: playerMark)
        case 2:
            ticTacImg2.image = UIImage(named: playerMark)
        case 3:
            ticTacImg3.image = UIImage(named: playerMark)
        case 4:
            ticTacImg4.image = UIImage(named: playerMark)
        case 5:
            ticTacImg5.image = UIImage(named: playerMark)
        case 6:
            ticTacImg6.image = UIImage(named: playerMark)
        case 7:
            ticTacImg7.image = UIImage(named: playerMark)
        case 8:
            ticTacImg8.image = UIImage(named: playerMark)
        case 9:
            ticTacImg9.image = UIImage(named: playerMark)
        default:
            ticTacImg5.image = UIImage(named: playerMark)
        }
    }
    
    @IBAction func resetBtnClicked(sender: UIButton) {
        done = false
        resetBtn.hidden = true
        userMsg.hidden = true
        reset()
    }
    
    func reset() {
        plays = [:]
        ticTacImg1.image = nil
        ticTacImg2.image = nil
        ticTacImg3.image = nil
        ticTacImg4.image = nil
        ticTacImg5.image = nil
        ticTacImg6.image = nil
        ticTacImg7.image = nil
        ticTacImg8.image = nil
        ticTacImg9.image = nil
        
    }
    
    func checkForWin() {
        var whoWon = ["I": 0, "you": 1]
        for(key, value) in whoWon {
            if((plays[7] == value && plays[8] == value && plays[9] == value) || //across the bottom
                (plays[4] == value && plays[5] == value && plays[6] == value) || //across middle
                (plays[1] == value && plays[2] == value && plays[3] == value) || // across top
                (plays[1] == value && plays[4] == value && plays[7] == value) || //down left side
                (plays[3] == value && plays[6] == value && plays[9] == value) || //down right side
                (plays[2] == value && plays[5] == value && plays[8] == value) || // down the middle
                (plays[1] == value && plays[5] == value && plays[9] == value) || //diag left right
                (plays[3] == value && plays[5] == value && plays[7] == value)) { //diag right left
                
                userMsg.hidden = false;
                userMsg.text = "Looks like \(key) won!"
                resetBtn.hidden = false
                done = true
            }
        }
    }
    
    func checkBottom(value: Int) -> (location: String, pattern: String) {
        return ("bottom", checkFor(value, inList: [7, 8, 9]))
    }
    func checkMiddleAcross(value: Int) -> (location: String, pattern: String) {
        return ("middleHorz", checkFor(value, inList: [4, 5, 6]))
    }
    func checkTop(value: Int) -> (location: String, pattern: String) {
        return ("top", checkFor(value, inList: [1, 2, 3]))
    }
    func checkLeft(value: Int) -> (location: String, pattern: String) {
        return ("left", checkFor(value, inList: [1, 4, 7]))
    }
    func checkMiddleDown(value: Int) -> (location: String, pattern: String) {
        return ("middleVert", checkFor(value, inList: [2, 5, 8]))
    }
    func checkRight(value: Int) -> (location: String, pattern: String) {
        return ("right", checkFor(value, inList: [3, 6, 9]))
    }
    func checkDiagLeftRight(value: Int) -> (location: String, pattern: String) {
        return ("diagLeftRight", checkFor(value, inList: [3, 5, 7]))
    }
    func checkDiagRightLeft(value: Int) -> (location: String, pattern: String) {
        return ("diagRightLeft", checkFor(value, inList: [1, 5, 9]))
    }
    
    func checkFor(value: Int, inList: [Int]) -> String {
        var conclusion = ""
        for cell in inList {
            if plays[cell] == value {
                conclusion += "1"
            }
            else {
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    func rowCheck(value: Int) -> (location: String, pattern: String)? {
        var acceptableFinds = ["011", "110", "101"]
        var findFuncs = [checkTop, checkBottom, checkRight, checkLeft, checkMiddleAcross, checkMiddleDown, checkDiagLeftRight, checkDiagRightLeft]
        for algorithm in findFuncs {
            var algorithmResults = algorithm(value)
            var findPattern = acceptableFinds.indexOf(algorithmResults.pattern)
            if ((findPattern) != nil) {
                return algorithmResults
            }
        }
        return nil
    }
    
    func isOccupied(spot: Int) -> Bool {
        if plays[spot] != nil {
            return true
        }
        return false
    }
    
    func delay() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        
    }
    
    func aiTurn() {
        if done {
            return
        }
        
        aiDeciding = true
        
        
        // We(computer) have two in a row
        if let result = rowCheck(0) {
            var whereToPlayResult = whereToPlay(result.location, pattern:result.pattern)
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        
        // is center available?
        if !isOccupied(5) {
            setImageForSpot(5, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        func firstAvailable(isCorner: Bool) -> Int? {
            var spots = isCorner ? [1, 3, 7, 9] : [2, 4, 6, 8]
            for spot in spots {
                if !isOccupied(spot) {
                    return spot
                }
            }
            return nil
        }
        
        // is a corner available?
        if let cornerAvailable = firstAvailable(true) {
            setImageForSpot(cornerAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        // is a side available?
        if let sideAvailable = firstAvailable(false) {
            setImageForSpot(sideAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        userMsg.hidden = false
        userMsg.text = "Looks like it was a tie!"
        
        reset()
        
        aiDeciding = false
    }
    
    func updateTimer() {
        if countDown > 0 {
            countDown--
        }
        else {
            countDown = 1
            timer.invalidate()
            aiTurn()
        }
    }
    
    func whereToPlay(location: String, pattern: String) -> Int {
        var leftPattern = "011"
        var rightPattern = "110"
        var middlePattern = "101"
        
        switch location {
            case "top":
                if pattern == leftPattern {
                    return 1
                }
                else if pattern == rightPattern {
                    return 3
                }
                else {
                    return 2
                }
            case "bottom":
                if pattern == leftPattern {
                    return 7
                }
                else if pattern == rightPattern {
                    return 9
                }
                else {
                    return 8
                }
            case "left":
                if pattern == leftPattern {
                    return 1
                }
                else if pattern == rightPattern {
                    return 7
                }
                else {
                    return 4
                }
            case "right":
                if pattern == leftPattern {
                    return 3
                }
                else if pattern == rightPattern {
                    return 9
                }
                else {
                    return 6
                }
            case "middleVert":
                if pattern == leftPattern {
                    return 2
                }
                else if pattern == rightPattern {
                    return 8
                }
                else {
                    return 5
                }
            case "middleHorz":
                if pattern == leftPattern {
                    return 4
                }
                else if pattern == rightPattern {
                    return 6
                }
                else {
                    return 5
                }
            case "diagRightLeft":
                if pattern == leftPattern {
                    return 3
                }
                else if pattern == rightPattern {
                    return 7
                }
                else {
                    return 5
                }
            case "diagLeftRight":
                if pattern == leftPattern {
                    return 1
                }
                else if pattern == rightPattern {
                    return 9
                }
                else {
                    return 5
                }
            default:
                return 4
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

