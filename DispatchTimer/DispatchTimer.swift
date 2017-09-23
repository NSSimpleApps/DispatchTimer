//
//  DispatchTimer.swift
//  DispatchTimer
//
//  Created by NSSimpleApps on 04.07.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

class DispatchTimer {
    
    fileprivate let queue = DispatchQueue(label: "ns.simple.apps")
    
    fileprivate var timer: DispatchSourceTimer!
    
    fileprivate var isTicking = false
    
    fileprivate var counter = 0
    fileprivate var initialTime = 0
    
    var block: ((Int) -> Void)?
    var completionBlock: ((Int) -> Void)?
    
    func start(with initialTime: Int) {
        
        if self.isTicking { return }
        
        self.initialTime = initialTime
        self.counter = initialTime
        
        self.isTicking = true
        
        self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: self.queue)
        self.timer.schedule(deadline: DispatchTime(uptimeNanoseconds: UInt64(initialTime) * NSEC_PER_SEC), repeating: Double(1), leeway: .milliseconds(1))
        //self.timer.scheduleRepeating(deadline: DispatchTime(uptimeNanoseconds: UInt64(initialTime) * NSEC_PER_SEC),
                                     //interval: Double(1))
        self.timer.setEventHandler { [weak self] () -> Void in
            
            if let strongSelf = self {
                
                if strongSelf.counter == 0 {
                    
                    let elapsedTime = strongSelf.stop()
                    
                    strongSelf.completionBlock?(elapsedTime)
                    
                } else {
                    
                    strongSelf.counter -= 1
                    
                    let elapsedTime = strongSelf.counter//strongSelf.initialTime - strongSelf.counter
                    
                    strongSelf.block?(elapsedTime)
                }
            }
        }
        
        self.timer.activate()
    }
    
    func pause() {
        
        if self.isTicking {
            
            self.timer.suspend()
            
            self.isTicking = false
        }
    }
    
    func resume() {
        
        if !self.isTicking && self.timer != nil {
            
            self.timer.resume()
            
            self.isTicking = true
        }
    }
    
    func stop() -> Int {
        
        if self.isTicking {
            
            self.timer.cancel()
            self.timer = nil
            
            self.isTicking = false
            
            return self.initialTime - self.counter
        }
        return 0
    }
}
