//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/30.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    // 네비게이션 타이틀로 사용
    let title: Driver<String>
    
    // 프로토콜을 활용하면 의존성을 쉽게 수정할 수 있음.
    // 아래와 같이 프로토콜 타입으로 선언하면 의존성을 쉽게 다룰 수 있음.
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    // 속성을 초기화하는 생성자 추가
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
