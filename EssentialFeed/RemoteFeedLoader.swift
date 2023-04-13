//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by desanka milakovic on 14.2.23..
//

import Foundation

public class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Result) -> Void) {
        
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                do {
                 let items = try FeedItemMapper.map(data, response)
                
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            } 
        }
    }
}


