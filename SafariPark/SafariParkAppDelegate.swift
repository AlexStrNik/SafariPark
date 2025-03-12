//
//  SafariParkAppDelegate.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 16.02.2025.
//

import AppKit
import SwiftUI
import ApplicationServices

class SafariParkAppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        OneTimeCodeProvider.shared.didFocusOneTimeCodeField()
        
        TISController.shared.setup()
        TISController.shared.activate()
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let statusButton = statusBarItem.button
        statusButton!.image = NSImage(systemSymbolName: "key.viewfinder", accessibilityDescription: "SafariPark")
        
        let quit = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "")
        let restart = NSMenuItem(title: "Restart", action: #selector(restartApp), keyEquivalent: "")
        
        let statusMenu = NSMenu()
        statusMenu.addItem(quit)
        statusMenu.addItem(restart)
        
        statusBarItem.menu = statusMenu
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc func restartApp() {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "relaunch", ofType: nil)!
        task.arguments = [String(ProcessInfo.processInfo.processIdentifier)]
        task.launch()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        TISController.shared.deactivate()
    }
}
