//
//  Constants.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation

public enum Constants {
    static let timerLoopTime: Double = 30.0
    static let temperatureReadTime: UInt32 = 3
    static let humidityReadTime: UInt32 = 5
    static let pm2_5ReadTime: UInt32 = 10

    public enum Temperature {
        static let initialTemperature: Double = 22.0
        static let minTemperature: Double = 15.0
        static let maxTemperature: Double = 30.0
    }

    public enum Humidity {
        static let initialHumidity: Double = 50.0
        static let minHumidity: Double = 30.0
        static let maxHumidity: Double = 60.0
    }

    public enum PM2_5 {
        static let initialPM2_5: Double = 0.1
        static let minPM2_5: Double = 0.0
        static let maxPM2_5: Double = 50.0
    }
}
