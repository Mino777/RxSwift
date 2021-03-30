//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoComposeViewModel: CommonViewModel {
    private let content: String?
    
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        
        self.content = content
        
        self.saveAction = Action<String, Void> { input in
            // 액션이 전달되었으면 실제로 해당 액션을 실행하고 화면을 닫음.
            if let action = saveAction {
                action.execute(input)
            }
            
            // 액션이 전달되지 않았다면 그냥 화면만 닫음.
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            // 실제 액션 전달과 관계없이 항상 sceneCoordinator에서 close 메서드를 호출
            // 따라서 close 메서드는 cancel 메서드를 따로 구현할 필요가 없음.
            // 그래서 편집에서는 cancel 메서드를 따로 구현할 필요가 없음.
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        // viewModel에서 취소, 저장코드를 직접 구현해도 되지만, 파라미터로 받으면 동적으로 처리방식을 구성할 수 있다는 장점이 있음.
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
