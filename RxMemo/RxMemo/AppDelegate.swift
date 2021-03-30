//
//  AppDelegate.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 앱이 실행되면 아래에서 메모리 저장소 및 sceneCoordinator 생성.
//        let storage = MemoryStroage()
        let storage = CoreDataStorage(modelName: "RxMemo")
        let coordinator = SceneCoordinator(window: window!)
        
        // storage, coordinator에 대한 의존성은 listViewModel에 두개의 인스턴스로서 주입되면서 활용.
        // listViewModel은 두개의 인스턴스를 주입하면서 생성.
        let listViewModel = MemoListViewModel(title: "나의 메모", sceneCoordinator: coordinator, storage: storage)
        
        // 새로운 Scene을 생성하고, 연관값으로 viewModel을 저장.
        let listScene = Scene.list(listViewModel)
        
        // transition 타입을 .root로 전달.
        // transition 메서드 내에서 실제 전달할 Scene을 생성.
        coordinator.transition(to: listScene, using: .root, animated: false)
        
        return true
    }
}
