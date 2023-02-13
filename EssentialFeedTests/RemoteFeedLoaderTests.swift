//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 13.2.23..
//

import XCTest
@testable import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    
    class RemoteFeedLoader {
      func load() {
          HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
        }
    }
    class HTTPClient {
        static let shared = HTTPClient()
        private init() {}
        var requestedURL: URL?
    }
    func test_doesNotRequestDataFromURL() {
        _ = RemoteFeedLoader()
        let client = HTTPClient.shared
        
        XCTAssertNil(client.requestedURL)
    }
    func test_requestDataFromURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClient.shared
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
