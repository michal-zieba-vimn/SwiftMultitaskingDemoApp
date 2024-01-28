//
//  CombineAirQualitySensor.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 12/5/23.
//

import Foundation
import Combine

final class CombineAirQualitySensor: Sendable {
    private let readingsGenerator: ReadingsGenerating

    init(readingsGenerator: ReadingsGenerating = ReadingsGenerator()) {
        self.readingsGenerator = readingsGenerator
    }

    private func getTemperatureReading() -> AnyPublisher<Double, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }


                return promise(.success(self.readingsGenerator.generateRandomTemperatureReading()))
            }
        }
        .eraseToAnyPublisher()
    }

    private func getHumidityReading() -> AnyPublisher<Double, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }

                return promise(.success(self.readingsGenerator.generateRandomHumidityReading()))
            }
        }
        .eraseToAnyPublisher()
    }

    public func getPM2_5Reading() -> AnyPublisher<Double, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }

                return promise(.success(self.readingsGenerator.generateRandomPM2_5Reading()))
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
