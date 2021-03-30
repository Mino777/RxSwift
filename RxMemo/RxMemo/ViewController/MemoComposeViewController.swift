//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import UIKit
import RxSwift
import RxCocoa
import Action

// Rx-MVVM 패턴을 구현할 때에는 뷰모델을 뷰컨트롤러의 속성으로 추가한다.
// 그 후 뷰모델과 뷰를 binding 한다.
class MemoComposeViewController: UIViewController ,ViewModelBindableType {
    
    var viewModel: MemoComposeViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        // navigation title 바인딩
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // initialText를 textView에 바인딩
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        // 취소버튼은 cancelAction과 바인딩
        // action 패턴으로 action 구현시는 아래와 같이 action 속성(CocoaAtion)에 저장하는 방식으로 바인딩해서 처리할 수 있음.
        cancelButton.rx.action = viewModel.cancelAction
        
        // doubleTap을 막기위해 throttle 연산자 활용
        saveButton.rx.tap
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
