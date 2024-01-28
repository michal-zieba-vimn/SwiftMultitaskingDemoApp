//
//  ClosureAirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 11/18/23.
//

import Foundation


final class ClosureAirQualitySensor: Sendable {

    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading(completion: @escaping (Double) -> Void) {
        completion(readingsGenerator.generateRandomTemperatureReading())
    }

    private func getHumidityReading(completion: @escaping (Double) -> Void) {
        completion(readingsGenerator.generateRandomHumidityReading())
    }

    private func getPM2_5Reading(completion: @escaping (Double) -> Void) {
        completion(readingsGenerator.generateRandomPM2_5Reading())
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

    func getAirQualityStatusClosureSerial(completion: @escaping @Sendable (ComfortLevel) -> Void) {
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
