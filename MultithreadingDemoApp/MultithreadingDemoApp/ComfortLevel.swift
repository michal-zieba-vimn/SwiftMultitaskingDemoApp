//
//  ComfortLevel.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 12/3/23.
//

import Foundation

enum ComfortSmiley: String {
    case happy = "😊"
    case neutral = "😕"
    case bad = "☹️"
}

struct ComfortLevel: Sendable {
    public let currentComfortStatus: ComfortSmiley
    public let temperatureText: String
    public let humidityText: String
    public let pm2_5Text: String

    private let idealTemperature: CGFloat = 20
    private let happyTemperatureMargin: CGFloat = 1
    private let neutralTemperatureMargin: CGFloat = 3

    private let idealHumidity: CGFloat = 50
    private let happyHumidityMargin: CGFloat = 5
    private let neutralHumidityMargin: CGFloat = 10

    private let idealPM2_5Level: CGFloat = 0
    private let happyPM2_5Level: CGFloat = 15
    private let neutralPM2_5Level: CGFloat = 30


    init(temperature: CGFloat,
         humidity: CGFloat,
         pm2_5: CGFloat) {
        temperatureText = String(format: "Temperature: %.1f", temperature)
        humidityText = String(format: "Humidity: %.1f", humidity)
        pm2_5Text = String(format: "PM2.5: %.0f", pm2_5)

        let idealTemperatureDeviation = abs(temperature - idealTemperature)

        var comfortScore = 0
        if idealTemperatureDeviation <= happyTemperatureMargin {
            comfortScore += 2
        } else if idealTemperatureDeviation <= neutralHumidityMargin {
            comfortScore += 1
        }

        let idealHumidityDeviation = abs(humidity - idealHumidity)
        if idealHumidityDeviation <= happyHumidityMargin {
            comfortScore += 2
        } else if idealHumidityDeviation <= neutralHumidityMargin {
            comfortScore += 1
        }

        let idealPM2_5Deviation = abs(pm2_5 - idealPM2_5Level)
        if idealPM2_5Deviation <= happyPM2_5Level {
            comfortScore += 2
        } else if idealPM2_5Deviation <= neutralPM2_5Level {
            comfortScore += 1
        }

        switch comfortScore {
        case 5,6:
            currentComfortStatus = .happy
        case 3,4:
            currentComfortStatus = .neutral
        case 0,1,2:
            currentComfortStatus = .bad
        default:
            currentComfortStatus = .neutral
        }
    }
}
