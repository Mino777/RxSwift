//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

let subscription1 = Observable.from([1, 2, 3])
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

subscription1.dispose()


var disposeBag = DisposeBag()

// Disposed 는 옵저버가 전달 하는 이벤트가 아니다.
// -> 리소스가 해제되는 시점에 자동으로 호출되는 것이 Disposed이다.
// 하지만 Rxswift 공식 문서에서는 Disposed를 정리/명시해줄 것을 권고한다.
Observable.from([1, 2, 3])
    .subscribe {
        print($0)
    }.disposed(by: disposeBag)
// - 위와 같이 disposed(by: Bag) 식으로 DisposeBag을 사용할 수 있다.
// - 해당 subscription에서 반환되는 Disposable은 bag에 추가된다.
// - 이렇게 추가된 Disposable 들은 Disposebag이 해제되는 시점에 함께 해제된다.

// 새로운 DisposeBag으로 초기화하면 이전까지 담겨있던 Disposable들은 함께 해제된다.
disposeBag = DisposeBag()


// 1씩 증가하는 정수를 1초간격으로 출력하는 Observable
// 해당 작업의 종료를 위해서는 Dispose 처리가 필요하다.
let subscription2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { elem in
        // Emission
        // Next 1 ~ 3이 출력
        print("Next", elem)
    }, onError: { error in
        // Notification
        print("Error", error)
    }, onCompleted: {
        // Notification
        // Observable 완료 시 실행
        print("Completed")
        // Disposed는 Observable이 전달하는 이벤트는 아니다. Observable과 관련된 모든 리소스가 제거된 뒤 호출이 된다.
    }, onDisposed: {
        print("Disposed")
    })

// Disposable 의 dispose() 메서드를 통해 3초가 지나면 해당 Observable을 Dispose 처리한다.
// 해당 기능은 take, until등의 Operator 등을 통해서도 구현할 수 있다.
// 0, 1, 2 까지만 출력
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
    // 이경우에도 연산자를 활용해서 처리해주는 것이 좋음.
}

// 직접 dispose를 호출해주는건 권장되지 않음.
// DisposeBag 으로 관리해주는것이 가장 좋음.





