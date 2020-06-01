import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension RemoteImage {

	struct Configuration {
		public let timeout: TimeInterval
		public let byteRange: Range<Int>?

		/// Allows you to specify download parameters for a RemoteImageDimensions task.
		/// - Parameters:
		///   - timeout: Timeout interval for the data download task
		///   - byteRange: Range of bytes to request in the HTTP `Range` header for the data download task
		///
		///     By default, the minimum viable byte range for the suspected image format is used. You may specify a value
		///     here to override the default. For JPEG images, large amounts of data may appear before the size information
		///     and therefore you may want to provide a higher byte range than the default of 0-14999.
		public init(timeout: TimeInterval = 5, byteRange: Range<Int>? = nil) {
			self.timeout = timeout
			self.byteRange = byteRange
		}
	}

}
