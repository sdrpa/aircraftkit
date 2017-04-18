/**
 Created by Sinisa Drpa on 7/24/16.

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

import Measure
import XCTest
@testable import AircraftKit

class AircraftCodingTests: XCTestCase {

    func testCoding() {
        let takeOff = Performance.TakeOff(v2: 140, distance: 1600, mtow: 56470)
        let climb1 = Performance.Climb(from: 0, to: 5000, ias: 165, rate: 2500)
        let climb2 = Performance.Climb(from: 5000, to: 15000, ias: 270, rate: 2000)
        let cruise = Performance.Cruise(tas: 429, mach: Mach(0.745), ceiling: 370, range: 1600)
        let descent1 = Performance.Descent(from: 660, to: 24000, mach: Mach(0.7), rate: 800)
        let descent2 = Performance.Descent(from: 24000, to: 10000, ias: 270, rate: 3500)
        let approach = Performance.Approach(v: 130, distance: 1400, apc: "C")

        let performance = Performance(takeOff: takeOff, climb: [climb1, climb2], cruise: cruise, descent: [descent1, descent2], approach: approach)
        let value = Aircraft(code: .B733, name: "737-300", manufacturer: "BOEING", typeCode: "L2J", wtc: .medium, performance: performance)
        guard let encoded = value.toJSON() else {
            XCTFail(); return
        }
        XCTAssertTrue(JSONSerialization.isValidJSONObject(encoded))
        let decoded = Aircraft(json: encoded)
        XCTAssertEqual(value, decoded)
    }

    static var allTests : [(String, (AircraftCodingTests) -> () throws -> Void)] {
        return [
            ("testCoding", testCoding),
        ]
    }
}
