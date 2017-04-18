/**
 Created by Sinisa Drpa on 2/14/17.

 AircraftKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License or any later version.

 AircraftKit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with AircraftKit.  If not, see <http://www.gnu.org/licenses/>
 */

import Foundation
import XCTest
@testable import AircraftKit

class AircraftManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    var directory: URL {
        return URL(fileURLWithPath: "\(#file)").deletingLastPathComponent().appendingPathComponent("../../../../Data/Aircraft")
    }

    func testAircraftManager() {
        let aircraft = AircraftManager(directory: directory).aircraft(code: .B737)
        XCTAssertEqual(aircraft?.code, .B737)
        XCTAssertEqual(aircraft?.performance.takeOff.v2, 150)
    }

    static var allTests = [
        ("testAircraftManager", testAircraftManager)
    ]
}
