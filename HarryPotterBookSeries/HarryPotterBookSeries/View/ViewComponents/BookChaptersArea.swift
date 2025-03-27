//
//  BookChaptersArea.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/27/25.
//

import UIKit
import SnapKit
import Then

class BookChaptersArea: UIView {

    func configure(book: [String]) {
        updateChapters(book)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel = UILabel().then {
        $0.text = "Chapters"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .label
    }

    private let chaptersStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
}

extension BookChaptersArea {
    private func setupView() {
        chaptersStack.addArrangedSubview(titleLabel)
        addSubview(chaptersStack)

        chaptersStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }

    private func updateChapters(_ data: [String]) {
        for chapter in data {
            chaptersStack.addArrangedSubview(makeContentsLabel(chapter))
        }
    }
}

extension BookChaptersArea {
    private func makeContentsLabel(_ text: String) -> UILabel {
        return UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .darkGray
            $0.text = text
        }
    }
}
