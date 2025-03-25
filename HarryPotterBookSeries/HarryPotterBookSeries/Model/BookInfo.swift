//
//  BookInfo.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/25/25.
//

import Foundation

// let bookInfo = try? JSONDecoder().decode(BookInfo.self, from: jsonData)

struct BookInfo: Codable {
    let data: [Datum]
}
struct Datum: Codable {
    let attributes: Attributes
}

struct Attributes: Codable {
    let title, author: String
    let pages: Int
    let releaseDate, dedication, summary: String
    let wiki: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title, author, pages
        case releaseDate = "release_date"
        case dedication, summary, wiki, chapters
    }
}

struct Chapter: Codable {
    let title: String
}

