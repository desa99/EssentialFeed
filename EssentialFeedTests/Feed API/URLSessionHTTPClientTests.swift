//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 15.11.23..
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
  
    let session: URLSession
    init(session: URLSession = .shared) {
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

final class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
         super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performGETRequestWithURL() {
        
        let url = anyURL()
        
        let exp = expectation(description: "Wait for completion")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) {_ in}
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        let error = NSError(domain: "any error", code: 1)
        
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let exp = expectation(description: "Wait for completion")
        makeSUT().get(from: anyURL()) { (result) in
            switch result {
            case let .failure(receivedResult as NSError):
                XCTAssertEqual(receivedResult.domain, error.domain)
                XCTAssertEqual(receivedResult.code, error.code)
                XCTAssertNotNil(receivedResult)
            default:
                XCTFail("Expected to get \(error), but got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // Helper
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
       let sut = URLSessionHTTPClient()
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    private func anyURL() -> URL {
        return URL(string: "http://any-url")!
    }
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        static func startInterceptingRequest () {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        static func stopInterceptingRequest () {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        static func observeRequest(observe: @escaping (URLRequest) -> Void) {
            requestObserver = observe
        }
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response =  URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error =  URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        override func stopLoading() {}
       
    }
 
}
