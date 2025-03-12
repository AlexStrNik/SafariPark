//
//  main.swift
//  relaunch
//
//  Created by Aleksandr Strizhnev on 12.03.2025.
//

import AppKit

class Observer: NSObject {

    let _callback: () -> Void

    init(callback: @escaping () -> Void) {
        _callback = callback
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        _callback()
    }
}


autoreleasepool {
    guard let parentPID = Int32(CommandLine.arguments[1]) else {
        fatalError("Relaunch: parentPID == nil.")
    }

    if let app = NSRunningApplication(processIdentifier: parentPID) {

        let bundleURL = app.bundleURL!

        let listener = Observer { CFRunLoopStop(CFRunLoopGetCurrent()) }
        app.addObserver(listener, forKeyPath: "isTerminated", context: nil)
        app.terminate()
        CFRunLoopRun()
        app.removeObserver(listener, forKeyPath: "isTerminated", context: nil)

        do {
            try NSWorkspace.shared.open(bundleURL)
        } catch {
            fatalError("Relaunch: NSWorkspace.shared().launchApplication failed.")
        }
    }
}
