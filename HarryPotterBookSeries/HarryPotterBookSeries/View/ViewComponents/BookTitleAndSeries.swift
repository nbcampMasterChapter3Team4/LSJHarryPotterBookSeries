//
//  BookTitleAndSeries.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class BookTitleAndSeries: UIView {
    
    var dataIndex: Int?
    var data: Attributes?
    
    func configure(index: Int, book: Attributes) {
        titleLabel.text = book.title
        seriesNumberLabel.setTitle("\(index + 1)", for: .normal)
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
    
    private let seriesNumberLabel = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .systemBlue
        $0.clipsToBounds = true
        $0.titleLabel?.textAlignment = .center
    }
    

    
    private func setupView() {
        
        addSubview(titleLabel)
        addSubview(seriesNumberLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }
        
        seriesNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }
    }
}
