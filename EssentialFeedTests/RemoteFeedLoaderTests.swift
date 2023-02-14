//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 13.2.23..
//

import XCTest
import EssentialFeed
//public protocol HTTPClient {
//    func get(from url: URL)
//   
//}
//public class RemoteFeedLoader {
//   private let url: URL
//   private let client: HTTPClient
//    init(url: URL, client: HTTPClient) {
//        self.url = url
//        self.client = client
//    }
//  public func load() {
//      client.get(from: url)
//    }
//}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_doesNotRequestDataFromURL() {
       let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    func test_requestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
         func get(from url: URL) {
            requestedURL = url
        }
    }

}
