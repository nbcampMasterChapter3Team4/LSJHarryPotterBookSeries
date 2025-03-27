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
    private let bookDedicationAndSummary = BookDedicationAndSummary()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
        viewModel.loadBooks() // ✅ 데이터 로드
    }

    private func setupUI() {
        self.view.addSubview(bookTitleAndSeries)
        self.view.addSubview(bookInfoArea)
        self.view.addSubview(bookDedicationAndSummary)

        bookTitleAndSeries.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bookInfoArea.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview()
        }

        bookInfoArea.snp.makeConstraints { make in
            make.bottom.equalTo(bookDedicationAndSummary.snp.top).offset(-24)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-5)
        }
        
        bookDedicationAndSummary.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.books
            .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] books in
            guard let self = self else { return }

            for (index, book) in books.enumerated() {
                if index == 0 {
                    self.bookTitleAndSeries.configure(index: index, book: book)
                    self.bookInfoArea.configure(index: index, book: book)
                    self.bookDedicationAndSummary.configure(book: book)
                }
            }
        })
            .disposed(by: disposeBag)
        
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                print("⚠️ Alert 호출됨: \(error.message)") // 디버깅용 로그 추가
                self?.showErrorAlert(message: error.message)
            })
            .disposed(by: disposeBag)

    }
    
    private func showErrorAlert(message: String) {
        print("⚠️ showErrorAlert 실행됨: \(message)") // 디버깅용 로그 추가

        let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
