import Foundation

extension String {
    static let defaultIconSymbol = "bolt.fill"

    func padEnd(toLength length: Int, withPad pad: String = " ") -> String {
        if count < length {
            return self + String(repeating: pad, count: length - count)
        } else {
            return self
        }
    }
}
