import AppKit
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @Environment(\.openWindow) var openWindow
    @State private var selectedAppGroupIds: Set<UUID> = []
    @State private var selectedApps: Set<MacApp> = []
    @State private var editingAppGroupId: UUID?

    private var currentAppGroupId: UUID? {
        guard selectedAppGroupIds.count == 1, let id = selectedAppGroupIds.first else { return nil }
        return id
    }

    private var currentApps: [MacApp] {
        viewModel.getSelectedAppGroup(id: currentAppGroupId)?.apps ?? []
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            appGroups
            rightPanel
        }
        .padding()
        .frame(minWidth: 450, minHeight: 350)
    }

    private var rightPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            if currentAppGroupId != nil {
                AppGroupConfigurationView(
                    viewModel: viewModel,
                    apps: currentApps
                )
                .padding(.bottom, 12)
                assignedApps
            } else {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        openWindow(id: "settings")
                    }, label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }).keyboardShortcut(",")
                }
            }
        }
        .frame(width: 200)
    }

    private var appGroups: some View {
        VStack(alignment: .leading) {
            List(selection: $selectedAppGroupIds) {
                ForEach($viewModel.appGroups) { $appGroup in
                    AppGroupCell(
                        viewModel: viewModel,
                        appGroup: $appGroup,
                        isCurrent: currentAppGroupId == appGroup.id,
                        editingAppGroupId: $editingAppGroupId
                    )
                    .tag(appGroup.id)
                }
                .onMove { from, to in
                    viewModel.appGroups.move(fromOffsets: from, toOffset: to)
                }
            }
            .onChange(of: selectedAppGroupIds) { oldIds, newIds in
                // Clear app selection when group selection changes
                if newIds.count != 1 {
                    selectedApps = []
                }

                // Load form fields when a single group is selected
                if newIds.count == 1, let selectedId = newIds.first, selectedId != oldIds.first {
                    selectedApps = []
                    viewModel.loadSelectedAppGroup(id: selectedId)
                }
            }
            .tahoeBorder()

            HStack {
                Button(action: {
                    if let newId = viewModel.addAppGroup() {
                        selectedAppGroupIds = [newId]
                        editingAppGroupId = newId
                    }
                }, label: {
                    Image(systemName: "plus")
                        .frame(height: 16)
                })

                Button(action: {
                    viewModel.deleteAppGroups(ids: selectedAppGroupIds)
                    selectedAppGroupIds = []
                }, label: {
                    Image(systemName: "trash")
                        .frame(height: 16)
                })
                .disabled(selectedAppGroupIds.isEmpty)

                Spacer()
            }
        }
        .frame(width: 200)
    }

    private var assignedApps: some View {
        VStack(alignment: .leading) {
            List(
                currentApps,
                id: \.self,
                selection: $selectedApps
            ) { app in
                AppCell(
                    appGroupId: currentAppGroupId ?? UUID(),
                    app: app
                )
            }
            .tahoeBorder()

            HStack {
                Button(action: {
                    if let groupId = currentAppGroupId {
                        viewModel.addApp(toGroupId: groupId)
                    }
                }) {
                    Image(systemName: "plus")
                        .frame(height: 16)
                }.disabled(currentAppGroupId == nil)

                Button(action: {
                    if let groupId = currentAppGroupId {
                        viewModel.deleteApps(selectedApps, fromGroupId: groupId)
                        selectedApps = []
                    }
                }) {
                    Image(systemName: "trash")
                        .frame(height: 16)
                }
                .disabled(selectedApps.isEmpty)
                .keyboardShortcut(.delete)

                Spacer()

                Button(action: {
                    openWindow(id: "settings")
                }, label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                }).keyboardShortcut(",")
            }
        }
    }
}

#Preview {
    MainView()
}
