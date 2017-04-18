/**
 Created by Sinisa Drpa on 3/31/17.

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

import JSON
import Measure

extension Aircraft: Coding {

    public init?(json: JSON) {
        guard let code: Aircraft.ICAOCode = "code" <| json,
            let name: String = "name" <| json,
            let manufacturer: String = "manufacturer" <| json,
            let typeCode: String = "typeCode" <| json,
            let wtc: WakeTurbulance = "wtc" <| json,
            let performance: Performance = "performance" <| json else {
                return nil
        }
        self.code = code
        self.name = name
        self.manufacturer = manufacturer
        self.typeCode = typeCode
        self.wtc = wtc
        self.performance = performance
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "code" |> self.code,
            "name" |> self.name,
            "manufacturer" |> self.manufacturer,
            "typeCode" |> self.typeCode,
            "wtc" |> self.wtc,
            "performance" |> self.performance
            ])
    }
}

extension Performance: Coding {

    public init?(json: JSON) {
        guard let takeOff: TakeOff = "takeOff" <| json,
            let climb: [Climb] = "climb" <| json,
            let cruise: Cruise = "cruise" <| json,
            let descent: [Descent] = "descent" <| json,
            let approach: Approach = "approach" <| json else {
                return nil
        }

        self.takeOff = takeOff
        self.climb = climb
        self.cruise = cruise
        self.descent = descent
        self.approach = approach
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "takeOff" |> self.takeOff,
            "climb" |> self.climb,
            "cruise" |> self.cruise,
            "descent" |> self.descent,
            "approach" |> self.approach
            ])
    }
}

extension Performance.TakeOff: Coding {

    public init?(json: JSON) {
        self.v2 = "v2" <| json
        self.distance = "distance" <| json
        self.mtow = "mtow" <| json
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "v2" |> self.v2,
            "distance" |> self.distance,
            "mtow" |> self.mtow
            ])
    }
}

extension Performance.Climb: Coding {

    public init?(json: JSON) {
        self.from = "from" <| json
        self.to = "to" <| json
        self.ias = "ias" <| json
        self.mach = "mach" <| json
        self.rate = "rate" <| json
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "from" |> self.from,
            "to" |> self.to,
            "ias" |> self.ias,
            "mach" |> self.mach,
            "rate" |> self.rate
            ])
    }
}

extension Performance.Cruise: Coding {

    public init?(json: JSON) {
        self.tas = "tas" <| json
        self.mach = "mach" <| json
        self.ceiling = "ceiling" <| json
        self.range = "rate" <| json
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "tas" |> self.tas,
            "mach" |> self.mach,
            "ceiling" |> self.ceiling,
            "range" |> self.range
            ])
    }
}

extension Performance.Descent: Coding {

    public init?(json: JSON) {
        self.from = "from" <| json
        self.to = "to" <| json
        self.ias = "ias" <| json
        self.mach = "mach" <| json
        self.mcs = "mcs" <| json
        self.rate = "rate" <| json
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "from" |> self.from,
            "to" |> self.to,
            "ias" |> self.ias,
            "mach" |> self.mach,
            "mcs" |> self.mcs,
            "rate" |> self.rate
            ])
    }
}

extension Performance.Approach: Coding {

    public init?(json: JSON) {
        self.v = "v" <| json
        self.distance = "distance" <| json
        self.apc = "apc" <| json
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "v" |> self.v,
            "distance" |> self.distance,
            "apc" |> self.apc
            ])
    }
}
