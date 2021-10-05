//
//  APIResponseStore.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/09/14.
//

import RxSwift

struct FetchStatus {
    var percent: UInt
    var isCompleted: Bool
}

class APIResponseStore {
    
    func fetchSeoulPrice() -> Observable<FetchStatus> {
        return Observable.create { observer in
            
            
            return Disposables.create()
        }
    }
    
}
