import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ImageDimensionDelegate: NSObject, URLSessionDataDelegate {

	enum State {
		case processing
		case cancelled
		case completed
	}

	private let completion: (Result<RemoteImage.Dimensions, Swift.Error>) -> Void

	private var state: State = .processing

	/// Received partial image data
	private var partialData = Data()

	func cancel() {
		if state != .completed {
			state = .cancelled
			completion(.failure(Error.cancelled))
		}
	}

	init(_ completion: @escaping (Result<RemoteImage.Dimensions, Swift.Error>) -> Void) {
		self.completion = completion
	}

	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		guard state == .processing else { return }
		partialData.append(data)
		if let result = ImageDimensionParser.parse(partial: partialData) {
			state = .completed
			dataTask.cancel()
			completion(result)
		}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		if let error = error, state == .processing {
			completion(.failure(error))
			state = .completed
		}
	}

	enum Error: Swift.Error {
		case cancelled
	}

}
