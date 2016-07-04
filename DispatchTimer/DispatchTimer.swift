//
//  DispatchTimer.swift
//  DispatchTimer
//
//  Created by NSSimpleApps on 04.07.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

class DispatchTimer: NSObject {
    
    private let queue = dispatch_queue_create("ns.simple.apps", DISPATCH_QUEUE_SERIAL)
    
    private var timer: dispatch_source_t!
    
    private var isTicking = false
    
    private var counter = 0
    private var initialTime = 0
    
    var block: ((Int) -> Void)?
    var completionBlock: ((Int) -> Void)?
    
    func startWithInitialTime(initialTime: Int) {
        
        if self.isTicking { return }
        
        self.initialTime = initialTime
        self.counter = initialTime
        
        self.isTicking = true
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue)
        
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)),
                                  1 * NSEC_PER_SEC, (1 * NSEC_PER_SEC) / 10)
        
        dispatch_source_set_event_handler(self.timer) { [weak self] () -> Void in
            
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
        
        dispatch_resume(self.timer)
    }
    
    func pause() {
        
        if self.isTicking {
            
            dispatch_suspend(self.timer)
            
            self.isTicking = false
        }
    }
    
    func resume() {
        
        if !self.isTicking && self.timer != nil {
            
            dispatch_resume(self.timer)
            
            self.isTicking = true
        }
    }
    
    func stop() -> Int {
        
        if self.isTicking {
            
            dispatch_source_cancel(self.timer)
            self.timer = nil
            
            self.isTicking = false
            
            return self.initialTime - self.counter
        }
        return 0
    }
}
