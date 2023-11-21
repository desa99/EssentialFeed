//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by desanka milakovic on 21.11.23..
//

import XCTest
extension XCTestCase {
     func checkForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated, potetional memory leak", file: file, line: line)
        }
    }
}
