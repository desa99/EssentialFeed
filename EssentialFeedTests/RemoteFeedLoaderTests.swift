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
        
        sut.load()
        XCTAssertEqual(client.requestURLs, [url])
    }
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    func test_systemDeliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load() {  capturedError.append($0)}
        var clientError = NSError(domain: "test", code: 0)
        client.completions[0](clientError)
        XCTAssertEqual(capturedError, [.connectivity])
    }
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    private class HTTPClientSpy: HTTPClient {
        var requestURLs = [URL]()
        var error: Error?
        var completions = [(Error) -> Void]()
        func get(from url: URL, completion: @escaping (Error) -> Void ) {
            completions.append(completion)
             requestURLs.append(url)
            
            
        }
    }

}
