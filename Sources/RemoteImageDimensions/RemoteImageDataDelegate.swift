import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class RemoteImageDataDelegate: NSObject, URLSessionDataDelegate {

	var taskDelegate = [URLSessionTask: ImageDimensionTaskDelegate]()

	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		guard let delegate = taskDelegate[dataTask] else { return }
		let completed = delegate.process(data: data)
		if completed {
			taskDelegate[dataTask] = nil
			dataTask.cancel()
		}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		guard let delegate = taskDelegate[task] else { return }
		delegate.complete(with: error)
		taskDelegate[task] = nil
	}

}
