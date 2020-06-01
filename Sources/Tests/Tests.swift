import XCTest
@testable import RemoteImageDimensions

class Tests: XCTestCase {

	func testJPEG() {
		let exp1 = expectation(description: "Found jpeg image size")
		RemoteImage.dimensions(of: URL(string: "https://s3.amazonaws.com/f.hal.codes/MacPro.jpg")!) { result in
			switch result {
			case .success(let dimensions):
				XCTAssertEqual(dimensions.width, 2016)
				XCTAssertEqual(dimensions.height, 1400)
				XCTAssertEqual(dimensions.format, .jpeg)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			exp1.fulfill()
		}
		wait(for: [exp1], timeout: 10)
	}

	func testPNG() {
		let exp2 = expectation(description: "Found png size")
		RemoteImage.dimensions(of: URL(string: "https://pixelfoundry.io/static/logo.png")!) { result in
			switch result {
			case .success(let dimensions):
				XCTAssertEqual(dimensions.width, 606)
				XCTAssertEqual(dimensions.height, 216)
				XCTAssertEqual(dimensions.format, .png)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			exp2.fulfill()
		}
		wait(for: [exp2], timeout: 10)
	}

	func testGIF() {
		let exp3 = expectation(description: "Found gif size")
		RemoteImage.dimensions(of: URL(string: "https://media.giphy.com/media/LW5vBvAb48Oe9OoEKT/giphy.gif")!) { result in
			switch result {
			case .success(let dimensions):
				XCTAssertEqual(dimensions.width, 480)
				XCTAssertEqual(dimensions.height, 270)
				XCTAssertEqual(dimensions.format, .gif)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			exp3.fulfill()
		}
		wait(for: [exp3], timeout: 10)
	}

}
