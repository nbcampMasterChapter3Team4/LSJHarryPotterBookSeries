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
    
    // MARK: - Properties
    private let viewModel = DataServiceViewModel()
    private let disposeBag = DisposeBag()
    
    private let bookTitleView = BookTitleView()
    private let bookSeriesView = BookSeriesView()
    private let bookInfoView = BookInfoView()
    private let bookDedicationAndSummaryView = BookDedicationAndSummaryView()
    private let bookChaptersView = BookChaptersView()
    
    private var books: [Attributes] = []
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
        viewModel.loadBooks()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(bookTitleView)
        view.addSubview(bookSeriesView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(bookInfoView)
        contentView.addSubview(bookDedicationAndSummaryView)
        contentView.addSubview(bookChaptersView)
        
        bookTitleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookSeriesView.snp.makeConstraints { make in
            make.top.equalTo(bookTitleView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(bookSeriesView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        bookInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        bookDedicationAndSummaryView.snp.makeConstraints { make in
            make.top.equalTo(bookInfoView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookChaptersView.snp.makeConstraints { make in
            make.top.equalTo(bookDedicationAndSummaryView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        // books
        viewModel.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                guard let self = self else { return }
                self.books = books
                self.bookSeriesView.configure(books: books, selectedIndex: 0)
                if let firstBook = books.first {
                    self.updateViewController(with: firstBook, index: 0)
                }
            })
            .disposed(by: disposeBag)
        
        // buttonTappedHandler
        bookSeriesView.buttonTappedHandler = { [weak self] index in
            self?.viewModel.bookIndexTappedRelay.accept(index)
        }
        
        // bookIndexTappedRelay
        viewModel.bookIndexTappedRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                if index < self.books.count {
                    let selectedBook = self.books[index]
                    self.updateViewController(with: selectedBook, index: index)
                    self.bookSeriesView.updateButtonStyles(selectedIndex: index)
                }
            })
            .disposed(by: disposeBag)
        
        // error
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                print("⚠️ Alert 호출됨: \(error.message)")
                self?.showErrorAlert(message: error.message)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    private func showErrorAlert(message: String) {
        print("⚠️ showErrorAlert 실행됨: \(message)")
        let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIViews Update
    private func updateViewController(with book: Attributes, index: Int) {
        self.bookTitleView.configure(book: book)
        self.bookSeriesView.configure(for: index)
        self.bookInfoView.configure(index: index, book: book)
        self.bookDedicationAndSummaryView.configure(book: book)
        self.bookChaptersView.configure(book: book.chapters.map { $0.title })
    }
}
