//
//  ClosureAirQualitySensorTests.swift
//  MultithreadingDemoAppTests
//
//  Created by Zieba, Michal on 12/5/23.
//

import Foundation
import XCTest
@testable import MultithreadingDemoApp

final class ClosureAirQualitySensorTests: XCTestCase {

    func testReadingComfortLevelSerial() {
        let mockReadingsGenerator = MockReadingsGenerator()

        mockReadingsGenerator.mockTemperatureReading = 28.0
        mockReadingsGenerator.mockHumidityReading = 80.0
        mockReadingsGenerator.mockPM2_5Reading = 50.0

        let closureAirQualitySensor = ClosureAirQualitySensor(readingsGenerator: mockReadingsGenerator)

        let expectation = expectation(description: "Comfort Level Read")
        var comfortLevel: ComfortLevel?
        closureAirQualitySensor.getAirQualityStatusClosureSerial {
            comfortLevel = $0
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(comfortLevel!.currentComfortStatus.rawValue, "☹️")
        XCTAssertEqual(comfortLevel!.temperatureText, "Temperature: 28.0")
        XCTAssertEqual(comfortLevel!.humidityText, "Humidity: 80.0")
        XCTAssertEqual(comfortLevel!.pm2_5Text, "PM2.5: 50")
    }

    func testReadingComfortLevelParallel() {
        let mockReadingsGenerator = MockReadingsGenerator()

        mockReadingsGenerator.mockTemperatureReading = 28.0
        mockReadingsGenerator.mockHumidityReading = 80.0
        mockReadingsGenerator.mockPM2_5Reading = 50.0

        let closureAirQualitySensor = ClosureAirQualitySensor(readingsGenerator: mockReadingsGenerator)

        let expectation = expectation(description: "Comfort Level Read")
        var comfortLevel: ComfortLevel?
        closureAirQualitySensor.getAirQualityStatusClosureParallel {
            comfortLevel = $0
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(comfortLevel!.currentComfortStatus.rawValue, "☹️")
        XCTAssertEqual(comfortLevel!.temperatureText, "Temperature: 28.0")
        XCTAssertEqual(comfortLevel!.humidityText, "Humidity: 80.0")
        XCTAssertEqual(comfortLevel!.pm2_5Text, "PM2.5: 50")
    }
}
