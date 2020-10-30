import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class RemoteImageDataDelegate: NSObject, URLSessionDataDelegate {

	var taskDelegates = [ImageDimensionTaskDelegate]()

	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		guard let delegate = taskDelegates.first(where: { $0.task === dataTask }) else { return }
		let completed = delegate.process(data: data)
		if completed {
			cleanup(for: dataTask)
		}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		guard let delegate = taskDelegates.first(where: { $0.task === task }) else { return }
		delegate.complete(with: error)
		cleanup(for: task)
	}

	func cleanup(for task: URLSessionTask) {
		taskDelegates.removeAll(where: {
			if $0.task === task || $0.task == nil {
				$0.task?.cancel()
				return true
			}
			return false
		})
	}

}
