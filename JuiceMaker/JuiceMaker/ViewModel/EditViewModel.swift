//
//  EditViewModel.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/25.
//

import Foundation
import RxSwift

class EditViewModel {
    private let juiceMaker = JuiceMaker()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let stockChange: PublishSubject<(Fruit, Int)>
    }
    
    struct Output {
        let modifyStockSuccess: BehaviorSubject<Bool>
        let alertMessage: PublishSubject<String?>
    }
    
    func transform(input: Input) -> Output {
        let modifyStockSuccess = BehaviorSubject<Bool>(value: true)
        let alertMessage = PublishSubject<String?>()
        
        input.stockChange
            .subscribe(onNext: { (fruit, quantity) in
                alertMessage.onNext(self.limitStockAlertMessage(quantity))
                self.juiceMaker.modifyFruitStock(for: fruit, newQuantity: quantity)
                    .subscribe(onNext: { result in
                        if result == true {
                            modifyStockSuccess.onNext(true)
                        } else {
                            modifyStockSuccess.onNext(false)
                        }
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        return Output(modifyStockSuccess: modifyStockSuccess, alertMessage: alertMessage)
    }
    
    func fruitStockObservable(of fruit: Fruit) -> Observable<Int> {
        return juiceMaker.fruitStockObservable(of: fruit)
    }
    
    private func limitStockAlertMessage(_ quantity: Int) -> String? {
        var limitAlert: String? = nil
        
        if quantity == FruitRepository.maximumStock {
            limitAlert = ModifyStockAlert.maximumStock.message
        } else if quantity == .zero {
            limitAlert = ModifyStockAlert.minimumStock.message
        }
        
        return limitAlert
    }
}
