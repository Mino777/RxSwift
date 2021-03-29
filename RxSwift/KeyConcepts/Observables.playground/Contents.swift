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

/*
 Observable
 
 - Observable은 이벤트를 전달.
 - Next: 방출, Emission (Observer, Subscriber로 전달)
 - Error: 에러 발생시 전달, Observable 주기 끝에 실행, Notification
 - Completed: 성공적으로 실행 시 전달, Observable 주기 끝에 실행, Notification
 - Observable은 error, completed 이벤트를 전달한 뒤엔 더이상 이벤트를 전달하지 않는다.
 - Observable을 영원히 실행할 목적이 아니라면, onError, onComleted 둘 중 하나는 꼭 처리해주어야 함.
 
 Observer
 - Observer를 Subscriber라고도 부름.
 - Observable을 감시하고 있다가 전달되는 이벤트를 처리한다.
 - 이때 observable을 감사히고 있는 것을 Subscribe라고 한다.
 
 */

// Observable 를 생성, 정의하는 방법 크게 두가지
// #1 create 연산자 활용
// create : Observable 타입 프로토콜에 선언되어있는 타입 메서드, Operator 라고도 한다.
// - Observer를 인자로 받아 Disposable을 반환한다.
Observable<Int>.create { (observer) -> Disposable in
    // observer애서 on 메서드를 호출하고, 구독자로 0이 저장되어있는 next 이벤트가 전달된다.
    observer.onNext(0)
    // 1이 저장되어있는 next 이벤트가 전달된다.
    observer.onNext(1)
    // completed이벤트가 전달되고 Observable이 종료된다. 이후 다른 이벤트를 전달할 수는 없다.
    observer.onCompleted()
    // Disposables 는 메모리 정리에 필요한 객체이다.
    return Disposables.create()
}


// #2 다른 여러가지 연산자 활용
// from 연산자는 파라미터로 전달받은 값을 순서대로 방출하고 Completed Event를 전달하는 Observable을 생성한다.
// 이처럼 create 이외로도 상황에 따른 다양한 Operator 사용이 가능하다.
Observable.from([0, 1])
// 이벤트 전달 시점은 Observer가 Observalbe을 구독하는 시점에 Next이벤트를 통해 방출 및 Completed 이벤트가 전달된다.






