import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class RemoteImageDataDelegate: NSObject, URLSessionDataDelegate {

	private let queue = DispatchQueue(label: "RemoteImageDataDelegateQueue", qos: .utility)

	var taskDelegates = [ImageDimensionTaskDelegate]()

	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		queue.async {
			guard let delegate = self.taskDelegates.first(where: { $0.task === dataTask }) else { return }
			let completed = delegate.process(data: data)
			if completed {
				self.cleanup(for: dataTask)
			}
		}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		queue.async {
			guard let delegate = self.taskDelegates.first(where: { $0.task === task }) else { return }
			delegate.complete(with: error)
			self.cleanup(for: task)
		}
	}

	func cleanup(for task: URLSessionTask) {
		queue.async {
			self.taskDelegates.removeAll(where: {
				if $0.task === task || $0.task == nil {
					$0.task?.cancel()
					return true
				}
				return false
			})
		}
	}

}
