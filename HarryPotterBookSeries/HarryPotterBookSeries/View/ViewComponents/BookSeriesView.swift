//
//  BookSeriesView.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/29/25.
//

import UIKit
import SnapKit
import Then

protocol BookSeriesViewDelegate: AnyObject {
    func bookSeriesView(_ view: BookSeriesView, didSelectButtonAt index: Int)
}

final class BookSeriesView: UIView {

    weak var delegate: BookSeriesViewDelegate? // ✅ Delegate 객체 선언

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
            $0.backgroundColor = .systemBlue
            $0.clipsToBounds = true
            $0.titleLabel?.textAlignment = .center
            $0.tag = indexNum
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // ✅ 버튼 클릭 이벤트 추가
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
        }
    }

    private func makeButtonGroup(for books: [Attributes]) {
        books.enumerated().forEach { index, _ in
            let button = makeSeriesButton(for: index)
            stackView.addArrangedSubview(button)
        }
    }

    // 버튼을 눌렀을 때 실행되는 메서드
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.bookSeriesView(self, didSelectButtonAt: sender.tag) // ✅ Delegate 호출
    }
}
