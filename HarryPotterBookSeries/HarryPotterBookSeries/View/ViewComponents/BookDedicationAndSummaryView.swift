//
//  BookDedicationAndSummaryView.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/27/25.
//

import UIKit
import SnapKit
import Then

final class BookDedicationAndSummaryView: UIView {
    // MARK: - Type Aliases
    typealias AttributeType = BookDedicationAndSummaryAttributeType
    
    // MARK: - Properties
    private let summaryExpandedKey = "summaryExpandedKey"
    private var isSummaryExpanded: Bool {
        get { UserDefaults.standard.bool(forKey: summaryExpandedKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: summaryExpandedKey) }
    }
    
    private var summaryFullText: String = ""
    private let summaryLimit = 450
    
    private lazy var dedicationTitleLabel = makeTitleLabel(for: .dedication)
    private lazy var summaryTitleLabel = makeTitleLabel(for: .summary)
    
    private lazy var dedicationContentsLabel = makeContentsLabel()
    private lazy var summaryContentsLabel = makeContentsLabel()
    
    private lazy var moreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.addTarget(self, action: #selector(toggleSummary), for: .touchUpInside)
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
    func configure(book: Attributes) {
        dedicationContentsLabel.text = book.dedication
        summaryFullText = book.summary
        updateSummaryDisplay()
    }
    
    // MARK: - Setup View
    private func setupView() {
        let dedicationStack = makeStack(titleLabel: dedicationTitleLabel, contentsLabel: dedicationContentsLabel)
        let summaryStack = makeStack(titleLabel: summaryTitleLabel, contentsLabel: summaryContentsLabel)
        
        addSubview(dedicationStack)
        addSubview(summaryStack)
        addSubview(moreButton)
        
        dedicationStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        summaryStack.snp.makeConstraints { make in
            make.top.equalTo(dedicationStack.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(summaryContentsLabel.snp.bottom).offset(8)
            make.trailing.equalTo(summaryContentsLabel.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UI Components
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
        let stack = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(contentsLabel)
        return stack
    }
    
    // MARK: - Summary Business Logic Update
    private func updateSummaryDisplay() {
        if summaryFullText.count > summaryLimit {
            summaryContentsLabel.text = isSummaryExpanded ? summaryFullText : String(summaryFullText.prefix(summaryLimit)) + "..."
            moreButton.isHidden = false
            moreButton.setTitle(isSummaryExpanded ? "접기" : "더보기", for: .normal)
        } else {
            summaryContentsLabel.text = summaryFullText
            moreButton.isHidden = true
        }
    }
    
    @objc private func toggleSummary() {
        isSummaryExpanded.toggle()
        updateSummaryDisplay()
    }
}
