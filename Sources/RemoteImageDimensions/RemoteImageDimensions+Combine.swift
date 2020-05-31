#if canImport(Combine)
import Combine
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteImage {

	static func dimensions(
		of image: URL,
		configuration: Configuration = Configuration()
	) -> AnyPublisher<Dimensions, Error> {
		var task: RemoteImageDimensionsTask?
		return Future<Dimensions, Error> { completion in
			task = self.dimensions(of: image, configuration: configuration, completion: completion)
		}.handleEvents(receiveCancel: {
			task?.cancel()
		}).eraseToAnyPublisher()
	}

}
#endif
