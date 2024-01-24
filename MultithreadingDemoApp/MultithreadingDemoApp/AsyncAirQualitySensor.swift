//
//  AsyncAirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation

final class AsyncAirQualitySensor: Sendable {

    private var currentTemperatureReading = Constants.Temperature.initialTemperature
    private var currentHumidityReading = Constants.Humidity.initialHumidity
    private var currentPM2_5Reading = Constants.PM2_5.initialPM2_5

    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading() async -> Double {
        currentTemperatureReading = readingsGenerator.generateRandomTemperatureReading(currentTemperature: currentTemperatureReading)

        return currentTemperatureReading
    }

    private func getHumidityReading() async -> Double {
        currentHumidityReading =         readingsGenerator.generateRandomHumidityReading(currentHumidity: currentHumidityReading)

        return currentHumidityReading
    }

    private func getPM2_5Reading() async -> Double {
        currentPM2_5Reading =         readingsGenerator.generateRandomPM2_5Reading(currentPM2_5: currentPM2_5Reading)

        return currentPM2_5Reading
    }

    public func getAirQualityStatusAsyncSerial() async -> ComfortLevel {
        let temperature = await getTemperatureReading()
        let humidity = await getHumidityReading()
        let pm2_5 = await getPM2_5Reading()
        print("Completed checks: Temperature \(temperature), Humidity \(humidity), PM2_5 \(pm2_5)")
        let comfortStatus = ComfortLevel(temperature: temperature, humidity: humidity, pm2_5: pm2_5)
        return comfortStatus
    }

    public func getAirQualityStatusAsyncParallel() async -> ComfortLevel {
        async let temperature = getTemperatureReading()
        async let humidity = getHumidityReading()
        async let pm2_5 = getPM2_5Reading()
        let comfortStatus = await ComfortLevel(temperature: temperature, humidity: humidity, pm2_5: pm2_5)
        await print("Completed checks: Temperature \(temperature), Humidity \(humidity), PM2_5 \(pm2_5)")
        return comfortStatus
    }
}
