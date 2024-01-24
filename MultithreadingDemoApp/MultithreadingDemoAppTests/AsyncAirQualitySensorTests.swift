//
//  AsyncAirQualitySensorTests.swift
//  MultithreadingDemoAppTests
//
//  Created by Zieba, Michal on 12/5/23.
//

import Foundation
import XCTest
@testable import MultithreadingDemoApp

final class AsyncAirQualitySensorTests: XCTestCase {

    func testReadingComfortLevelSerial() async {
        let mockReadingsGenerator = MockReadingsGenerator()

        mockReadingsGenerator.mockTemperatureReading = 28.0
        mockReadingsGenerator.mockHumidityReading = 80.0
        mockReadingsGenerator.mockPM2_5Reading = 50.0

        let asyncAirQualitySensor = AsyncAirQualitySensor(readingsGenerator: mockReadingsGenerator)

        let comfortLevel = await asyncAirQualitySensor.getAirQualityStatusAsyncSerial()

        XCTAssertEqual(comfortLevel.currentComfortStatus.rawValue, "☹️")
        XCTAssertEqual(comfortLevel.temperatureText, "Temperature: 28.0")
        XCTAssertEqual(comfortLevel.humidityText, "Humidity: 80.0")
        XCTAssertEqual(comfortLevel.pm2_5Text, "PM2.5: 50")
    }

    func testReadingComfortLevelParallel() async {
        let mockReadingsGenerator = MockReadingsGenerator()

        mockReadingsGenerator.mockTemperatureReading = 28.0
        mockReadingsGenerator.mockHumidityReading = 80.0
        mockReadingsGenerator.mockPM2_5Reading = 50.0

        let asyncAirQualitySensor = AsyncAirQualitySensor(readingsGenerator: mockReadingsGenerator)

        let comfortLevel = await asyncAirQualitySensor.getAirQualityStatusAsyncParallel()

        XCTAssertEqual(comfortLevel.currentComfortStatus.rawValue, "☹️")
        XCTAssertEqual(comfortLevel.temperatureText, "Temperature: 28.0")
        XCTAssertEqual(comfortLevel.humidityText, "Humidity: 80.0")
        XCTAssertEqual(comfortLevel.pm2_5Text, "PM2.5: 50")
    }
}
