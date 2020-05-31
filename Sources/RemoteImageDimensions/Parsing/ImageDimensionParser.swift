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
		guard data.count > format.minimumSampleSize else { return nil }
		switch format {
		case .bmp: return try parseBMP(data: data)
		case .gif: return parseGIF(data: data)
		case .jpeg: return parseJPEG(data: data)
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

	private static func parseJPEG(data: Data) -> RemoteImage.Dimensions? {
		var i = 0
		guard data[i] == 0xFF && data[i + 1] == 0xD8 && data[i + 2] == 0xFF && data[i + 3] == 0xE0 else {
			return nil
		}
		i += 4
		// check for valid JPEG header (null terminated JFIF)
		guard Character(UnicodeScalar(data[i + 2])) == "J" &&
			Character(UnicodeScalar(data[i + 3])) == "F" &&
			Character(UnicodeScalar(data[i + 4])) == "I" &&
			Character(UnicodeScalar(data[i + 5])) == "F" &&
			data[i + 6] == 0x00 else {
				return nil
		}
		// retrieve the block length of the first block since the
		// first block will not contain the size of file
		var segmentLength = UInt16(data[i]) * 256 + UInt16(data[i + 1])
		repeat {
			i += Int(segmentLength)
			guard data[i] == 0xFF else { return nil } // check that we are truly at the start of another block
			if data[i + 1] >= 0xC0 && data[i + 1] <= 0xC3 { // if marker type is SOF0, SOF1, SOF2
				let height = Int(data[(i + 5)..<(i + 7)].unsafeUInt16.bigEndian)
				let width = Int(data[(i + 7)..<(i + 9)].unsafeUInt16.bigEndian)
				return RemoteImage.Dimensions(width: width, height: height, format: .jpeg, bytes: data.count)
			} else {
				i += 2
				segmentLength = UInt16(data[i]) * 256 + UInt16(data[i + 1]) // next block
			}
		} while ((i + Int(segmentLength)) < data.count)
		return nil
	}

	private static func parsePNG(data: Data) -> RemoteImage.Dimensions {
		let width = Int(data[16..<20].unsafeUInt32.bigEndian)
		let height = Int(data[20..<24].unsafeUInt32.bigEndian)
		return RemoteImage.Dimensions(width: width, height: height, format: .png, bytes: data.count);
	}

}
