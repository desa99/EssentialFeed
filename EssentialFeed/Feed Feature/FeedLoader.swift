//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by desanka milakovic on 13.2.23..
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}
public protocol FeedLoader {
     func load(completion: @escaping (LoadFeedResult) -> Void)
}
