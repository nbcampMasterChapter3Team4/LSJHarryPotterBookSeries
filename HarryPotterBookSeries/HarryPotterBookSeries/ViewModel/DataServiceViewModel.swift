//
//  DataService.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DataServiceViewModel {

    private let disposeBag = DisposeBag()
    private let booksSubject = BehaviorSubject<[Attributes]>(value: []) // 초기값 빈 배열
    private let errorSubject = PublishSubject<DataError>() // 에러 발생을 전달하는 Subject


    var books: Observable<[Attributes]> {
        return booksSubject.asObservable()
    }

    var error: Observable<DataError> { // 에러 스트림을 외부에서 구독 가능하게 제공
        return errorSubject.asObservable()
    }

    enum DataError: Error {
        case fileNotFound
        case parsingFailed

        var message: String {
            switch self {
            case .fileNotFound:
                return "파일을 찾을 수 없습니다."
            case .parsingFailed:
                return "데이터를 불러오는 데 실패했습니다."
            }
        }


    }

    func loadBooks() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            print("📛 파일을 찾을 수 없습니다.") // 디버깅용 로그 추가
            self.errorSubject.onNext(.fileNotFound)
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let bookResponse = try JSONDecoder().decode(BookInfo.self, from: data)
                let books = bookResponse.data.map { $0.attributes }

                DispatchQueue.main.async {
                    self.booksSubject.onNext(books) // 📌 데이터를 BehaviorSubject에 전달
                }
            } catch {
                DispatchQueue.main.async {
                    print("📛 JSON 파싱 실패") // 디버깅용 로그 추가
                    self.errorSubject.onNext(.parsingFailed)
                }
            }
        }
    }
}
