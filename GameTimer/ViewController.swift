//
//  ViewController.swift
//  GameTimer
//
//  Created by Yuval Gat on 22/12/2017.
//  Copyright © 2017 Yuval Gat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputOutlet: UITextField!
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    
    @IBOutlet weak var whiteOrBlack: UISegmentedControl!
    
    var blackSeconds: Int = 0
    var whiteSeconds: Int = 0
    
    var blackTimer: Timer = Timer()
    var whiteTimer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        blackLabel.text = formatTime(time: blackSeconds)
        whiteLabel.text = formatTime(time: whiteSeconds)
        inputOutlet.attributedPlaceholder = NSAttributedString(string: "Enter number of seconds",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(_ sender: UIButton) -> Void {
        var totalTime: Int
        
        // Default time 600s
        if (inputOutlet.text != "") {
            totalTime = Int(inputOutlet.text!)!
        } else {
            totalTime = 600
        }
        
        // Update times and labels
        blackSeconds = totalTime
        whiteSeconds = totalTime
        
        blackLabel.text = formatTime(time: blackSeconds)
        whiteLabel.text = formatTime(time: whiteSeconds)
        
        // Hide UI elements and keyboard
        startGameButton.isHidden = true
        inputOutlet.isHidden = true
        whiteOrBlack.isHidden = true
        self.view.endEditing(true)
        
        if whiteOrBlack.selectedSegmentIndex == 0 {
            runWhiteTimer()
        } else {
            runBlackTimer()
        }
    }
    
    @IBAction func blackPlayerButton(_ sender: UIButton) -> Void {
        if blackTimer.isValid {
            blackTimer.invalidate()
            runWhiteTimer()
        }
    }
    
    @IBAction func whitePlayerButton(_ sender: UIButton) -> Void {
        if whiteTimer.isValid {
            whiteTimer.invalidate()
            runBlackTimer()
        }
    }
    
    func runBlackTimer() -> Void {
        blackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateBlackTimer)), userInfo: nil, repeats: true)
    }
    
    func runWhiteTimer() -> Void {
        whiteTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateWhiteTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateBlackTimer() -> Void {
        blackSeconds -= 1
        let f: String = formatTime(time: blackSeconds)
        blackLabel.text = f
        if f == "0:0" {
            blackTimer.invalidate()
            alert(title: "Black lost!", msg: "Black has lost the game.")
        }
    }
    
    @objc func updateWhiteTimer() -> Void {
        whiteSeconds -= 1
        let f: String = formatTime(time: whiteSeconds)
        whiteLabel.text = f
        if f == "0:0" {
            whiteTimer.invalidate()
            alert(title: "White lost!", msg: "White has lost the game.")
        }
    }
    
    func formatTime(time: Int) -> String {
        let min: Int = Int(floor(Double(time / 60)))
        let sec: Int = time - (min * 60)
        
        return "\(min):\(sec)"
    }
    
    func alert(title: String, msg: String) -> Void {
        let msg = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let resetButton = UIAlertAction(title: "Reset", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.resetGame()
        }
        
        msg.addAction(resetButton)
        self.present(msg, animated: true, completion: nil)
    }
    
    func resetGame() -> Void {
        startGameButton.isHidden = false
        inputOutlet.isHidden = false
        whiteOrBlack.isHidden = false
        
        blackLabel.text = "0:0"
        whiteLabel.text = "0:0"
    }
}
