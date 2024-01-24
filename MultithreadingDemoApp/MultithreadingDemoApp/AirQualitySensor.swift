//
//  AirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation

final class AirQualitySensor {

    private var currentTemperatureReading = Constants.Temperature.initialTemperature
    private var currentHumidityReading = Constants.Humidity.initialHumidity
    private var currentPM2_5Reading = Constants.PM2_5.initialPM2_5

    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading() -> Double {
        currentTemperatureReading = readingsGenerator.generateRandomTemperatureReading(currentTemperature: currentTemperatureReading)

        return currentTemperatureReading
    }

    private func getHumidityReading() -> Double {
        currentHumidityReading =         readingsGenerator.generateRandomHumidityReading(currentHumidity: currentHumidityReading)

        return currentHumidityReading
    }

    private func getPM2_5Reading() -> Double {
        currentPM2_5Reading =         readingsGenerator.generateRandomPM2_5Reading(currentPM2_5: currentPM2_5Reading)

        return currentPM2_5Reading
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
