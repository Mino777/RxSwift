//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    let memo: Memo
    let disposeBag = DisposeBag()
    
    private var formatter: DateFormatter = {
        let format = DateFormatter()
        format.locale = Locale(identifier: "Ko_kr")
        format.dateStyle = .medium
        format.timeStyle = .medium
        return format
    }()
    
    // 왜 기본 옵저버블이 아닌 BehaviorSubject 인가?
    // 메모보기 이후 편집된 메모를 저장하고 보기화면으로 왔을 때의 새로운 문자열 배열을 방출할 수 있도록 BehaviorSubject를 사용
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            // 입력 값으로 메모를 업데이트
            // 반환형을 보면 출력타입이 리턴형으로 void를 선언하고 있음.
            // .map { _ in } 으로 Observable<Void> 형으로 변환할 수 있음.
             self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { updated in
                    self.contents.onNext([
                        updated.content,
                        self.formatter.string(from: updated.insertDate)
                    ])
                }).disposed(by: self.disposeBag)
            
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }
}
