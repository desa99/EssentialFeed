//
//  URLSessionHTTPclientTests.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 15.11.23..
//

import XCTest
import EssentialFeed
class HTTPClientURLSession {
  
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
func get(from url: URL) {
    session.dataTask(with: url) {_, _, _ in}
}
}

final class URLSessionHTTPclientTests: XCTestCase {
    
    func test_() {
        let session = URLSessionSpy()
        let sut = HTTPClientURLSession(session: session)
        let url = URL(string: "http//any-url")!
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
