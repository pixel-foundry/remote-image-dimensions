import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

	static func request(for url: URL, with configuration: RemoteImage.Configuration) -> Self {
		var request = URLRequest(url: url, timeoutInterval: configuration.timeout)
		if let start = configuration.byteRange.first, let end = configuration.byteRange.last {
			request.addValue(
				"bytes=\(start)-\(end)",
				forHTTPHeaderField: "Range"
			)
		}
		return request
	}
	
}
