import Foundation
import XCTest

func bin_data(fromFile file: String, ext: String = "bin") -> Data? {
    return Bundle.module.url(forResource: file, withExtension: ext)
        .flatMap { try? Data(contentsOf: $0) }
}
