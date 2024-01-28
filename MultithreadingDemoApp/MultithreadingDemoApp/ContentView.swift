//
//  ContentView.swift
//  MultithreadingDemoApp
//
//  Created by Zieba, Michal on 10/28/23.
//

import SwiftUI
import Combine

@MainActor class ComfortLevelState: ObservableObject {
    @Published var comfortLevel: ComfortLevel

    init() {
        self.comfortLevel = ComfortLevel(temperature: 20, humidity: 50, pm2_5: 5)
    }
}

@MainActor struct AirQualityStatusView: View {
    @State var shouldRotate = true
    @StateObject var comfortState: ComfortLevelState = ComfortLevelState()

    private var subscribers: [AnyCancellable] = []

    public let blockingAirQualitySensor = AirQualitySensor()
    public let asyncAirQualitySensor = AsyncAirQualitySensor()
    public let closureAirQualitySensor = ClosureAirQualitySensor()
    public let combineAirQualitySensor = CombineAirQualitySensor()

    var body: some View {
        VStack {
            Text(comfortState.comfortLevel.currentComfortStatus.rawValue)
                .font(.system(size: 200))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .clipped()
                .rotation3DEffect(shouldRotate ? .degrees(0) : .degrees(360), axis: (x: 0, y: 1, z: 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        shouldRotate = false
                    }
                }

            VStack {
                Text(comfortState.comfortLevel.temperatureText)
                Text(comfortState.comfortLevel.humidityText)
                Text(comfortState.comfortLevel.pm2_5Text)
            }
        }
        .onAppear {

            _ = Timer.scheduledTimer(withTimeInterval: Constants.timerLoopTime, repeats: true, block: { _ in
                /*
                combineAirQualitySensor.getAirQualityStatusCombineParallel()
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.main)
                    //.assign(to: \.comfortLevel, on: comfortState)
                    .sink(receiveValue: { comfortLevel in
                        comfortState.comfortLevel = comfortLevel
                    })
                    //.store(in: subscribers)
*/

                // comfortState.comfortLevel = blockingAirQualitySensor.getAirQualityStatusBlocking()


                closureAirQualitySensor.getAirQualityStatusClosureSerial { comfortLevelResult in
                    DispatchQueue.main.async {
                        comfortState.comfortLevel = comfortLevelResult
                    }
                }


/*
                closureAirQualitySensor.getAirQualityStatusClosureParallel { comfortLevelResult in
                    DispatchQueue.main.async {
                        comfortState.comfortLevel = comfortLevelResult
                    }
                }
*/


/*
                 Task { @MainActor in
                     comfortState.comfortLevel = await asyncAirQualitySensor.getAirQualityStatusAsyncSerial()
                 }

*/
/*
                Task { @MainActor in
                    comfortState.comfortLevel = await asyncAirQualitySensor.getAirQualityStatusAsyncParallel()
                }
*/
            })
        }
    }
}
