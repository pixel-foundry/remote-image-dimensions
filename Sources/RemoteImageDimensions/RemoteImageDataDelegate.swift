import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class RemoteImageDataDelegate: NSObject, URLSessionDataDelegate {

	private let queue = DispatchQueue(label: "RemoteImageDataDelegateQueue", qos: .utility)

	var taskDelegates = [ImageDimensionTaskDelegate]()

	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		queue.async {
			guard let delegate = self.taskDelegates.first(where: { $0.url == dataTask.originalRequest?.url }) else { return }
			let completed = delegate.process(data: data)
			if completed {
				self.cleanup(for: dataTask.originalRequest?.url)
				dataTask.cancel()
			}
		}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		queue.async {
			guard let delegate = self.taskDelegates.first(where: { $0.url == task.originalRequest?.url }) else { return }
			delegate.complete(with: error)
			self.cleanup(for: task.originalRequest?.url)
		}
	}

	func cleanup(for url: URL?) {
		queue.async {
			self.taskDelegates.removeAll(where: { $0.url == url })
		}
	}

}
