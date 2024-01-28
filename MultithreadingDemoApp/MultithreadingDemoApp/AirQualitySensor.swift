//
//  AirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation

final class AirQualitySensor: Sendable {

    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading() -> Double {
        readingsGenerator.generateRandomTemperatureReading()
    }

    private func getHumidityReading() -> Double {
        readingsGenerator.generateRandomHumidityReading()
    }

    private func getPM2_5Reading() -> Double {
        readingsGenerator.generateRandomPM2_5Reading()
    }

    func getAirQualityStatusBlocking() -> ComfortLevel {
        let temperature = getTemperatureReading()
        let humidity = getHumidityReading()
        let pm2_5 = getPM2_5Reading()
        let comfortStatus = ComfortLevel(temperature: temperature, humidity: humidity, pm2_5: pm2_5)
        print("Completed checks: Temperature \(temperature), Humidity \(humidity), PM2_5 \(pm2_5)")
        return comfortStatus
    }
}
