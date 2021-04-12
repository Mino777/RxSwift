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
 # ReplaySubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let rs = ReplaySubject<Int>.create(bufferSize: 3)

(1...10).forEach { rs.onNext($0) }

rs.subscribe { print("Observer 1 >>", $0) }
    .disposed(by: disposeBag)
// 8 9 10

rs.subscribe { print("Observer 2 >>", $0) }
    .disposed(by: disposeBag)
// 8 9 10

rs.onNext(11)

rs.subscribe { print("Observer 3 >>", $0) }
    .disposed(by: disposeBag)
// 9 10 11

//rs.onCompleted()
rs.onError(MyError.error)

rs.subscribe { print("Observer 4 >>", $0) }
    .disposed(by: disposeBag)
