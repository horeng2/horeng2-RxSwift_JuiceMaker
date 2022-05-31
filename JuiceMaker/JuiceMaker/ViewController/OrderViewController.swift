//
//  ViewController.swift
//  JuiceMaker
//
//  Created by 서녕 on 2022/05/16.
//

import UIKit
import RxSwift
import RxCocoa

class OrderViewController: UIViewController {
    @IBOutlet weak var strawberryStockLabel: UILabel!
    @IBOutlet weak var bananaStockLabel: UILabel!
    @IBOutlet weak var pineappleStockLabel: UILabel!
    @IBOutlet weak var kiwiStockLabel: UILabel!
    @IBOutlet weak var mangoStockLabel: UILabel!
    
    private let orderViewModel = OrderViewModel()
    private lazy var input = OrderViewModel.Input(orderJuice: PublishSubject<Juice>())
    private lazy var output = orderViewModel.transform(input: input)

    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.binding()
    }
    
    private func binding() {
        var input = OrderViewModel.Input(orderJuice: PublishSubject<Juice>())
        var output = orderViewModel.transform(input: input)

        
        
        self.output.orderSuccess
            .subscribe(onNext: { _ in
                Fruit.allCases.forEach { fruit in
                    self.updateStockLabel(of: fruit)
                }
            }).disposed(by: disposeBag)
        self.output.resultMessage
            .subscribe(onNext: { message in
                self.showAlert(title: "주문 결과", message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateStockLabel(of fruit: Fruit) {
        let updateTarget: UILabel = {
            switch fruit {
            case .strawberry:
                return self.strawberryStockLabel
            case .banana:
                return self.bananaStockLabel
            case .pineapple:
                return self.pineappleStockLabel
            case .kiwi:
                return self.kiwiStockLabel
            case .mango:
                return self.mangoStockLabel
            }
        }()
        
        orderViewModel.fruitStockObservable(of: fruit)
            .map{ String($0) }
            .subscribe(onNext: { stock in
                updateTarget.text = stock
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func orderOfStrawberryBananaJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.strawberryBananaJuice)
    }
    
    @IBAction func orderOfMangoKiwiJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.mangoKiwiJuice)
    }
    
    @IBAction func orderOStrawberryJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.strawberryJuice)
    }
    
    @IBAction func orderOfBananaJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.bananaJuice)
    }
    
    @IBAction func orderOfPineappleJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.pineappleJuice)
    }
    
    @IBAction func orderOfKiwiJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.kiwiJuice)
    }
    
    @IBAction func orderOfMangoJuice(_ sender: Any) {
        self.input.orderJuice.onNext(.mangoJuice)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    
    @IBAction func moveToEditViewController(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "EditViewController") else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



