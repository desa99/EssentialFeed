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
        expect(sut, completeWithError: .connectivity, when: {
          
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        })
    }
    func test_systemDeliversErrorNon200HTTPURLResponse() {
        let (sut, client) = makeSUT()
        let samples =  [199, 201, 300, 400, 500]
       samples.enumerated().forEach { index, code in
           expect(sut, completeWithError: .invalidData, when: {
               client.complete(withStatusCode: code, index: index)
           })
        }
    }
    func test_systemDeliveresErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, completeWithError: .invalidData, when: {
            let invalidJSON = Data(_ : "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    private func expect(_ sut: RemoteFeedLoader, completeWithError error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load{ capturedResults.append($0)}
        action()
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }
    private class HTTPClientSpy: HTTPClient {
       
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void )]()
        var requestURLs: [URL] {
            return messages.map{ $0.url }
        }
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void ) {
            messages.append((url, completion))
            print("Spy")
        }
        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        func complete(withStatusCode code: Int,data: Data = Data(), index: Int = 0) {
            let response = HTTPURLResponse(url: requestURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }

}

