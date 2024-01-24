//
//  Helpers.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 12/3/23.
//

import Foundation

public extension Double {
    func clamp(minValue: Double, maxValue: Double) -> Double {
        min(max(self, minValue), maxValue)
    }
}

public protocol ReadingsGenerating {
    func generateRandomTemperatureReading(currentTemperature: Double) -> Double
    func generateRandomHumidityReading(currentHumidity: Double) -> Double
    func generateRandomPM2_5Reading(currentPM2_5: Double) -> Double
}

public final class ReadingsGenerator: ReadingsGenerating {

    public func generateRandomTemperatureReading(currentTemperature: Double) -> Double {
        print("Reading temperature 🌡️")
        sleep(Constants.temperatureReadTime)
        print("Temperature Check Complete")

        let temperatureChange = Double.random(in: -5...5)
        let newTemperature = currentTemperature + 0.1 * Double(temperatureChange)
        let newTemperatureClamped = newTemperature.clamp(
            minValue: Constants.Temperature.minTemperature,
            maxValue: Constants.Temperature.maxTemperature
        )

        return newTemperatureClamped
    }

    public func generateRandomHumidityReading(currentHumidity: Double) -> Double {
        print("Reading humidity 💧")
        sleep(Constants.humidityReadTime)
        print("Humidity Check Complete")

        let humidityChange = Double.random(in: -5...5)
        let newHumidity = currentHumidity + 0.5 * Double(humidityChange)
        let newHumidityClamped = newHumidity.clamp(
            minValue: Constants.Humidity.minHumidity,
            maxValue: Constants.Humidity.maxHumidity
        )

        return newHumidityClamped
    }

    public func generateRandomPM2_5Reading(currentPM2_5: Double) -> Double {
        print("Reading PM2.5 💨")
        sleep(Constants.pm2_5ReadTime)
        print("PM2.5 Check Complete")

        let pm2_5Change = Double.random(in: -5...5)
        let newPM2_5 = currentPM2_5 + 1.0 * Double(pm2_5Change)
        let newPM2_5Clamped = newPM2_5.clamp(
            minValue: Constants.PM2_5.minPM2_5,
            maxValue: Constants.PM2_5.maxPM2_5
        )

        return newPM2_5Clamped
    }

}


