//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by desanka milakovic on 14.2.23..
//

import Foundation
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
public class RemoteFeedLoader {
   private let url: URL
   private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
   
   public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping (Error) -> Void) {

        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.invalidData)
                print("remoteFeedLoader, invalid")
            case .failure:
                completion(.connectivity)
                //print("remoteFeedLoaderconnectivity")
            }
            
        }
    }
}
