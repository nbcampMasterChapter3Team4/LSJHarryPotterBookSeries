//
//  BookTitleView.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/26/25.
//

import UIKit
import SnapKit
import Then

final class BookTitleView: UIView {

    func configure(index: Int, book: Attributes) {
        titleLabel.text = book.title
//        seriesNumberLabel.setTitle("\(index + 1)", for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }


}


extension BookTitleView {
    
    private func setupView() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
