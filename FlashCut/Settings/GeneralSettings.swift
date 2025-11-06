//
//  GeneralSettings.swift
//
//  Created by Wojciech Kulik on 16/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import Combine
import Foundation

final class GeneralSettings: ObservableObject {
    @Published var showFlashCut: AppHotKey?
    @Published var checkForUpdatesAutomatically = false {
        didSet { UpdatesManager.shared.autoCheckForUpdates = checkForUpdatesAutomatically }
    }

    private var observer: AnyCancellable?
    private let updateSubject = PassthroughSubject<(), Never>()

    init() { observe() }

    private func observe() {
        observer = Publishers.MergeMany(
            $showFlashCut.settingsPublisher(),
            $checkForUpdatesAutomatically.settingsPublisher()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in self?.updateSubject.send() }
    }
}

extension GeneralSettings: SettingsProtocol {
    var updatePublisher: AnyPublisher<(), Never> {
        updateSubject.eraseToAnyPublisher()
    }

    func load(from appSettings: AppSettings) {
        observer = nil
        showFlashCut = appSettings.showFlashCut
        checkForUpdatesAutomatically = appSettings.checkForUpdatesAutomatically ?? false
        observe()
    }

    func update(_ appSettings: inout AppSettings) {
        appSettings.showFlashCut = showFlashCut
        appSettings.checkForUpdatesAutomatically = checkForUpdatesAutomatically
    }
}
