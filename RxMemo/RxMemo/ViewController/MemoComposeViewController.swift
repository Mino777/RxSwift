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
        
        // 키보드가 나타나고 없어질 예정일 때마다 새로운 next 이벤트를 방출하는 Observable을 리턴.
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        // 두개의 Observable이 전달되는 시점마다 하나의 Observable에서 next 이벤트가 전달됨.
        // 모든 구독자가 Observable을 공유하도록 share()를 추가 설정.
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable).share()
        
        // keyboardObservable의 새로운 구독자를 추가하고, textView의 여백과 scroll inset을 조절
        keyboardObservable
//            .map { [unowned self] height -> UIEdgeInsets in
//                var inset = self.contentTextView.contentInset
//                inset.bottom = height
//                return inset
//            }
            .toContentInset(of: contentTextView)
//            .subscribe(onNext: { [weak self] height in
//                guard let strongSelf = self else { return }
//
//                var inset = strongSelf.contentTextView.contentInset
//                inset.bottom = height
//
//                var scrollInset = strongSelf.contentTextView.scrollIndicatorInsets
//                scrollInset.bottom = height
//
//                UIView.animate(withDuration: 0.3) {
//                    strongSelf.contentTextView.contentInset = inset
//                    strongSelf.contentTextView.scrollIndicatorInsets = scrollInset
//                }
//            })
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: disposeBag)
        
        keyboardObservable
            .toScrollInset(of: contentTextView)
            .bind(to: contentTextView.rx.scrollInset)
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

// CGFloat를 방출하는 ObservableType에 대한 커스텀 extension을 정의.
extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
    
    func toScrollInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.scrollIndicatorInsets
            inset.bottom = height
            return inset
        }
    }
}

extension Reactive where Base: UITextView {
    var contentInset: Binder<UIEdgeInsets> {
        return Binder(self.base) { textview, inset in
            textview.contentInset = inset
        }
    }
    
    var scrollInset: Binder<UIEdgeInsets> {
        return Binder(self.base) { textview, inset in
            textview.scrollIndicatorInsets = inset
        }
    }
}
