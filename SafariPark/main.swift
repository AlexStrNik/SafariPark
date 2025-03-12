//
//  main.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 16.02.2025.
//

import Foundation
import AppKit

let app = SafariParkApplication.shared
let delegate = SafariParkAppDelegate()

app.delegate = delegate
app.setActivationPolicy(.accessory)

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
