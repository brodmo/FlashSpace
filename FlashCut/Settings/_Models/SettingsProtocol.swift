import Combine

protocol SettingsProtocol {
    var updatePublisher: AnyPublisher<(), Never> { get }

    func load(from appSettings: AppSettings)
    func update(_ appSettings: inout AppSettings)
}
