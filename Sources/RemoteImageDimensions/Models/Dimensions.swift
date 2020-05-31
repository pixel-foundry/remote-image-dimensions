public extension RemoteImage {

	struct Dimensions {
		/// Image width in pixels
		var width: Int
		/// Image height in pixels
		var height: Int
		/// Inferred image format
		var format: ImageFormat
		/// Number of bytes that were downloaded to determine the image dimensions
		var bytes: Int
	}

}
