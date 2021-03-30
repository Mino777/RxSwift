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
            .bind(to: listTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        // zip 연산자로 두 멤버가 리턴하는 Observable을 병합
        // 선택 된 메모와 indexPath가 튜플상태로 병합되어 방출
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .do(onNext: { [unowned self] (_, IndexPath) in
                // 선택 된 셀을 다시 선택 해제상태로 복귀
                self.listTableView.deselectRow(at: IndexPath, animated: true)
            }).map { $0.0 } // 선택 된 모델을 detailAction (선택 메모에 맞는 상세화면으로 이동)과 바인딩
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: disposeBag)
        
        listTableView.rx.modelDeleted(Memo.self)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: disposeBag)
    }
}
