//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxSwift

// 배열을 변경한 다음, Subject에서 새로운 next 이벤트를 방출하는 패턴으로 구현되는 MemoryStorage
class MemoryStroage: MemoStorageType {
    // 배열은 Observable을 통해 외부로 공개
    // 배열이 새롭게 업데이트 되면 새로운 next 이벤트를 방출해야함. 이때 Observable만으로는 부족. 이를 위해 Subject를 사용
    // 초기값이 존재하는 BehaviorSubject로 구성
    
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Lorem Ipsum", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    // 외부에서는 아래 메서드를 통해 Subject에 접근.
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        // 메모 인스턴스를 생성
        let memo = Memo(content: content)
        
        // 메모의 리스트에 삽입
        list.insert(memo, at: 0)
        
        // behaviorSubject의 새로운 next 이벤트를 방출
        store.onNext(list)
        
        // 새로운 메모를 방출하는 Observable을 방출
        return Observable.just(memo)
    }
    
    // 클래스 외부에서는 항상 memoList() 를 통해 store subject를 접근
    @discardableResult
    func memoList() -> Observable<[Memo]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        // 업데이트 된 메모 인스턴스를 생성
        let updated = Memo(original: memo, updatedContent: content)
        
        // 배열에 저장된 원본 메모 인스턴스에 접근해서 업데이트 된 새로운 인스턴스로 갱신.
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }
        
        // 새롭게 갱신한 메모 상태로 BehaviorSubject, store는 새로운 next 이벤트를 방출
        store.onNext(list)
        
        // update 된 메모를 방출하는 Observable을 방출.
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        // 인자값으로 받은 memo의 인덱스를 찾아 해당 메모를 삭제
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }
        
        // 새롭게 갱신한 메모 상태로 BehaviorSubject, store는 새로운 next 이벤트를 방출
        store.onNext(list)
        
        // 삭제된 메모를 방출하는 Observable을 반환
        return Observable.just(memo)
    }
    
    
}
