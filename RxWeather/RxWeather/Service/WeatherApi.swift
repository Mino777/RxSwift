//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import NSObject_Rx


class OpenWeatherMapApi: NSObject, WeatherApiType {
    // 현재 날씨 방출, UI Binding에 활용되기 때문에 BehaviorRelay로 선언
    private let summaryRelay = BehaviorRelay<WeatherDataType?>(value: nil)
    
    private let forecastRelay = BehaviorRelay<[WeatherDataType]>(value: [])
    
    // Network 속성
    private let urlSession = URLSession.shared
    
    // 현재 날씨 가져오기
    private func fetchSummary(location: CLLocation) -> Observable<WeatherDataType?> {
        let request = composeUrlRequest(endpoint: summaryEndpoint, from: location)
        
        return urlSession.rx.data(request: request)
            .map { data -> WeatherSummary in
                let decoder = JSONDecoder()
                return try decoder.decode(WeatherSummary.self, from: data)
            }
            .map { WeatherData(summary: $0) }
            .catchErrorJustReturn(nil)
    }
    
    // 예보 데이터
    private func fetchForecast(location: CLLocation) -> Observable<[WeatherDataType]> {
        let request = composeUrlRequest(endpoint: forecastEndpoint, from: location)
        
        return urlSession.rx.data(request: request)
            .map { data -> [WeatherData] in
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(Forecast.self, from: data)
                
                return forecast.list.map(WeatherData.init)
            }
            .catchErrorJustReturn([])
    }
    
    @discardableResult
    func fetch(location: CLLocation) -> Observable<(WeatherDataType?, [WeatherDataType])> {
        let summary = fetchSummary(location: location)
        let forecast = fetchForecast(location: location)
        
        Observable.zip(summary, forecast)
            .subscribe(onNext: { [weak self] result in
                self?.summaryRelay.accept(result.0)
                self?.forecastRelay.accept(result.1)
            }).disposed(by: rx.disposeBag)
        
        return Observable.combineLatest(summaryRelay.asObservable(), forecastRelay.asObservable())
    }
}
