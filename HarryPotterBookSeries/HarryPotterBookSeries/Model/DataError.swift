//
//  DataError.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/31/25.
//

import Foundation

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
