#if canImport(Combine)
import Combine
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension RemoteImage {

	static func dimensionsPublisher(
		of image: URL,
		configuration: Configuration = Configuration()
	) -> AnyPublisher<Dimensions, Error> {
		var task: RemoteImageDimensionsTask?
		return Future<Dimensions, Error> { completion in
			task = RemoteImage.dimensions(of: image, configuration: configuration, completion: completion)
		}.handleEvents(receiveCancel: {
			task?.cancel()
		}).eraseToAnyPublisher()
	}

	static func dimensionsPublisherNonFailing(
		of image: URL,
		configuration: Configuration = Configuration()
	) -> AnyPublisher<Dimensions?, Never> {
		var task: RemoteImageDimensionsTask?
		return Future<Dimensions?, Never> { completion in
			task = RemoteImage.dimensions(of: image, configuration: configuration, completion: { result in
				switch result {
				case .success(let dimensions):
					completion(.success(dimensions))
				case .failure:
					completion(.success(nil))
				}
			})
		}.handleEvents(receiveCancel: {
			task?.cancel()
		}).eraseToAnyPublisher()
	}

}
#endif
