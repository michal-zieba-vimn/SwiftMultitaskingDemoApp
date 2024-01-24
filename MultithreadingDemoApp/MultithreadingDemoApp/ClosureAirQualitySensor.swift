//
//  ClosureAirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation

actor ClosureAirQualityStateActor {
    var temperature: Double = 0.0
    var humidity: Double = 0.0
    var pm2_5: Double = 0.0

    func setTemperature(_ temperature: Double) {
        self.temperature = temperature
    }

    func setHumidity(_ humidity: Double) {
        self.humidity = humidity
    }

    func setPM2_5(_ pm2_5: Double) {
        self.pm2_5 = pm2_5
    }
}

final class ClosureAirQualitySensor: Sendable {

    private var currentTemperatureReading = Constants.Temperature.initialTemperature
    private var currentHumidityReading = Constants.Humidity.initialHumidity
    private var currentPM2_5Reading = Constants.PM2_5.initialPM2_5

    private let readingsGenerator: ReadingsGenerating
    private let airQualityStateActor = ClosureAirQualityStateActor()

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading(completion: @escaping (Double) -> Void) {
        currentTemperatureReading = readingsGenerator.generateRandomTemperatureReading(currentTemperature: currentTemperatureReading)

        completion(currentTemperatureReading)
    }

    private func getHumidityReading(completion: @escaping (Double) -> Void) {
        currentHumidityReading =         readingsGenerator.generateRandomHumidityReading(currentHumidity: currentHumidityReading)

        completion(currentHumidityReading)
    }

    private func getPM2_5Reading(completion: @escaping (Double) -> Void) {
        currentPM2_5Reading =         readingsGenerator.generateRandomPM2_5Reading(currentPM2_5: currentPM2_5Reading)

        completion(currentPM2_5Reading)
    }

    func getAirQualityStatusClosureParallel(completion: @escaping (ComfortLevel) -> Void) {
        let dispatchGroup = DispatchGroup()

        var temperature: Double = 0.0
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getTemperatureReading { temperatureReading in
                temperature = temperatureReading
                dispatchGroup.leave()
            }
        }

        var humidity: Double = 0.0
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async{ [weak self] in
            self?.getHumidityReading { humidityReading in
                humidity = humidityReading
                dispatchGroup.leave()
            }
        }

        var pm2_5: Double = 0.0
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getPM2_5Reading { pm2_5Reading in
                pm2_5 = pm2_5Reading
                dispatchGroup.leave()
            }
        }


        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Completed checks: Temperature \(temperature), Humidity \(humidity), PM2_5 \(pm2_5)")
            let comfortStatus = ComfortLevel(temperature: temperature, humidity: humidity, pm2_5: pm2_5)
            completion(comfortStatus)
        }
    }

    func getAirQualityStatusClosureSerial(completion: @escaping (ComfortLevel) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getTemperatureReading { temperatureReading in
                self?.getHumidityReading { humidityReading in
                    self?.getPM2_5Reading { pm2_5Reading in
                        print("Completed checks: Temperature \(temperatureReading), Humidity \(humidityReading), PM2_5 \(pm2_5Reading)")
                        let comfortStatus = ComfortLevel(temperature: temperatureReading, humidity: humidityReading, pm2_5: pm2_5Reading)
                        completion(comfortStatus)
                    }
                }
            }
        }
    }
}
