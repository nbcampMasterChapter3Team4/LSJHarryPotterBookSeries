//
//  BookInfo.swift
//  HarryPotterBookSeries
//
//  Created by yimkeul on 3/25/25.
//

import Foundation

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

    init() {
        self.title = ""
        self.author = ""
        self.pages =  -1
        self.releaseDate = ""
        self.dedication = ""
        self.summary = ""
        self.wiki = ""
        self.chapters = []
    }
    
    enum CodingKeys: String, CodingKey {
        case title, author, pages
        case releaseDate = "release_date"
        case dedication, summary, wiki, chapters
    }
}

struct Chapter: Codable {
    let title: String
}

