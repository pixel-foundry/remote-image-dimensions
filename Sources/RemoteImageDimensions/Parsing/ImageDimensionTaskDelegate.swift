import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ImageDimensionTaskDelegate {

	enum State {
		case processing
		case cancelled
		case completed
	}

	private let completion: (Result<RemoteImage.Dimensions, Swift.Error>) -> Void

	private var state: State = .processing

	var url: URL?

	/// Received partial image data
	private var partialData = Data()

	func cancel() {
		if state != .completed {
			state = .cancelled
			completion(.failure(Error.cancelled))
		}
	}

	init(task: URLSessionTask, _ completion: @escaping (Result<RemoteImage.Dimensions, Swift.Error>) -> Void) {
		self.url = task.originalRequest?.url
		self.completion = completion
	}

	func process(data: Data) -> Bool {
		guard state == .processing else { return true }
		partialData.append(data)
		if let result = ImageDimensionParser.parse(partial: partialData) {
			state = .completed
			completion(result)
			return true
		}
		return false
	}

	func complete(with error: Swift.Error?) {
		if state == .processing {
			completion(.failure(error ?? ImageFormat.Error.unsupportedFormat))
			state = .completed
		}
	}

	enum Error: Swift.Error {
		case cancelled
	}

}
