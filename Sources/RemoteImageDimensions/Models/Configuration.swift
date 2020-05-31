import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension RemoteImageDimensions {

	struct Configuration {
		public let timeout: TimeInterval
		public let byteRange: Range<Int>

		/// Allows you to specify download parameters for a RemoteImageDimensions task.
		/// - Parameters:
		///   - timeout: Timeout interval for the data download task
		///   - byteRange: Range of bytes to request in the HTTP `Range` header for the data download task
		public init(timeout: TimeInterval = 5, byteRange: Range<Int> = 0..<512) {
			self.timeout = timeout
			self.byteRange = byteRange
		}
	}

}
