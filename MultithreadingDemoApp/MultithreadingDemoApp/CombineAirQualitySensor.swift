//
//  CombineAirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 12/5/23.
//

import Foundation
import Combine

final class CombineAirQualitySensor: Sendable {
    private var currentTemperatureReading = Constants.Temperature.initialTemperature
    private var currentHumidityReading = Constants.Humidity.initialHumidity
    private var currentPM2_5Reading = Constants.PM2_5.initialPM2_5

    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading() -> AnyPublisher<Double, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }
                self.currentTemperatureReading = self.readingsGenerator.generateRandomTemperatureReading(currentTemperature: self.currentTemperatureReading)

                return promise(.success(self.currentTemperatureReading))
            }
        }
        .eraseToAnyPublisher()
    }

    private func getHumidityReading() -> AnyPublisher<Double, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }
                self.currentHumidityReading = self.readingsGenerator.generateRandomHumidityReading(currentHumidity: self.currentHumidityReading)

                return promise(.success(self.currentHumidityReading))
            }
        }
        .eraseToAnyPublisher()
    }

    public func getPM2_5Reading() -> AnyPublisher<Double, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }
                self.currentPM2_5Reading = self.readingsGenerator.generateRandomPM2_5Reading(currentPM2_5: self.currentPM2_5Reading)

                return promise(.success(self.currentPM2_5Reading))
            }
        }
        .eraseToAnyPublisher()
    }

    public func getAirQualityStatusCombineSerial() -> AnyPublisher<ComfortLevel, Never> {
        getTemperatureReading()
            .flatMap { [unowned self] temperature in
                return Publishers.CombineLatest(Just(temperature).eraseToAnyPublisher(), self.getHumidityReading())
            }
            .flatMap { [unowned self] temperature, humidity in
                return Publishers.CombineLatest3(Just(temperature).eraseToAnyPublisher(), Just(humidity).eraseToAnyPublisher(), self.getPM2_5Reading())
            }
            .map { temperature, humidity, pm2_5 in
                print("Completed checks: Temperature \(temperature), Humidity \(humidity), PM2_5 \(pm2_5)")
                return ComfortLevel(temperature: temperature, humidity: humidity, pm2_5: pm2_5)
            }
            .eraseToAnyPublisher()
    }

    public func getAirQualityStatusCombineParallel() -> AnyPublisher<ComfortLevel, Never> {
        Publishers.CombineLatest3(
            getTemperatureReading().subscribe(on: DispatchQueue.global()),
            getHumidityReading().subscribe(on: DispatchQueue.global()),
            getPM2_5Reading().subscribe(on: DispatchQueue.global())
        )
        .map { temperature, humidity, pm2_5 in
            print("Completed checks: Temperature \(temperature), Humidity \(humidity), PM2_5 \(pm2_5)")
            return ComfortLevel(
                temperature: temperature,
                humidity: humidity,
                pm2_5: pm2_5
            )
        }
        .eraseToAnyPublisher()
    }

}
