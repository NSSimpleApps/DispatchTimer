//
//  ViewController.swift
//  DispatchTimer
//
//  Created by NSSimpleApps on 04.07.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var timer = DispatchTimer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.label.text = "10"
        
        self.timer.block = { [weak self] (t: Int) -> Void in
            
            if let strongSelf = self {
                
                let text = String(t)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    strongSelf.label.text = text
                })
            }
        }
        
        self.timer.completionBlock = { [weak self] (elapsedTime: Int) -> Void in
            
            if let strongSelf = self {
                
                let text = "Elapsed time: " + String(elapsedTime)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    strongSelf.label.text = text
                })
            }
        }
    }

    
    @IBAction func startTimer(sender: UIBarButtonItem) {
        
        self.label.text = "10"
        
        self.timer.startWithInitialTime(10)
    }

    @IBAction func cancelTimer(sender: UIBarButtonItem) {
        
        self.timer.stop()
    }
    
    @IBAction func pauseTimer(sender: UIBarButtonItem) {
        
        self.timer.pause()
    }
    
    @IBAction func resumeTimer(sender: UIBarButtonItem) {
        
        self.timer.resume()
    }
}

