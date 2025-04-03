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
    
    private let booksSubject = BehaviorSubject<[Attributes]>(value: []) // 초기값 빈 배열
    private let errorSubject = PublishSubject<DataError>() // 에러 발생을 전달하는 Subject
    private let selectedBookIndexSubject = BehaviorSubject<Int>(value: 0)


    var books: Observable<[Attributes]> {
        return booksSubject.asObservable()
    }

    var error: Observable<DataError> { // 에러 스트림을 외부에서 구독 가능하게 제공
        return errorSubject.asObservable()
    }

    var selectedBookIndex: Observable<Int> { // 외부에서 구독 가능하게 제공
        return selectedBookIndexSubject.asObservable()
    }

    var selectBookIndexObserver: AnyObserver<Int> { // 외부에서 값을 변경 가능하게 제공
        return selectedBookIndexSubject.asObserver()
    }
    
   let bookIndexTappedRelay = BehaviorRelay<Int>(value: 0)

    func loadBooks() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            print("📛 파일을 찾을 수 없습니다.")
            self.errorSubject.onNext(.fileNotFound)
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let bookResponse = try JSONDecoder().decode(BookInfo.self, from: data)
                let books = bookResponse.data.map { $0.attributes }

                DispatchQueue.main.async {
                    self.booksSubject.onNext(books)
                }
            } catch {
                DispatchQueue.main.async {
                    print("📛 JSON 파싱 실패")
                    self.errorSubject.onNext(.parsingFailed)
                }
            }
        }
    }
}
