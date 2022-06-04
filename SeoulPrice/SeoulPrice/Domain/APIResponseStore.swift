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
    
    //날짜 변환기
    private let dateFormatter: DateFormatter
    
    //현재 날짜(yyyy-MM-dd)
    private let now: String
    
    init() {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "yyyy-MM-dd"
        self.dateFormatter = df
        self.now = df.string(from: Date())
    }
    
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
        self.responseList.removeAll()
        let userDefaults = UserDefaults.standard
        let latestData = userDefaults.object(forKey: "KEY_LATEST_SEOUL_PRICE_DATA") as? [String:String] ?? [:]
        
        print("DB 데이터 수: " + DBManager.shared.getAllSeoulPrice().count.description)
        
        return Observable.create { observer in
            self.fetchAllSeoulPrice(latestData["DataID"], latestData["RegistrationDate"], observer)
            
            return Disposables.create()
        }
    }
    
    //MARK: Private
    //필요한 데이터 전부 요청
    func fetchAllSeoulPrice(_ dataId: String?, _ registrationDate: String?, _ observer: AnyObserver<FetchStatus>) {
        print("fetchAllSeoulPrice")
        
        _ = APIService.requestSeoulPriceData(from: self.begin, to: self.begin + 999)
            .subscribe(onNext: { response in
                print("-----requestSeoulPriceData onNext-----")
                self.begin += 1000
                
                let prices: [SeoulPriceModel] = response.apiResponse.prices
                self.responseList.append(contentsOf: prices)
                var stop: Bool = true
                
                if let latestDataId = Int(dataId ?? "0"), latestDataId > 0,
                   let latestRegistrationDate = registrationDate {
                    //서울물가 데이터 수신 이력이 있는 경우
                    let date = self.dateFormatter.date(from: latestRegistrationDate)
                    
                    if self.isInValidatePeriod(from: date) {
                        //DB의 가장 최신 데이터가 앱에 보존해야할 유효 기간 내의 데이터인 경우
                        //해당 데이터의 [일련번호]가 각 API 응답(1000건 중) 마지막 데이터의 [일련번호]보다 커질 때까지 반복 요청
                        let lastDataId: Int = prices[prices.endIndex - 1].dataId
                        stop = (latestDataId >= lastDataId) ? true : false
                    } else {
                        //DB의 가장 최신 데이터가 앱에 보존할 기간 범위 밖의 데이터인 경우
                        //최초 요청시와 같이 [데이터 등록 날짜]를 이용하여 반복 요청
                        for (index, value) in prices.enumerated() {
                            //현재 날짜부터 유효 기간 내의 데이터가 1000건 안에 없으면 stop
                            let date = self.dateFormatter.date(from: value.registrationDate)
                            if self.isInValidatePeriod(from: date) {
                                stop = false
                            }
                            if index == 999 {
                                print("데이터 등록 날짜: " + value.registrationDate)
                            }
                        }
                    }
                } else {
                    //서울물가 데이터를 처음 수신한 경우
                    for (index, value) in prices.enumerated() {
                        //현재 날짜부터 유효 기간 내의 데이터가 1000건 안에 없으면 stop
                        let date = self.dateFormatter.date(from: value.registrationDate)
                        if self.isInValidatePeriod(from: date) {
                            stop = false
                        }
                        if index == 999 {
                            print("데이터 등록 날짜: " + value.registrationDate)
                        }
                    }
                }
                
                if stop {
                    print("DB 추가 데이터 수: " + self.responseList.count.description)
                    DBManager.shared.addOrUpdate(self.responseList)
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
    
    //유효 기간 내인지 체크
    func isInValidatePeriod(from target: Date?) -> Bool {
        guard let date = target else {
            return false
        }
        
        let now = self.dateFormatter.date(from: self.now)!
        let components = Calendar.current.dateComponents([.day], from: now)
        let targetPeriod = 62 + components.day! //('2개월 + 현재 날짜'를 유효 기간으로 설정)
        let timeInterval = now.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        
        let devideByTargetPeriod: Int = Int(timeInterval / Double((86400 * targetPeriod))) //(1일 = 86400초)
        if devideByTargetPeriod < 1 {
            //유효 기간 내
            return true
        } else {
            //유효 기간 외
            return false
        }
    }
}
