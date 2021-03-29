//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

// viewController에 추가 된 뷰모델 속성의 실제 viewModel을 저장 후 bind() 뷰모델 메서드를 자동으로 호출하는 메서드를 구현.
// 이와 같이 하면 개별적인 VC 에서 일일히 bindViewModel 메서드를 호출할 필요가 없어져 코드가 보다 간결해짐.
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}

