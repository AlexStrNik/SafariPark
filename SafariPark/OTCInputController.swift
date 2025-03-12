//
//  CaretInputController.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 08.03.2025.
//

import InputMethodKit
import SwiftUI

@objc(OTCInputController)
class OTCInputController: IMKInputController {
    private var otcWindow: OTCWindow?
    
    override init!(server: IMKServer!, delegate: Any!, client inputClient: Any!) {
        super.init(server: server, delegate: delegate, client: inputClient)
    }
    
    override func activateServer(_ sender: Any!) {
        super.activateServer(sender)
        
        OneTimeCodeProvider.shared.onCodeReceived = { [weak self] in
            self?.showPalette()
        }
        
        self.showPalette()
    }

    override func deactivateServer(_ sender: Any!) {
        self.hidePalette()

        super.deactivateServer(sender)
    }
}

extension OTCInputController {
    func showPalette() {
        if OneTimeCodeProvider.shared.oneTimeCode == nil {
            return
        }
        
        var cursorRect = NSMakeRect(0, 0, 0, 0);
        self.client().attributes(forCharacterIndex: 0, lineHeightRectangle: &cursorRect)

        otcWindow?.close()
        otcWindow = OTCWindow {
            DispatchQueue.main.async {
                self.hidePalette()
            }
        }
        otcWindow?.orderFront(nil)
        otcWindow?.setFrame(cursorRect, display: true)
        
        let anchorView = NSView()
        otcWindow?.contentView = anchorView
        anchorView.frame = otcWindow!.contentView!.bounds
        anchorView.autoresizingMask = [.width, .height]
        
        let popover = NSPopover()
        popover.contentViewController = NSHostingController(
            rootView: PanelView { code in
                self.client().insertText(code, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
                OneTimeCodeProvider.shared.consumeCurrentCode()
                self.hidePalette()
            } onContentResize: { [weak popover] contentSize in
                popover?.contentSize = contentSize
            }
        )
        popover.contentSize = NSSize(width: 200, height: 100)
        popover.behavior = .transient
        popover.show(relativeTo: anchorView.frame, of: anchorView, preferredEdge: .minY)
    }
    
    func hidePalette() {
        if let otcWindow = otcWindow {
            otcWindow.close()
            self.otcWindow = nil
        }
    }
}
