//
//  BookDedicationAndSummary.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/27/25.
//

import UIKit
import SnapKit
import Then

class BookDedicationAndSummary: UIView {

    func configure(book: Attributes) {
        dedicationContentsLabel.text = book.dedication
        summarynContentsLabel.text = book.summary
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dedicationTitleLabel = makeTitleLabel(for: .dedication)
    private lazy var summaryTitleLabel = makeTitleLabel(for: .summary)

    private lazy var dedicationContentsLabel = makeContentsLabel()
    private lazy var summarynContentsLabel = makeContentsLabel()
}

extension BookDedicationAndSummary {
    private func setupView() {
        let dedicationStack = makeStack(titleLabel: dedicationTitleLabel, contentsLabel: dedicationContentsLabel)
        let summaryStack = makeStack(titleLabel: summaryTitleLabel, contentsLabel: summarynContentsLabel)

        addSubview(dedicationStack)
        addSubview(summaryStack)

        dedicationStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        summaryStack.snp.makeConstraints { make in
            make.top.equalTo(dedicationStack.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


extension BookDedicationAndSummary {
    private enum AttributeType: String {
        case dedication = "Dedication"
        case summary = "Summary"
    }
}

extension BookDedicationAndSummary {
    private func makeTitleLabel(for attributeType: AttributeType) -> UILabel {
        return UILabel().then {
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = .label
            $0.text = attributeType.rawValue
            $0.numberOfLines = 0
        }
    }

    private func makeContentsLabel() -> UILabel {
        return UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .darkGray
            $0.numberOfLines = 0
        }
    }

    private func makeStack(titleLabel: UILabel, contentsLabel: UILabel) -> UIStackView {
        return UIStackView().then {
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(contentsLabel)

            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
}
