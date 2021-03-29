//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import UIKit


// Rx-MVVM 패턴을 구현할 때에는 뷰모델을 뷰컨트롤러의 속성으로 추가한다.
// 그 후 뷰모델과 뷰를 binding 한다.
class MemoComposeViewController: UIViewController ,ViewModelBindableType {
    
    var viewModel: MemoComposeViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        
    }

}
