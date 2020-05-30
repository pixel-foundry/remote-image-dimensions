import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension RemoteImageDimensions {

	struct Configuration {
		public let urlSession: URLSession
		public let timeout: TimeInterval

		public init(urlSession: URLSession = .shared, timeout: TimeInterval = 5) {
			self.urlSession = urlSession
			self.timeout = timeout
		}
	}

}
