//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 13.2.23..
//

import XCTest
import EssentialFeed


final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        XCTAssertEqual(client.requestURLs, [url])
    }
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    func test_systemDeliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load() {  capturedError.append($0)}
        let clientError = NSError(domain: "test", code: 0)
        client.complete(with: clientError)
        XCTAssertEqual(capturedError, [.connectivity])
    }
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    private class HTTPClientSpy: HTTPClient {
       
        var messages = [(url: URL, completion: (Error) -> Void )]()
        var requestURLs: [URL] {
            return messages.map{ $0.url }
        }
        func get(from url: URL, completion: @escaping (Error) -> Void ) {
            messages.append((url, completion))
        }
        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(error)
        }
    }

}
