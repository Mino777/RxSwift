//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            // 입력 값으로 메모를 업데이트
            // 반환형을 보면 출력타입이 리턴형으로 void를 선언하고 있음.
            // .map { _ in } 으로 Observable<Void> 형으로 변환할 수 있음.
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            // 메모가 생성 된 후, 저장하지 않고 취소시에 별도의 처리를 하지 않으면 불필요한 내용이 테이블뷰에 저장될 수 있어 이에 대한 처리가 필요.
            // 생성된 메모를 삭제. createMemo를 호출하면 메모가 생성되는데 이를 삭제하지 않으면 불필요한 메모가 저장될 수 있음.
            // createMemo를 통해 내용 없는 메모를 생성, 저장이 되면 입력된 메모로 업데이트하는 방식.
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    
    // 메모를 방출하는 Observable이 반환.
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            // 이렇게 createMemo를 호출하면 새로운 메모가 생성되고, 이 메모를 방출하는 옵저버블이 반환.
            return self.storage.createMemo(content: "") // 이어서 flatMap 연산자를 호출하고 클로저에서 화면전환을 처리.
                .flatMap { memo -> Observable<Void> in
                    // CocoaAction의 composeViewModel에서 memo가 생성될 때 인자값으로 넘김.
                    // 뷰모델을 만들어주고, title은 바로 문자열을 전달하면 되고, SceneCoordinator와 storage에 대한 의존성은 현재 ViewModel에 있는 속성으로 바로 주입할 수 있음.
                    let composeViewModel = MemoComposeViewModel(title: "새 메모",
                                                                sceneCoordinator: self.sceneCoordinator,
                                                                storage: self.storage,
                                                                saveAction: self.performUpdate(memo: memo),
                                                                cancelAction: self.performCancel(memo: memo))
                    
                    // composeScene을 생성하고 연관값으로 viewModel을 저장.
                    let composeScene = Scene.compose(composeViewModel)
                    // 마지막으로 sceneCoordinator에서 comoseScene으로 modal방식으로 전환.
                    // transition 메서드는 completable을 반환. 이를 Void 형식의 observable<Void>로 변환 후 리턴.
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
                }
        }
    }
}
