import Foundation

enum ImageDimensionParser {

	static func parse(partial data: Data) -> Result<RemoteImage.Dimensions, Swift.Error>? {
		guard data.count >= 2 else { return nil }
		do {
			let format = try ImageFormat(data: data)
			if let dimensions = try imageDimensions(with: format, data: data) {
				return .success(dimensions)
			}
			return nil
		} catch {
			return .failure(error)
		}
	}

	private static func imageDimensions(with format: ImageFormat, data: Data) throws -> RemoteImage.Dimensions? {
		if let minimumSampleSize = format.minimumSampleSize, data.count < minimumSampleSize { return nil }
		switch format {
		case .bmp: return try parseBMP(data: data)
		case .gif: return parseGIF(data: data)
		case .jpeg: return try parseJPEG(data: data)
		case .png: return parsePNG(data: data)
		}
	}

	private static func parseBMP(data: Data) throws -> RemoteImage.Dimensions {
		let length: UInt16 = data[14..<18].unsafeUInt16
		guard length == 40 else { throw ImageFormat.Error.unsupportedFormat }
		let widthStart = 18
		let heightStart = widthStart + 4
		let width = Int(data[widthStart..<(widthStart + 4)].unsafeUInt32)
		let height = Int(data[heightStart..<(heightStart + 4)].unsafeUInt32)
		return RemoteImage.Dimensions(width: width, height: height, format: .bmp, bytes: data.count)
	}

	private static func parseGIF(data: Data) -> RemoteImage.Dimensions {
		let width = Int(data[6..<8].unsafeUInt16)
		let height = Int(data[8..<10].unsafeUInt16)
		return RemoteImage.Dimensions(width: width, height: height, format: .gif, bytes: data.count)
	}

	private static func parseJPEG(data: Data) throws -> RemoteImage.Dimensions? {
		var i = 0
		guard data[i] == 0xFF && data[i + 1] == 0xD8 && data[i + 2] == 0xFF else {
			throw ImageFormat.Error.unsupportedFormat
		}
		guard data[i + 3] >= 0xE0 || data[i + 3] <= 0xEF else {
			throw ImageFormat.Error.unsupportedFormat
		}
		i += 4

		while (i + 9) < data.count {
			guard data[i] == 0xFF else { i += 1; continue }
			guard data[i + 1] >= 0xC0 && data[i + 1] <= 0xCF else { i += 1; continue }
			let height = Int(data[(i + 5)..<(i + 7)].unsafeUInt16.bigEndian)
			let width = Int(data[(i + 7)..<(i + 9)].unsafeUInt16.bigEndian)
			return RemoteImage.Dimensions(width: width, height: height, format: .jpeg, bytes: data.count)
		}

		return nil
	}

	private static func parsePNG(data: Data) -> RemoteImage.Dimensions {
		let width = Int(data[16..<20].unsafeUInt32.bigEndian)
		let height = Int(data[20..<24].unsafeUInt32.bigEndian)
		return RemoteImage.Dimensions(width: width, height: height, format: .png, bytes: data.count)
	}

}
