//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxSwift

// Scene 처리 타입 정의 프로토콜
protocol SceneCoordinatorType {
    // 새로운 Scene 전환 처리
    // 새로운 Scene을 표시하며, Scene의 애니메이션 플래그, 스타일 등을 전달.
    // Completable: Completable을 통해 화면 전환 완료 후 원하는 작업을 구현할 수 있음.
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    // 현재 Scene을 닫고 이전 Scene 복귀 처리
    // 현재 Scene을 닫고 이전 Scene으로 돌아가는 메서드. 이 메서드는 Completable 반환을 통해 어떤 이벤트가 끝났을 때 수행할 수 있도록 할 수 있음.
    @discardableResult
    func close(animated: Bool) -> Completable
}
