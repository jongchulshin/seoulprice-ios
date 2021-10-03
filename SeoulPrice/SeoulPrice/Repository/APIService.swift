//
//  APIService.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/09/14.
//

import Foundation
import Alamofire
import RxSwift

enum ErrorCode: Int, Error {
    case notFound = 404
}

class APIService {
    
    struct Response: Decodable {
        var totalCount: Int
        var result: APIResultModel
        var prices: [SeoulPriceModel]
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "list_total_count"
            case result = "RESULT"
            case prices = "row"
        }
    }

    func requestSeoulPriceData(_ url: String) -> Observable<Response> {
        return Observable.create { observer in
            AF.request(url)
                .validate(contentType: ["application/json"])
                .response { response in
                    debugPrint(response)
                    
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ErrorCode.notFound)
                            return
                        }
                        
                        do {
                            let jsonData = try JSONDecoder().decode(Response.self, from: data)
                            observer.onNext(jsonData)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                        
                        break
                    case let .failure(error):
                        print(error)
                        observer.onError(error)
                        
                        break
                    }
                }
            
            return Disposables.create()
        }
    }
    
}
