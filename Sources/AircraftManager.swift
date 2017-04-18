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
import Measure

public final class AircraftManager {

    fileprivate var aircraft: [Aircraft]?

    public init(directory: URL) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            var items = [Aircraft]()
            for fileURL in contents {
                if let aircraft = self.parseAircraft(fileURL: fileURL) {
                    items.append(aircraft)
                }
            }
            self.aircraft = (items.count == 0) ? nil : items
        } catch {
        }
    }

    public func aircraft(code: Aircraft.ICAOCode) -> Aircraft? {
        return self.aircraft?.first { $0.code == code }
    }

    func parseAircraft(fileURL: URL) -> Aircraft? {
        if fileURL.pathExtension != "xml" {
            return nil
        }

        typealias TakeOff = Performance.TakeOff
        typealias Climb = Performance.Climb
        typealias Cruise = Performance.Cruise
        typealias Descent = Performance.Descent
        typealias Approach = Performance.Approach

        func parseTakeOff(indexer: XmlIndexer) -> TakeOff {
            let v2 = Double(indexer["v2"].element?.text)
            let distance = Double(indexer["distance"].element?.text)
            let mtow = Double(indexer["mtow"].element?.text)
            let takeOff = TakeOff(v2: v2, distance: distance, mtow: mtow)
            return takeOff
        }

        func parseClimb(indexer: XmlIndexer) -> [Climb] {
            let phases = indexer["phase"].reduce([Climb]()) { acc, phase in
                let from = Double(phase["from"].element?.text)
                let to = Double(phase["to"].element?.text)
                let ias = Double(phase["ias"].element?.text)
                let mach = Mach(phase["from"].element?.text)
                let rate = Double(phase["rate"].element?.text)
                return acc + [Climb(from: from, to: to, ias: ias, mach: mach, rate: rate)]
            }
            return phases
        }

        func parseCruise(indexer: XmlIndexer) -> Cruise {
            let tas = Double(indexer["tas"].element?.text)
            let mach = Mach(indexer["mach"].element?.text)
            let ceiling = UInt(indexer["ceiling"].element?.text)
            let range = Double(indexer["range"].element?.text)
            let cruise = Cruise(tas: tas, mach: mach, ceiling: ceiling, range: range)
            return cruise
        }

        func parseDescent(indexer: XmlIndexer) -> [Descent] {
            let phases = indexer["phase"].reduce([Descent]()) { acc, phase in
                let ias = Double(phase["ias"].element?.text)
                let mach = Mach(phase["from"].element?.text)
                let mcs = Double(phase["mcs"].element?.text)
                let rate = Double(phase["rate"].element?.text)
                return acc + [Descent(ias: ias, mach: mach, mcs: mcs, rate: rate)]
            }
            return phases
        }

        func parseApproach(indexer: XmlIndexer) -> Approach {
            let v = Double(indexer["v"].element?.text)
            let distance = Double(indexer["distance"].element?.text)
            let apc = indexer["apc"].element?.text
            let approach = Approach(v: v, distance: distance, apc: apc)
            return approach
        }

        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let indexer = XmlParser.parse(contents)
            let aircraft = indexer["aircraft"]

            guard let codeText = aircraft["ICAOCode"].element?.text,
                let code = Aircraft.ICAOCode(rawValue: codeText) else {
                    fatalError("code == nil")
            }
            guard let name = aircraft["name"].element?.text else {
                fatalError("name == nil")
            }
            guard let manufacturer = aircraft["manufacturer"].element?.text else {
                fatalError("manufacturer == nil")
            }
            guard let typeCode = aircraft["typeCode"].element?.text else {
                fatalError("typeCode == nil")
            }
            var wtc: Aircraft.WakeTurbulance?
            if let wtcText = aircraft["WTC"].element?.text {
                wtc = Aircraft.WakeTurbulance(rawValue: wtcText)
            }

            let takeOff = parseTakeOff(indexer: aircraft["takeOff"])
            let climb = parseClimb(indexer: aircraft["climb"])
            let cruise = parseCruise(indexer: aircraft["cruise"])
            let descent = parseDescent(indexer: aircraft["descent"])
            let approach = parseApproach(indexer: aircraft["approach"])

            let performance = Performance(takeOff: takeOff, climb: climb, cruise: cruise, descent: descent, approach: approach)

            return Aircraft(code: code,
                            name: name,
                            manufacturer: manufacturer,
                            typeCode: typeCode,
                            wtc: wtc,
                            performance: performance)
        } catch {
            return nil
        }
    }
}

fileprivate extension Mach {
    init?(_ string: String?) {
        guard let string = string, let v = Double(string) else {
            return nil
        }
        self.init(v)
    }
}

fileprivate extension Double {
    init?(_ v: String?) {
        guard let v = v else {
            return nil
        }
        self.init(v)
    }
}

fileprivate extension UInt {
    init?(_ v: String?) {
        guard let v = v else {
            return nil
        }
        self.init(v)
    }
}
