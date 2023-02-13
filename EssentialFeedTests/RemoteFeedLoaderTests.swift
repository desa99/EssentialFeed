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
          HTTPClient.shared.get(from: URL(string: "https//:a-url.com")!)
        }
    }
    class HTTPClient {
        static var shared = HTTPClient()
        func get(from url: URL) {}
       
    }
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        override func get(from url: URL) {
            requestedURL = url
        }
    }
    func test_doesNotRequestDataFromURL() {
        _ = RemoteFeedLoader()
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        
        XCTAssertNil(client.requestedURL)
    }
    func test_requestDataFromURL() {
        let sut = RemoteFeedLoader()
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
