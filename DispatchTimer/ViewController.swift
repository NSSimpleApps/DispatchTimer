//
//  ViewController.swift
//  DispatchTimer
//
//  Created by NSSimpleApps on 04.07.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let label = UILabel()
    let timer = DispatchTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.label.textColor = .black
        self.label.text = "10"
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.label)
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(self.startTimer(_:))),
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTimer(_:)))
        ]
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Pause", style: .plain, target: self, action: #selector(self.pauseTimer(_:))),
            UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(self.resumeTimer(_:)))
        ]
        
        self.timer.block = { [weak self] (t: Int) -> Void in
            guard let self = self else { return }
            
            let text = String(t)
            
            DispatchQueue.main.async {
                self.label.text = text
            }
        }
        self.timer.completionBlock = { [weak self] (elapsedTime: Int) -> Void in
            guard let self = self else { return }
            
            let text = "Elapsed time: " + String(elapsedTime)
            
            DispatchQueue.main.async {
                self.label.text = text
            }
        }
    }
    
    @IBAction func startTimer(_ sender: UIBarButtonItem) {
        self.label.text = "10"
        self.timer.start(with: 10)
    }

    @IBAction func cancelTimer(_ sender: UIBarButtonItem) {
        _ = self.timer.stop()
    }
    
    @IBAction func pauseTimer(_ sender: UIBarButtonItem) {
        self.timer.pause()
    }
    
    @IBAction func resumeTimer(_ sender: UIBarButtonItem) {
        self.timer.resume()
    }
}

