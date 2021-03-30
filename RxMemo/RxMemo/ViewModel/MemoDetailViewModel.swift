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
}
