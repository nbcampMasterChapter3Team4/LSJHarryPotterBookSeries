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

    private let bookTitleView = BookTitleView()
    private let bookSeriesView = BookSeriesView()
    private let bookInfoView = BookInfoView()
    private let bookDedicationAndSummaryView = BookDedicationAndSummaryView()
    private let bookChaptersView = BookChaptersView()

    private var books: [Attributes] = []

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false // ✅ 스크롤 바 숨김
    }

    private let contentView = UIView() // ✅ scrollView 내부 컨텐츠 뷰

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bookSeriesView.delegate = self
        setupUI()
        setupBindings()
        viewModel.loadBooks() // ✅ 데이터 로드
    }
}

extension ViewController {

    private func setupUI() {
        self.view.addSubview(bookTitleView)
        self.view.addSubview(bookSeriesView)
        self.view.addSubview(scrollView)


        scrollView.addSubview(contentView)
        contentView.addSubview(bookInfoView)
        contentView.addSubview(bookDedicationAndSummaryView)
        contentView.addSubview(bookChaptersView)

        bookTitleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        bookSeriesView.snp.makeConstraints { make in
            make.top.equalTo(bookTitleView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(bookSeriesView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        bookInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-5)
        }

        bookDedicationAndSummaryView.snp.makeConstraints { make in
            make.top.equalTo(bookInfoView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        bookChaptersView.snp.makeConstraints { make in
            make.top.equalTo(bookDedicationAndSummaryView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }

}

extension ViewController {

    private func setupBindings() {
        viewModel.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
            guard let self = self else { return }
            self.books = books

            self.bookSeriesView.configure(books: books)
            if let firstBook = books.first {
                self.updateViewController(with: firstBook, index: 0)
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

    private func updateViewController(with book: Attributes, index: Int) {
        self.bookTitleView.configure(book: book)
        self.bookInfoView.configure(index: index, book: book)
        self.bookDedicationAndSummaryView.configure(book: book)
        self.bookChaptersView.configure(book: book.chapters.map { $0.title })
    }
}


extension ViewController: BookSeriesViewDelegate {
    func bookSeriesView(_ view: BookSeriesView, didSelectButtonAt index: Int) {
        let selectedBookInfo = books[index]
        updateViewController(with: selectedBookInfo, index: index)
    }
}
