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
    session.dataTask(with: url) {_, _, _ in}.resume()
    }
}

final class URLSessionHTTPclientTests: XCTestCase {
    
    func test_getFromURL_createDataTaskWithURL() {
        let session = URLSessionSpy()
        let sut = HTTPClientURLSession(session: session)
        let url = URL(string: "http//any-url")!
       
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    func test_getFromURL_resumesDataTaskWithURL() {
        let session = URLSessionSpy()
        let sut = HTTPClientURLSession(session: session)
        let url = URL(string: "http//any-url")!
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        sut.get(from: url)
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        var stubs = [URL: URLSessionDataTask]()
        
        func stub(url:URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return stubs[url] ?? FakeURLSessionDataTask()
        }
    }
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        override func resume() {
            resumeCallCount += 1
        }
    }
}
