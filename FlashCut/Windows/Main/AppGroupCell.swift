//
//  AppGroupCell.swift
//
//  Created by Wojciech Kulik on 20/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct AppGroupCell: View {
    @State var isTargeted = false
    @Binding var isEditing: Bool
    @State var editedName: String?
    @FocusState private var isTextFieldFocused: Bool
    @Binding var selectedApps: Set<MacApp>
    @Binding var appGroup: AppGroup

    let appGroupManager: AppGroupManager = AppDependencies.shared.appGroupManager
    let appGroupRepository: AppGroupRepository = AppDependencies.shared.appGroupRepository

    var body: some View {
        Group {
            if isEditing {
                editingName
            } else {
                staticName
            }
        }
        .contentShape(Rectangle())
        .dropDestination(
            for: MacAppWithAppGroup.self,
            action: handleDrop,
            isTargeted: { isTargeted = $0 }
        )
    }

    private var editingName: some View {
        let textBinding = Binding(
            get: { editedName ?? appGroup.name }, // set the default value
            set: { editedName = $0 }
        )
        return TextField("Name", text: textBinding)
            .textFieldStyle(.plain)
            .focused($isTextFieldFocused)
            .task {
                isTextFieldFocused = true
            }
            .onSubmit {
                isEditing = false
                guard let newName = editedName else { return }
                editedName = nil

                let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                let finalName = trimmedName.isEmpty ? "(empty)" : trimmedName
                guard finalName != appGroup.name else { return }

                appGroup.name = finalName
                appGroupRepository.updateAppGroup(appGroup)
            }
            .onExitCommand {
                isEditing = false
                editedName = nil
            }
    }

    private var staticName: some View {
        Text(appGroup.name)
            .lineLimit(1)
            .frame(alignment: .leading)
            .foregroundColor(
                isTargeted || appGroup.apps.contains(where: \.bundleIdentifier.isEmpty)
                    ? .errorRed
                    : .primary
            )
    }

    private func handleDrop(_ apps: [MacAppWithAppGroup], _ _: CGPoint) -> Bool {
        guard let sourceAppGroupId = apps.first?.appGroupId else { return false }

        appGroupRepository.moveApps(
            apps.map(\.app),
            from: sourceAppGroupId,
            to: appGroup.id
        )
        selectedApps = []

        appGroupManager.activateAppGroupIfActive(sourceAppGroupId)
        appGroupManager.activateAppGroupIfActive(appGroup.id)

        return true
    }
}
