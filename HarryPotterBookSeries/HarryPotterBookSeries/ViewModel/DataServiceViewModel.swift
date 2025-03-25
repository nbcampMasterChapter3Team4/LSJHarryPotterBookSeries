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
    
    var books: Observable<[Attributes]> {
        return booksSubject.asObservable()
    }
    
    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }

    func loadBooks() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            booksSubject.onError(DataError.fileNotFound)
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
                    self.booksSubject.onError(DataError.parsingFailed)
                }
            }
        }
    }
}
