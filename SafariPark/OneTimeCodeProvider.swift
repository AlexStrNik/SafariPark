//
//  OneTimeCodeProvider.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 16.02.2025.
//

class OneTimeCodeProvider: ObservableObject {
    struct OneTimeCode {
        var code: String
        var domain: String?
        var source: OneTimeCodeSource
    }
    
    enum OneTimeCodeSource: Int64 {
        case messages = 0
        case mail = 1
        case unknown = 2
    }
    
    @objc class SFAppAutoFillOneTimeCodeObserver: NSObject {
        let onCodeReceived: (OneTimeCode) -> Void
        
        init(onCodeReceived: @escaping (OneTimeCode) -> Void) {
            self.onCodeReceived = onCodeReceived
        }
        
        @objc func appAutoFillOneTimeCodeProviderReceivedOneTimeCode(_ provider: SFAppAutoFillOneTimeCodeProvider) {
            if let code = provider._mostRecentlyReceivedOneTimeCode() as? SFAutoFillOneTimeCode {
                onCodeReceived(
                    OneTimeCode(
                        code: code.code,
                        domain: code.domain,
                        source: OneTimeCodeSource(rawValue: code.source) ?? .unknown
                    )
                )
            }
        }
    }
    
    @Published var oneTimeCode: OneTimeCode?
    
    private var provider: SFAppAutoFillOneTimeCodeProvider?
    private var observer: SFAppAutoFillOneTimeCodeObserver?
    
    public var onCodeReceived: (() -> Void)?
    
    private init() {
        self.provider = SFAppAutoFillOneTimeCodeProvider()
        self.observer = SFAppAutoFillOneTimeCodeObserver { code in
            DispatchQueue.main.async {
                self.oneTimeCode = code
                self.onCodeReceived?()
            }
        }
        
        self.provider?.setDelegate(self.observer)
        self.provider?.addObserver(observer)
        self.observer?.appAutoFillOneTimeCodeProviderReceivedOneTimeCode(self.provider!)
    }
    
    public func didFocusOneTimeCodeField() {
        self.provider?.didFocusOneTimeCodeField()
    }
    
    public func consumeCurrentCode() {
        self.provider?.consumeCurrentOneTimeCode()
        self.oneTimeCode = nil
    }
    
    static let shared = OneTimeCodeProvider()
}
