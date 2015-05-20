//
//  WriterTests.swift
//  Poet
//
//  Created by Mikael Konutgan on 20/05/15.
//  Copyright (c) 2015 Mikael Konutgan. All rights reserved.
//

import XCTest
import Poet

typealias WriterType = Writer<String, Int>
let pure = WriterType.pure

class WriterTests: XCTestCase {
    func testMonadLaws() {
        let a = 4
        let m = WriterType(a, toString(a))
        
        let f: Int -> WriterType = { return Writer($0 + 5, toString($0)) }
        let g: Int -> WriterType = { return Writer($0 * 7, toString($0)) }
        
        XCTAssert((pure(a) >>= f) == f(a))
        XCTAssert((m >>= pure) == m)
        XCTAssert(((m >>= f) >>= g) == (m >>= { x in f(x) >>= g }))
    }
}
