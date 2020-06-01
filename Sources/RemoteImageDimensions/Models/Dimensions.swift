public extension RemoteImage {

	struct Dimensions {
		/// Image width in pixels
		public var width: Int
		/// Image height in pixels
		public var height: Int
		/// Inferred image format
		public var format: ImageFormat
		/// Number of bytes that were downloaded to determine the image dimensions
		public var bytes: Int
	}

}
