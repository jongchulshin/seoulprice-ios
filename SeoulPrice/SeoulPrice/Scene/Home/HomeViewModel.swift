//
//  HomeViewModel.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/08/10.
//

import RxSwift

protocol HomeViewModelProtocol {
    var activated: Observable<Bool> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    let disposeBag = DisposeBag()
    
    //API Domain
    let apiDomain: APIResponseStore!
    
    //데이터 수신중 인디케이터 표시
    let activated: Observable<Bool>

    init() {
        let activating = BehaviorSubject<Bool>(value: false)
        
        apiDomain = APIResponseStore()
        
        activating.onNext(true)
        
        apiDomain.fetchSeoulPrice()
            .subscribe(onNext: { status in
                print("-----fetchAllSeoulPrice onNext: \(status.percent)-----")
            }, onCompleted:{
                activating.onNext(false)
                print("-----fetchAllSeoulPrice completed-----")
            })
            .disposed(by: disposeBag)
        
        activated = activating.distinctUntilChanged()
    }
    
}
