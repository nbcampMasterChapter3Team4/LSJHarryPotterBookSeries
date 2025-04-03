//
//  BookInfoView.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/26/25.
//

import UIKit
import SnapKit
import Then

final class BookInfoView: UIView {
    // MARK: - Type Aliases
    typealias AttributeType = BookInfoAttributeType
    
    // MARK: - Properties
    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    private lazy var authorTitleLabel = makeAttributeTitleLabel(for: .author)
    private lazy var releasedTitleLabel = makeAttributeTitleLabel(for: .released)
    private lazy var pagesTitleLabel = makeAttributeTitleLabel(for: .pages)
    
    private lazy var authorValueLabel = makeAttributeValueLabel(for: .author)
    private lazy var releasedValueLabel = makeAttributeValueLabel(for: .released)
    private lazy var pagesValueLabel = makeAttributeValueLabel(for: .pages)
    
    private var rootStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .top
        $0.distribution = .fill
    }
    
    private var textInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(index: Int, book: Attributes) {
        let bookImage = BookImages.allCases[index].rawValue
        bookImageView.image = UIImage(named: bookImage)
        titleLabel.text = book.title
        authorValueLabel.text = book.author
        releasedValueLabel.text = formatDate(from: book.releaseDate)
        pagesValueLabel.text = "\(book.pages)"
    }
    
    // MARK: - Setup View
    private func setupView() {
        let authorStack = makeAttributeStack(titleLabel: authorTitleLabel, valueLabel: authorValueLabel)
        let releasedStack = makeAttributeStack(titleLabel: releasedTitleLabel, valueLabel: releasedValueLabel)
        let pagesStack = makeAttributeStack(titleLabel: pagesTitleLabel, valueLabel: pagesValueLabel)
        
        textInfoStackView.addArrangedSubview(titleLabel)
        textInfoStackView.addArrangedSubview(authorStack)
        textInfoStackView.addArrangedSubview(releasedStack)
        textInfoStackView.addArrangedSubview(pagesStack)
        
        rootStackView.addArrangedSubview(bookImageView)
        rootStackView.addArrangedSubview(textInfoStackView)
        
        addSubview(rootStackView)
        
        bookImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(bookImageView.snp.width).multipliedBy(1.5)
        }
        
        rootStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UI Components
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
    
    // MARK: - formatDate Method
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
