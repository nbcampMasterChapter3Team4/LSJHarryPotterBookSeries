//
//  BookInfoArea.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/26/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class BookInfoArea: UIView {

    var dataIndex: Int?
    var data: Attributes?

    func configure(index: Int, book: Attributes) {
        let bookImage = BookImages.allCases[index].rawValue
        bookImageView.image = UIImage(named: bookImage)
        titleLabel.text = book.title
        authorValueLabel.text = book.author
        releasedValueLabel.text = formatDate(from: book.releaseDate)
        pagesValueLabel.text = "\(book.pages)"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var rootStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private var textInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100 * 2 / 3))
        }
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    private var authorTitleLabel: UILabel {
        makeAttributeTitleLabel(for: .author)
    }

    private var releasedTitleLabel: UILabel {
        makeAttributeTitleLabel(for: .released)
    }

    private var pagesTitleLabel: UILabel {
        makeAttributeTitleLabel(for: .released)
    }

    private var authorValueLabel: UILabel {
        makeAttributeValueLabel(for: .author)
    }

    private var releasedValueLabel: UILabel {
        makeAttributeValueLabel(for: .released)
    }
    private var pagesValueLabel: UILabel {
        makeAttributeValueLabel(for: .pages)
    }

}

extension BookInfoArea {
    private func setupView() {
        rootStackView = UIStackView(arrangedSubviews: [bookImageView, textInfoStackView])
        textInfoStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            makeAttributeStack(titleLabel: authorTitleLabel, valueLabel: authorValueLabel),
            makeAttributeStack(titleLabel: releasedTitleLabel, valueLabel: releasedValueLabel),
            makeAttributeStack(titleLabel: pagesTitleLabel, valueLabel: pagesValueLabel),
            ])
        
        
        addSubview(rootStackView)
        addSubview(textInfoStackView)

        // TODO: 수정필요한 부분인듯
        rootStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textInfoStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
}

extension BookInfoArea {
    private enum AttributeType: String {
        case author = "Author"
        case released = "Released"
        case pages = "Pages"

        func getTitleFontSize() -> CGFloat {
            switch self {
            case .author:
                return 16
            case .released, .pages:
                return 14
            }
        }

        func getValueFontSize() -> CGFloat {
            switch self {
            case .author:
                return 18
            case .released, .pages:
                return 14
            }
        }
    }
}

extension BookInfoArea {
    private func makeAttributeTitleLabel(for attributeType: AttributeType) -> UILabel {
        return UILabel().then {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: attributeType.getTitleFontSize(), weight: .bold)
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.text = attributeType.rawValue
        }
    }

    private func makeAttributeValueLabel(for attributeType: AttributeType) -> UILabel {
        return UILabel().then {
            $0.textColor = .darkGray
            $0.font = .systemFont(ofSize: attributeType.getValueFontSize())
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
    }

    private func makeAttributeStack(titleLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        return UIStackView().then {
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(valueLabel)

            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

    private func formatDate(from input: String) -> String {
        let inputFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd"
            $0.locale = Locale(identifier: "en_US_POSIX")
        }

        let outputFormatter = DateFormatter().then {
            $0.dateFormat = "MMMM d, yyyy"
            $0.locale = Locale(identifier: "en_US")
        }

        guard let date = inputFormatter.date(from: input) else { return "Invalid Date" }
        return outputFormatter.string(from: date)
    }
}
