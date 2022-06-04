//
//  HomeViewModel.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/08/10.
//

import RxSwift

class HomeViewModel {
    
    //API Domain
    var apiDomain: APIResponseStore!

    init() {
        self.apiDomain = APIResponseStore()
        _ = apiDomain.fetchSeoulPrice()
            .subscribe(onNext: { percent in
                print("-----fetchAllSeoulPrice onNext-----")
            }, onCompleted:{
                print("-----fetchAllSeoulPrice completed-----")
            })
    }
    
}
