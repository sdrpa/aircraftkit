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

import Foundation
import Measure

public struct Aircraft: Equatable {

    public let code: Aircraft.ICAOCode // ICAO code
    public let name: String
    public let manufacturer: String
    public let typeCode: String
    public let wtc: WakeTurbulance?
    public let performance: Performance

    public init(code: Aircraft.ICAOCode, name: String, manufacturer: String, typeCode: String, wtc: WakeTurbulance?, performance: Performance) {
        self.code = code
        self.name = name
        self.manufacturer = manufacturer
        self.typeCode = typeCode
        self.wtc = wtc
        self.performance = performance
    }

    public static func ==(lhs: Aircraft, rhs: Aircraft) -> Bool {
        return (lhs.code == rhs.code)
    }
}

public extension Aircraft {

    enum WakeTurbulance: String {
        case light = "Light"
        case medium = "Medium"
        case heavy = "Heavy"
    }

}

public struct Performance {

    public let takeOff: TakeOff
    public let climb: [Climb]
    public let cruise: Cruise
    public let descent: [Descent]
    public let approach: Approach

    public init(takeOff: TakeOff, climb: [Climb], cruise: Cruise, descent: [Descent], approach: Approach) {
        self.takeOff = takeOff
        self.climb = climb
        self.cruise = cruise
        self.descent = descent
        self.approach = approach
    }

    public struct TakeOff {
        public let v2: Double? // IAS (kts)
        public let distance: Double? // meters
        public let mtow: Double? // kg

        public init(v2: Double? = nil, distance: Double? = nil, mtow: Double? = nil) {
            self.v2 = v2
            self.distance = distance
            self.mtow = mtow
        }
    }

    public struct Climb {
        public let from: Double? // feet
        public let to: Double? // feet
        public let ias: Double? // kts
        public let mach: Mach?
        public let rate: Double? // ft/min

        public init(from: Double? = nil, to: Double? = nil, ias: Double? = nil, mach: Mach? = nil, rate: Double? = nil) {
            self.from = from
            self.to = to
            self.ias = ias
            self.mach = mach
            self.rate = rate
        }
    }

    public struct Cruise {
        public let tas: Double? // kts
        public let mach: Mach? // Mach
        public let ceiling: UInt? // FL
        public let range: Double? // Nm

        public init(tas: Double? = nil, mach: Mach? = nil, ceiling: UInt? = nil, range: Double? = nil) {
            self.tas = tas
            self.mach = mach
            self.ceiling = ceiling
            self.range = range
        }
    }

    public struct Descent {
        public let from: Double? // feet
        public let to: Double? // feet
        public let ias: Double? // kts
        public let mach: Mach?
        public let mcs: Double? // kts
        public let rate: Double? // ft/min

        public init(from: Double? = nil, to: Double? = nil, ias: Double? = nil, mach: Mach? = nil, mcs: Double? = nil, rate: Double? = nil) {
            self.from = from
            self.to = to
            self.ias = ias
            self.mach = mach
            self.mcs = mcs
            self.rate = rate
        }
    }

    public struct Approach {
        public let v: Double? // IAS (kts)
        public let distance: Double? // meters
        public let apc: String?

        public init(v: Double? = nil, distance: Double? = nil, apc: String?) {
            self.v = v
            self.distance = distance
            self.apc = apc
        }
    }
}

