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
 # Operators
 */

let bag = DisposeBag()

// Operator 중 하나인 take(n)은 Observable이 방출하는 요소 중에서 처음부터 N개의 요소만 전달해주는 연산자이다.
// Operator 중 하나인 filter는 특정 요건을 충족한 요소만 필터링하여 전달해주는 연산자이다.
// 아래 코드는 take(N), filter Operator를 사용하여 1~5번째 까지의 요소 중 2의 배수만 필터링하여 전달해주는 과정이다.
Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
    .take(5)
    .filter { $0.isMultiple(of: 2) }
    .subscribe { print($0) }
    .disposed(by: bag)

// 위에서 사용한 take, filter 연산자 처럼 연산자를 필요에 따라 붙여서 다수 사용이 가능하다.
// 단, 연산자의 실행 순서에 따라 결과가 달라질 수 있음에 주의해야 한다.
























