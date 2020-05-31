import Foundation

/// Helper library for determining the dimensions of a remote image by downloading the minimum possible amount of data.
public enum RemoteImageDimensions {

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
		let request = URLRequest(url: image, timeoutInterval: configuration.timeout)
		let delegate = ImageDimensionDelegate(completion)
		let urlSession = URLSession(
			configuration: .default,
			delegate: delegate,
			delegateQueue: nil
		)
		let dataTask = urlSession.dataTask(with: request)
		dataTask.resume()
		return RemoteImageDimensionsTask(cancel: { [weak dataTask, weak delegate] in
			delegate?.cancel()
			dataTask?.cancel()
		})
	}

}
