//
//  ViewController.swift
//  GameTimer
//
//  Created by Yuval Gat on 22/12/2017.
//  Copyright © 2017 Yuval Gat. All rights reserved.
//

import UIKit
import AVFoundation

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
        inputOutlet.attributedPlaceholder = NSAttributedString(
            string: "Enter number of seconds",
            attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        var totalTime: Int
        
        // Default time 600s
        if (inputOutlet.text != "" && (Int(inputOutlet.text!) != nil)) {
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
            blackLabel.alpha = 0.1
        } else {
            runBlackTimer()
            whiteLabel.alpha = 0.1
        }
    }
    
    @IBAction func blackPlayerButton(_ sender: UIButton) {
        if blackTimer.isValid {
            blackTimer.invalidate()
            blackLabel.alpha = 0.5
            whiteLabel.alpha = 1
            runWhiteTimer()
        }
    }
    
    @IBAction func whitePlayerButton(_ sender: UIButton) {
        if whiteTimer.isValid {
            whiteTimer.invalidate()
            whiteLabel.alpha = 0.5
            blackLabel.alpha = 1
            runBlackTimer()
        }
    }
    
    func runBlackTimer() {
        blackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateBlackTimer)), userInfo: nil, repeats: true)
    }
    
    func runWhiteTimer() {
        whiteTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateWhiteTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateBlackTimer() {
        blackSeconds -= 1
        blackLabel.text = formatTime(time: blackSeconds)
        if blackSeconds == 0 {
            blackTimer.invalidate()
            alert(title: "Black lost!", text: "Black has lost the game.")
        }
    }
    
    @objc func updateWhiteTimer() {
        whiteSeconds -= 1
        whiteLabel.text = formatTime(time: whiteSeconds)
        if whiteSeconds == 0 {
            whiteTimer.invalidate()
            alert(title: "White lost!", text: "White has lost the game.")
        }
    }
    
    func formatTime(time: Int) -> String {
        let min: Int = time / 60
        let sec: Int = time % 60
        
        var minStr: String = "\(min)"
        var secStr: String = "\(sec)"
        
        if (min < 10) {
            minStr = "0" + minStr
        }
        if (sec < 10) {
            secStr = "0" + secStr
        }

        return minStr + ":" + secStr
    }
    
    func alert(title: String, text: String) {
        let msg = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let resetButton = UIAlertAction(title: "Reset", style: .default) {
            UIAlertAction in
            self.resetGame()
        }
        msg.addAction(resetButton)
        self.present(msg, animated: true, completion: nil)
        
        AudioServicesPlaySystemSound(4095) // Vibrate
        AudioServicesPlaySystemSound(1022) // Play sound
    }
    
    func resetGame() {
        startGameButton.isHidden = false
        inputOutlet.isHidden = false
        whiteOrBlack.isHidden = false
        
        blackLabel.text = "00:00"
        whiteLabel.text = "00:00"
        
        blackLabel.alpha = 1
        whiteLabel.alpha = 1
    }
}
