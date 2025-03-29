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

    private let bookTitleAndSeries = BookTitleAndSeriesView()
    private let bookInfoArea = BookInfoView()
    private let bookDedicationAndSummary = BookDedicationAndSummaryView()
    private let bookChaptersArea = BookChaptersView()

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false // ✅ 스크롤 바 숨김
    }
    
    private let contentView = UIView() // ✅ scrollView 내부 컨텐츠 뷰

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
        viewModel.loadBooks() // ✅ 데이터 로드
    }


    private func setupUI() {
        self.view.addSubview(bookTitleAndSeries)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(bookInfoArea)
        contentView.addSubview(bookDedicationAndSummary)
        contentView.addSubview(bookChaptersArea)
        
        bookTitleAndSeries.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(bookTitleAndSeries.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        bookInfoArea.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-5)
        }
        
        bookDedicationAndSummary.snp.makeConstraints { make in
            make.top.equalTo(bookInfoArea.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        bookChaptersArea.snp.makeConstraints { make in
            make.top.equalTo(bookDedicationAndSummary.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
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
                    self.bookChaptersArea.configure(book: book.chapters.map { $0.title })
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
