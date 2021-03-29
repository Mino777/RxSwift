//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxSwift
import RxCocoa

// 화면 전환을 담당하는 SceneCoordinator
class SceneCoordinator: SceneCoordinatorType {
    private let disposeBag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    // 전환 상태에 따라서 실제 전환처리를 진행하는 메서드, transition
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        // PublishSubject는 초기값을 가지며, 이벤트 발생시마다 최신 Observable을 구독자에게 전달하는 Subject
        let subject = PublishSubject<Void>()
        
        // sceneType에 따른 Scene이 생성되며 target에 할당됨.
        let target = scene.instantiate()
        
        switch style {
        case .root:
            // .root를 선택하면 해당 viewController가 window의 rootViewController로 지정되고, completed 이벤트를 전달.
            // root인 경우 그냥 rootViewController를 바꿔주기만 하면 됨.
            currentVC = target
            window.rootViewController = target
            
            // rootViewController 설정 후, subject는 Completed 이벤트를 전달.
            subject.onCompleted()
        
        case .push:
            // 네비게이션 컨트롤러 임베디드 상태를 확인 후 처리, 만약 임베디드 상태가 아니라면 error 이벤트를 전달하고 중지한다.
            // 네비게이션 컨트롤러가 존재하지 않는다면 error 이벤트를 전달한다.
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            // 만약 네비게이션 컨트롤러가 정상적으로 임베디드 되어 있다면, pushViewController를 수행하고, completed 이벤트를 전달.
            nav.pushViewController(target, animated: animated)
            currentVC = target
            
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target
        }
        
        // ignoreElements : 반환값이 Completable로 변환되어 반환된다.
        // 초반에 정의할 수 도 있지만 그렇게 하면 처리하기 위해 구현하는 코드가 복잡해 지므로 해당 라인에서 사용하여 반환한다.
        return subject.ignoreElements().asCompletable()
    }
    
    // 뷰컨트롤러를 닫는 메서드
    @discardableResult
    func close(animated: Bool) -> Completable {
        // ignoreElements 사용 유무에 따른 차이를 위해 close 메서드에서는 Completable을 사전에 지정하고 사용.
        return Completable.create { [unowned self] completable in
            // 현재 띄워진 뷰 컨트롤러를 확인 후
            if let presentingVC = self.currentVC.presentingViewController {
                // dismiss 가능하면 처리
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
                
                // 현재 viewController의 네비게이션 컨트롤러가 존재한다면,
            } else if let nav = self.currentVC.navigationController {
                // 네비게이션 컨트롤러 스택에 뷰컨트롤러가 있다면 popViewController 메서드를 통해 pop 처리.
                guard nav.popViewController(animated: animated) != nil else {
                    // pop이 불가능하다면, error 이벤트를 실행.
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                // popViewController, dismiss가 둘 다 불가능 한 경우에도 error 이벤트를 전달.
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
