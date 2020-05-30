import Foundation

public enum RemoteImageDimensions {

	public struct Dimensions {
		var width: Int?
		var height: Int?
		var aspectRatio: Float
	}

	@discardableResult
	public static func dimensions(
		of image: URL,
		configuration: Configuration = Configuration(),
		completion: @escaping (Result<Dimensions, Error>) -> Void
	) -> RemoteImageDimensionsTask {
		let request = URLRequest(url: image, timeoutInterval: configuration.timeout)
		let task = configuration.urlSession.dataTask(with: request) { data, response, error in

		}
		let cancel = { task.cancel() }
		task.resume()
		return RemoteImageDimensionsTask(cancel: cancel)
	}

}
