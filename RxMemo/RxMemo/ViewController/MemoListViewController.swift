//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import UIKit
import RxSwift
import RxCocoa

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoListViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var listTableView: UITableView!
    // Rx에서는 RxCocoa가 추가한 Tap 속성을 구독하거나, Action 속성에 Action을 직접 할당하는 방식으로 진행.
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // viewModel 과 view를 바인딩
    func bindViewModel() {
        // viewModel에 표시된 title이 표시.
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // 메모정보를 방출하는 Observable과 tableView를 바인딩.
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
                
            }.disposed(by: disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
    }
}
