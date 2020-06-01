import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

	static func request(for url: URL, with configuration: RemoteImage.Configuration) -> Self {
		var request = URLRequest(url: url, timeoutInterval: configuration.timeout)
		let byteRange = configuration.byteRange ?? url.byteRange
		if let start = byteRange.first, let end = byteRange.last {
			request.addValue(
				"bytes=\(start)-\(end)",
				forHTTPHeaderField: "Range"
			)
		}
		return request
	}

}

extension URL {

	var byteRange: Range<Int> {
		let formats = ImageFormat.allCases
		for format in formats {
			if let minimum = format.minimumSampleSize, absoluteString.contains(".\(format.rawValue)") {
				return 0..<minimum
			}
		}
		return 0..<15000 // 15 KB for JPEGs, which can have large amounts of data before the size information
	}

}
