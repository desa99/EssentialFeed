//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by desanka milakovic on 14.2.23..
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
   
}
public class RemoteFeedLoader {
   private let url: URL
   private let client: HTTPClient
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
  public func load() {
      client.get(from: url)
    }
}
