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

/*:
 # Observers
 */

let o1 = Observable<Int>.create { (observer) -> Disposable in
    
   observer.on(.next(0))
    
   observer.onNext(1)
   
   observer.onCompleted()
   
   return Disposables.create()
}

// 중요한 규칙 Observer는 동시에 두개 이상의 이벤트를 처리하지않음.
// Observable은 Observer가 하나의 이벤트를 처리한 후에 이어지는 이벤트를 처리함.
// 여러 이벤트를 동시에 처리하지않음.

// #1
o1.subscribe {
    // subscribe 클로져 내 start가 연달아 end 없이 두번 호출되는 경우는 없다.
    print("-- Start --")
    print($0)
    // 순수 값을 추출하여 출력할 수 있으며, Optional 이므로 Optional Binding 이 필요하다.
    if let elem = $0.element {
        print(elem)
    }
    print("-- End --")
}

print("---------")

// #2
// 세부적인 구독 처리도 가능
// $0.element 같은 방식으로 접근 할 필요 없이 onNext: 클로져 인자값을 통해 element에 바로 접근할 수 있다.
o1.subscribe(onNext: { elem in
    print(elem)
})

Observable.from([1, 2, 3])

















