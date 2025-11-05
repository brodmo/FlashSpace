//
//  AcknowledgementsSettingsView.swift
//
//  Created by Wojciech Kulik on 26/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI

struct AcknowledgementsSettingsView: View {
    @State private var selectedDependency: String? = "Kentzo/ShortcutRecorder"
    @State private var dependencies = [
        "Kentzo/ShortcutRecorder",
        "LebJe/TOMLKit",
        "sparkle-project/Sparkle",
        "apple/swift-argument-parser",
        "SwiftFormat",
        "SwiftLint"
    ]

    var body: some View {
        VStack(spacing: 0.0) {
            List(
                dependencies,
                id: \.self,
                selection: $selectedDependency
            ) { dependency in
                Text(dependency)
            }
            .frame(height: 130)
            .tahoeBorder()
            .padding(.horizontal, { if #available(macOS 26.0, *) { 8 } else { 0 } }())

            ScrollView([.vertical, .horizontal]) {
                VStack {
                    Group {
                        switch selectedDependency {
                        case "Kentzo/ShortcutRecorder":
                            Text(Licenses.shortcutRecorder)
                        case "LebJe/TOMLKit":
                            Text(Licenses.tomlKit)
                        case "sparkle-project/Sparkle":
                            Text(Licenses.sparkle)
                        case "apple/swift-argument-parser":
                            Text(Licenses.swiftArgumentParser)
                        case "SwiftFormat":
                            Text(Licenses.swiftFormat)
                        case "SwiftLint":
                            Text(Licenses.swiftLint)
                        default:
                            EmptyView()
                        }
                    }
                    .frame(minHeight: 330, alignment: .top)
                    .textSelection(.enabled)
                    .padding()
                }
            }
        }
        .navigationTitle("Acknowledgements")
    }
}
