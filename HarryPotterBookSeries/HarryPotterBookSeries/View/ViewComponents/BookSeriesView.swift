//
//  BookSeriesView.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/29/25.
//

import UIKit
import SnapKit
import Then

final class BookSeriesView: UIView {

    func configure(books: [Attributes]) {
        makeButtonGroup(for: books)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false // ✅ 스크롤 바 숨김
    }

    private let contentView = UIView() // ✅ scrollView 내부 컨텐츠 뷰

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }


}

extension BookSeriesView {
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }

        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(scrollView.snp.height)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}

extension BookSeriesView {
    private func makeSeriesButton(for indexNum: Int) -> UIButton {
        return UIButton().then {
            $0.setTitle("\(indexNum)", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.layer.cornerRadius = 25
            $0.backgroundColor = .systemBlue
            $0.clipsToBounds = true
            $0.titleLabel?.textAlignment = .center
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(50)
            }
        }
    }

    private func makeButtonGroup(for books: [Attributes]) {
        books.enumerated().forEach { index, _ in
            let button = makeSeriesButton(for: index + 1)
            stackView.addArrangedSubview(button)
        }
    }

}
