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

    private let titleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    private let seriesNumberLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16)
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemBlue
        $0.clipsToBounds = true
        $0.textAlignment = .center // 텍스트 가운데 정렬
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubView()
        setupUI()
        setupBindings()
        viewModel.loadBooks() // ✅ 데이터 로드
    }

    private func addSubView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(seriesNumberLabel)
    }

    private func setupUI() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        seriesNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            
            make.leading.greaterThanOrEqualToSuperview().inset(20)  // 왼쪽 여백 최소 20
            make.trailing.lessThanOrEqualToSuperview().inset(20)
            
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.height.equalTo(50)
        }
    }

    private func setupBindings() {
        viewModel.books
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트는 반드시 메인 스레드에서
        .subscribe(onNext: { [weak self] books in
            guard let self = self else { return }
            print(books.first?.title ?? "책 데이터 없음")
            self.titleLabel.text = books.first?.title
            self.seriesNumberLabel.text = "\(1)"
        })
            .disposed(by: disposeBag)
    }
}
