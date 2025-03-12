//
//  OTCWindow.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 16.02.2025.
//

import AppKit
import CoreGraphics

class OTCWindow: NSPanel {
    var onClosed: (() -> Void)?
    private var globalMouseMonitor: Any?
    
    public convenience init(onClosed: @escaping () -> Void) {
        self.init(
            contentRect: .init(x: 0, y: 0, width: 200, height: 100),
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        self.onClosed = onClosed
        
        self.isMovable = false
        self.level = .floating
        self.hidesOnDeactivate = false
        self.isFloatingPanel = true
        self.becomesKeyOnlyIfNeeded = false
        self.worksWhenModal = true
        self.collectionBehavior = [.moveToActiveSpace, .fullScreenAuxiliary]
        
        self.backgroundColor = .clear
        self.isOpaque = false

        if globalMouseMonitor == nil {
            globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
                self?.close()
            }
        }
    }
    
    override func close() {
        self.onClosed?()

        if let monitor = globalMouseMonitor {
            NSEvent.removeMonitor(monitor)
            globalMouseMonitor = nil
        }
        
        super.close()
    }
    
    open override var canBecomeKey: Bool {
        return false
    }
     
    open override var canBecomeMain: Bool {
        return false
    }
}
