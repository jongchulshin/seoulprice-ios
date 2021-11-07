//
//  APIResponseStore.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/09/14.
//

import Foundation
import RxSwift
import RxCocoa

struct UpdateStatus {
    var isUpdated: Bool
}

struct FetchStatus {
    var percent: UInt
}

protocol APIResponseStoreProtocol {
    func checkUpdate() -> Observable<UpdateStatus>
    func fetchSeoulPrice() -> Observable<FetchStatus>
}

class APIResponseStore: APIResponseStoreProtocol {
    let disposeBag = DisposeBag()
    
    //API 수신 데이터 임시 저장 배열
    private var responseList: [SeoulPriceModel] = []
    
    //API 요청 시작 항목 번호
    private var begin: Int = 1
    
    //1건만 요청하여 갱신 상태 확인
    func checkUpdate() -> Observable<UpdateStatus> {
        print("checkUpdate")
        return Observable.create { observer in
            APIService.requestSeoulPriceData(from: 1, to: 1)
                .subscribe(onNext: { response in
                    print("-----onNext-----")
                }, onError: { error in
                    print(error)
                }, onCompleted: {
                    print("-----completed-----")
                }, onDisposed: {
                    print("-----disposed-----")
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    //필요한 데이터 전부 요청
    func fetchSeoulPrice() -> Observable<FetchStatus> {
        print("fetchSeoulPrice")
        self.begin = 1
        let userDefaults = UserDefaults.standard
        let latestData = userDefaults.object(forKey: "KEY_LATEST_SEOUL_PRICE_DATA") as? [String:String] ?? [:]
        
        return Observable.create { observer in
            self.fetchAllSeoulPrice(latestData["DataID"], latestData["RegistrationDate"], observer)
            
            return Disposables.create()
        }
    }
    
    //private: 필요한 데이터 전부 요청
    func fetchAllSeoulPrice(_ dataId: String?, _ registrationDate: String?, _ observer: AnyObserver<FetchStatus>) {
        print("fetchAllSeoulPrice")
        
        _ = APIService.requestSeoulPriceData(from: self.begin, to: self.begin + 999)
            .subscribe(onNext: { response in
                print("-----requestSeoulPriceData onNext-----")
                self.begin += 1000
                
                let prices: [SeoulPriceModel] = response.apiResponse.prices
                var stop: Bool = false
                
                if let latestDataId = dataId, latestDataId.count > 0 {
                    //서울물가 데이터 수신 이력이 있는 경우
                    if let latestDataIdIntValue = Int(latestDataId) {
                        //TODO: DB의 가장 최신 데이터가 앱에 보존해야할 데이터 범위 내에 있으면 해당 데이터의 [일련번호]가
                        //각 API 응답(1000건 중) 마지막 데이터의 [일련번호]보다 커질 때까지 반복 요청.
                        //DB의 가장 최신 데이터가 앱에 보존할 데이터 범위 밖에 있으면 최초 요청시와 같이 [데이터 등록 날짜]를 이용하여 반복 요청.
                        let lastDataId: String = String(prices[prices.endIndex - 1].dataId)
                    }
                } else {
                    //서울물가 데이터를 처음 수신한 경우
                    for (index, value) in prices.enumerated() {
                        //참고: registrationDate 포맷 [2021-09-30]
                        //TODO: 현재 날짜의 6개월 이내의 데이터가 1000건 안에 없으면 stop
                    }
                }
                
                //TODO: 1000개의 데이터 내에 최근 업데이트시의 [데이터 등록날짜] 이전의 등록날짜만 존재하면 중지 -> ㄴㄴ 데이터 ID로 하면 될듯
                if stop {
                    observer.onCompleted()
                } else {
                    self.fetchAllSeoulPrice(dataId, registrationDate, observer)
                }
            }, onError: { error in
                print(error)
                observer.onError(error)
            }, onCompleted: {
                print("-----requestSeoulPriceData completed-----")
            }, onDisposed: {
                print("-----requestSeoulPriceData disposed-----")
            })
    }
    
}
