//
//  AsyncAirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation

final class AsyncAirQualitySensor: Sendable {
/*
    private var currentTemperatureReading = Constants.Temperature.initialTemperature
    private var currentHumidityReading = Constants.Humidity.initialHumidity
    private var currentPM2_5Reading = Constants.PM2_5.initialPM2_5
*/
    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading() async -> Double {
        readingsGenerator.generateRandomTemperatureReading()
    }

    private func getHumidityReading() async -> Double {
        readingsGenerator.generateRandomHumidityReading()
    }

    private func getPM2_5Reading() async -> Double {
        readingsGenerator.generateRandomPM2_5Reading()
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
