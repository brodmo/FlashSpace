//
//  MainView.swift
//  FlashSpace
//
//  Created by Wojciech Kulik on 19/01/2025.
//

import AppKit
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @Environment(\.openWindow) var openWindow

    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            appGroups
            rightPanel
        }
        .padding()
        .frame(width: 450, height: 350)
        .sheet(isPresented: $viewModel.isInputDialogPresented) {
            InputDialog(
                title: "Enter App Group name:",
                userInput: $viewModel.userInput,
                isPresented: $viewModel.isInputDialogPresented
            )
        }
    }

    private var rightPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.selectedAppGroup != nil {
                AppGroupConfigurationView(viewModel: viewModel)
                    .frame(height: 85)
                assignedApps
            } else {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(width: 200, height: 250)
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
        }
    }

    private var appGroups: some View {
        VStack(alignment: .leading) {
            List(
                $viewModel.appGroups,
                id: \.self,
                editActions: .move,
                selection: $viewModel.selectedAppGroups
            ) { $appGroup in
                AppGroupCell(
                    selectedApps: $viewModel.selectedApps,
                    appGroup: $appGroup
                )
            }
            .frame(width: 200, height: 250)
            .tahoeBorder()

            HStack {
                Button(action: viewModel.addAppGroup) {
                    Image(systemName: "plus")
                        .frame(height: 16)
                }

                Button(action: viewModel.deleteSelectedAppGroups) {
                    Image(systemName: "trash")
                        .frame(height: 16)
                }
                .disabled(viewModel.selectedAppGroups.isEmpty)

                Spacer()
            }
        }
    }

    private var assignedApps: some View {
        VStack(alignment: .leading) {
            List(
                viewModel.appGroupApps ?? [],
                id: \.self,
                selection: $viewModel.selectedApps
            ) { app in
                AppCell(
                    appGroupId: viewModel.selectedAppGroup?.id ?? UUID(),
                    app: app
                )
            }
            .frame(width: 200, height: 165)
            .tahoeBorder()

            HStack {
                Button(action: viewModel.addApp) {
                    Image(systemName: "plus")
                        .frame(height: 16)
                }.disabled(viewModel.selectedAppGroup == nil)

                Button(action: viewModel.deleteSelectedApps) {
                    Image(systemName: "trash")
                        .frame(height: 16)
                }
                .disabled(viewModel.selectedApps.isEmpty)
                .keyboardShortcut(.delete)

                Spacer()

                Button(action: {
                    openWindow(id: "settings")
                }, label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                }).keyboardShortcut(",")
            }
            .frame(width: 200)
        }
    }
}

#Preview {
    MainView()
}
