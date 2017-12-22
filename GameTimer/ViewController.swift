//
//  ViewController.swift
//  GameTimer
//
//  Created by Yuval Gat on 22/12/2017.
//  Copyright © 2017 Yuval Gat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    
    let totalTime: Int = 5
    
    var blackSeconds: Int = 0
    var whiteSeconds: Int = 0
    
    var blackTimer: Timer = Timer()
    var whiteTimer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        blackSeconds = totalTime
        whiteSeconds = totalTime
        blackLabel.text = formatTime(time: blackSeconds)
        whiteLabel.text = formatTime(time: whiteSeconds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        sender.isHidden = true
        runWhiteTimer()
    }
    
    @IBAction func blackPlayerButton(_ sender: UIButton) {
        if blackTimer.isValid {
            blackTimer.invalidate()
            runWhiteTimer()
        }
    }
    
    @IBAction func whitePlayerButton(_ sender: UIButton) {
        if whiteTimer.isValid {
            whiteTimer.invalidate()
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
        let f: String = formatTime(time: blackSeconds)
        blackLabel.text = f
        if f == "0:0" {
            blackTimer.invalidate()
            let msg = UIAlertController(title: "Black lost!", message: "Black has lost the game.", preferredStyle: .alert)
            self.present(msg, animated: true, completion: nil)
        }
    }
    
    @objc func updateWhiteTimer() {
        whiteSeconds -= 1
        let f: String = formatTime(time: whiteSeconds)
        whiteLabel.text = f
        if f == "0:0" {
            whiteTimer.invalidate()
            let msg = UIAlertController(title: "White lost!", message: "White has lost the game.", preferredStyle: .alert)
            self.present(msg, animated: true, completion: nil)
        }
    }
    
    func formatTime(time: Int) -> String {
        let min: Int = Int(floor(Double(time / 60)))
        let sec: Int = time - (min * 60)
        
        return "\(min):\(sec)"
    }
}

