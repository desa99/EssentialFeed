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
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
        
    }
}

final class URLSessionHTTPclientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let session = URLSessionSpy()
        let sut = HTTPClientURLSession(session: session)
        let url = URL(string: "http//any-url")!
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        sut.get(from: url) { _ in }
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    func test_getFromURL_failsOnRequestError() {
        let session = URLSessionSpy()
        let sut = HTTPClientURLSession(session: session)
        let url = URL(string: "http//any-url")!
        let error = NSError(domain: "any error", code: 1)
        
        session.stub(url: url, error: error)
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url) { (result) in
            switch result {
            case let .failure(receivedResult as NSError):
                XCTAssertEqual(receivedResult, error)
            default:
                XCTFail("Expected to get \(error), but got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private class URLSessionSpy: URLSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        func stub(url:URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn t find stub for given \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
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

