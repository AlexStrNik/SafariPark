//
//  TISController.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 08.03.2025.
//

import InputMethodKit

extension TISInputSource {
    func propertyValue<T>(forKey key: CFString) -> T? {
        guard let value = TISGetInputSourceProperty(self, key) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(value).takeUnretainedValue() as? T
    }
    
    func enable() {
        let isEnableCapable: Bool = propertyValue(forKey: kTISPropertyInputSourceIsEnableCapable) ?? false
        print("TISPropertyInputSourceIsEnableCapable: \(isEnableCapable)")
        
        if isEnableCapable {
            let status = TISEnableInputSource(self)
            print("TISEnableInputSource success: \(status == noErr)")
        }
    }
    
    func deselect() {
        let status = TISDeselectInputSource(self)
        print("TISDeselectInputSource success: \(status == noErr)")
    }
    
    func select() {
        let isSelectCapable: Bool = propertyValue(forKey: kTISPropertyInputSourceIsSelectCapable) ?? false
        print("TISPropertyInputSourceIsSelectCapable: \(isSelectCapable)")
        
        if isSelectCapable {
            let status = TISSelectInputSource(self)
            print("TISSelectInputSource success: \(status == noErr)")
        }
    }
}

class TISController: NSObject {
    let imkServer: IMKServer
    var inputSource: TISInputSource?
    
    override private init() {
        imkServer = IMKServer(
            name: "xyz.alexstrnik.SafariPark.IMKConnection",
            bundleIdentifier: Bundle.main.bundleIdentifier
        )
    }
    
    func setup() {
        if let appLocation = CFURLCreateWithString(kCFAllocatorDefault, Bundle.main.bundleURL.path() as CFString, nil) {
            let status = TISRegisterInputSource(appLocation)
            print("TISRegisterInputSource success: \(status == noErr)")
        }
        
        let properties = [kTISPropertyInputSourceID as String: "xyz.alexstrnik.SafariPark"]
        let sourceList = TISCreateInputSourceList(properties as CFDictionary, true)?.takeUnretainedValue() as? NSArray as? [TISInputSource] ?? []
        
        self.inputSource = sourceList[0]
        
        let isEnabled = self.inputSource!.propertyValue(forKey: kTISPropertyInputSourceIsEnabled) ?? false
        if !isEnabled {
            self.inputSource!.enable()
        }
        
        self.inputSource!.select()
    }
    
    func activate() {
        self.inputSource?.select()
    }
    
    func deactivate() {
        self.inputSource?.deselect()
    }
    
    static let shared = TISController()
}
