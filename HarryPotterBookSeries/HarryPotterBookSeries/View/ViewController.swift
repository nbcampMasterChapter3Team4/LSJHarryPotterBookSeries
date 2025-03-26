//
//  ViewController.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class ViewController: UIViewController {

    private let viewModel = DataServiceViewModel() // ✅ ViewModel 인스턴스 생성
    private let disposeBag = DisposeBag() // ✅ Rx 메모리 관리용 DisposeBag

    private let bookTitleAndSeries = BookTitleAndSeries()
    private let bookInfoArea = BookInfoArea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        viewModel.loadBooks() // ✅ 데이터 로드
        setupBindings()
    }

    private func setupUI() {
        self.view.addSubview(bookTitleAndSeries)
        self.view.addSubview(bookInfoArea)
        
        bookTitleAndSeries.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        bookInfoArea.snp.makeConstraints { make in
            make.top.equalTo(bookTitleAndSeries.snp.bottom).inset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(5)
        }
    }

    private func setupBindings() {
        viewModel.books
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트는 반드시 메인 스레드에서
        .subscribe(onNext: { [weak self] books in
            guard let self = self else { return }
            
            for (index, book) in books.enumerated() {
                if index == 0 {
                    self.bookTitleAndSeries.configure(index: index, book: book)
                    self.bookInfoArea.configure(index: index, book: book)
                    print(book)
                }
            }
            
        })
            .disposed(by: disposeBag)
    }
}
