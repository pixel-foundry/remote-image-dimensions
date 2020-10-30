import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Helper library for determining the dimensions of a remote image by downloading the minimum possible amount of data.
public enum RemoteImage {

	private static let delegate = RemoteImageDataDelegate()

	private static let urlSession: URLSession = URLSession(
		configuration: .default,
		delegate: delegate,
		delegateQueue: nil
	)

	/// Fetch the dimensions of the image at a remote image URL.
	/// - Parameters:
	///   - image: The URL of the remote image.
	///   - configuration: Configuration for download parameters.
	///   - completion: Completion block called when the dimension finding task completes.
	///   - result: Result with RemoteImageDimensions.Dimensions object if successful, or otherwise an error.
	/// - Returns: A RemoteImageDimensionsTask object that allows you to cancel an in-progress task.
	@discardableResult public static func dimensions(
		of image: URL,
		configuration: Configuration = Configuration(),
		completion: @escaping (_ result: Result<Dimensions, Error>) -> Void
	) -> RemoteImageDimensionsTask {
		let dataTask = urlSession.dataTask(with: URLRequest.request(for: image, with: configuration))
		let taskDelegate = ImageDimensionTaskDelegate(task: dataTask, completion)
		delegate.taskDelegates.append(taskDelegate)
		dataTask.resume()
		return RemoteImageDimensionsTask(cancel: { [weak taskDelegate, weak dataTask, weak delegate] in
			taskDelegate?.cancel()
			if let dataTask = dataTask {
				delegate?.cleanup(for: dataTask)
			}
		})
	}

}
