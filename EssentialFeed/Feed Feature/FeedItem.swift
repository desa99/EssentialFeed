//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by desanka milakovic on 13.2.23..
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: String
}
