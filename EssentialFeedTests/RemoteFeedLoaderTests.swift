//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 13.2.23..
//

import XCTest
@testable import EssentialFeed

protocol HTTPClient {
    func get(from url: URL)
   
}
class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
     func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoader {
    let client: HTTPClient
     init(client: HTTPClient) {
        self.client = client
    }
  func load() {
      client.get(from: URL(string: "https://a-url.com")!)
    }
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    func test_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
