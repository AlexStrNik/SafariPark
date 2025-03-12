//
//  PanelView.swift
//  SafariPark
//
//  Created by Aleksandr Strizhnev on 16.02.2025.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct PanelView: View {
    var onCodeSelected: (String) -> Void
    var onContentResize: (CGSize) -> Void

    @ObservedObject var otcProvider: OneTimeCodeProvider = .shared
    
    var body: some View {
        Group {
            if let code = otcProvider.oneTimeCode {
                Button(action: {
                    self.onCodeSelected(code.code)
                }) {
                    CodeView(code: code)
                }
                .buttonStyle(.plain)
            } else {
                Text("Loading...")
            }
        }
        .padding(10)
        .fixedSize()
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
                    .onPreferenceChange(SizePreferenceKey.self) { size in
                        // Debounce the size change to avoid rapid updates
                        DispatchQueue.main.async {
                            onContentResize(size)
                        }
                    }
            }
        )
    }
}

extension OneTimeCodeProvider.OneTimeCode {
    var iconName: String {
        switch self.source {
        case .mail:
            return "envelope.fill"
        case .messages:
            return "message.fill"
        default:
            return "key.fill"
        }
    }
    
    var sourceName: String {
        switch self.source {
        case .mail:
            return "Mail"
        case .messages:
            return "Messages"
        default:
            return "Other"
        }
    }
}

struct CodeView: View {
    var code: OneTimeCodeProvider.OneTimeCode
    
    @State private var hovered: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: code.iconName)
                .foregroundColor(.primary)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Fill code **\(code.code)**")
                    .font(.callout)
                
                Text("From **\(code.sourceName)**")
                    .font(.subheadline)
            }
        }
        .padding(7)
        .background(
            hovered ? Color.accentColor : .clear
        )
        .onHover {
            hovered = $0
        }
        .clipShape(
            RoundedRectangle(
                cornerSize: CGSize(width: 5, height: 5)
            )
        )
    }
}

#Preview {
    CodeView(
        code: .init(
            code: "12345",
            source: .mail
        )
    )
    
    CodeView(
        code: .init(
            code: "12345",
            source: .messages
        )
    )
}
