//
//  BookSeriesView.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/29/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


final class BookSeriesView: UIView {

    private var buttons: [UIButton] = []
    private let disposeBag = DisposeBag()

    func configure(books: [Attributes]) {
        makeButtonGroup(for: books)
        updateButtonStyles(viewModel: DataServiceViewModel.shared)
    }

    func configure(for index: Int) {
        updateButtonStyles(viewModel: DataServiceViewModel.shared)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
}

extension BookSeriesView {
    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
}

extension BookSeriesView {
    private func makeSeriesButton(for indexNum: Int) -> UIButton {
        return UIButton().then {
            $0.setTitle("\(indexNum + 1)", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.titleLabel?.textAlignment = .center
            $0.tag = indexNum
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
        }
    }


    private func makeButtonGroup(for books: [Attributes]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 기존 버튼 제거
        buttons.removeAll() // 배열 초기화

        books.enumerated().forEach { index, _ in
            let button = makeSeriesButton(for: index)
            stackView.addArrangedSubview(button)
            buttons.append(button) // ✅ 버튼 배열에 저장
        }
        setupButtonBindings()
    }


    private func setupButtonBindings() {
        buttons.forEach { button in
            button.rx.tap
                .map { button.tag }
                .bind(to: DataServiceViewModel.shared.selectBookIndexObserver)
                .disposed(by: disposeBag)
        }
    }
    


    private func updateButtonStyles(viewModel: DataServiceViewModel) {
        viewModel.selectedBookIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] currentIndex in
            self?.buttons.enumerated().forEach { index, button in
                if index == currentIndex {
                    button.backgroundColor = .systemBlue
                    button.setTitleColor(.white, for: .normal)
                } else {
                    button.backgroundColor = .systemGray4
                    button.setTitleColor(.systemBlue, for: .normal)
                }
            }
        }).disposed(by: disposeBag)
    }
}
