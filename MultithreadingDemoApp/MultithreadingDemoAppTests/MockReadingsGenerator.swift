//
//  MockReadingsGenerator.swift
//  MultithreadingDemoAppTests
//
//  Created by Zieba, Michal on 12/5/23.
//

import Foundation
@testable import MultithreadingDemoApp


public final class MockReadingsGenerator: ReadingsGenerating {
    var mockTemperatureReading: Double = 0.0
    public func generateRandomTemperatureReading(currentTemperature: Double) -> Double {
        mockTemperatureReading
    }
    
    var mockHumidityReading: Double = 0.0
    public func generateRandomHumidityReading(currentHumidity: Double) -> Double {
        mockHumidityReading
    }
    
    var mockPM2_5Reading: Double = 0.0
    public func generateRandomPM2_5Reading(currentPM2_5: Double) -> Double {
        mockPM2_5Reading
    }
}
