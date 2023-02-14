//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by desanka milakovic on 13.2.23..
//

import Foundation
enum FeedLoadResult {
    case success([FeedItem])
    case failure(Error)
}
 protocol FeedLoader {
    func load(completion: @escaping (FeedLoadResult) -> Void)
}
