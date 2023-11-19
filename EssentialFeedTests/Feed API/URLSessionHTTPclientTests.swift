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

final class URLSessionHTTPclientTests: XCTestCase {
    

    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequest()
        let sut = HTTPClientURLSession()
        let url = URL(string: "http//any-url")!
        let error = NSError(domain: "any error", code: 1)
        
        URLProtocolStub.stub(url: url, error: error)
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url) { (result) in
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
        URLProtocolStub.stopInterceptingRequest()
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stubs = [URL: Stub]()
        
        private struct Stub {
            let error: Error?
        }
        
        static func stub(url:URL, error: Error? = nil) {
            stubs[url] = Stub(error: error)
        }
        static func startInterceptingRequest () {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        static func stopInterceptingRequest () {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = [:]
        }
        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else {return false}
            return URLProtocolStub.stubs[url] != nil
        }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else {return}
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        override func stopLoading() {}
       
    }
 
}

