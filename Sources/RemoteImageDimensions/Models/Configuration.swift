import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension RemoteImageDimensions {

	struct Configuration {
		public let timeout: TimeInterval

		/// Allows you to specify download parameters for a RemoteImageDimensions task.
		/// - Parameters:
		///   - timeout: Timeout interval for the data download task.
		public init(timeout: TimeInterval = 5) {
			self.timeout = timeout
		}
	}

}
