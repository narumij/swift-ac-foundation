//
//  ReadTests.swift
//  
//
//  Created by narumij on 2023/12/18.
//

import XCTest
@testable import AcFoundation

extension CChar: ExpressibleByStringLiteral {
    public init(stringLiteral s: String) {
        self = Character(s).asciiValue.map{ Int8($0) }!
    }
}

@STDIO
final class ReaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRead1() throws {
        XCTAssertEqual(
            SolverRunner(solver: {
                let N = Int.read()
                let M = Int.read()
                let F = Double.read()
                let S = String.read()
                let CC = [CChar].read()
                print((N + 1))
                print((M + 1))
                print((F * 2))
                print(S.uppercased())
                print(String(cString: CC + ["1",0]))
            })
            .run(input:
            """
            3
            -3
            3.14
            abc
            1111
            """),
            
            """
            4
            -2
            6.28
            ABC
            11111
            """)
    }
    
    func testRead2() throws {
        XCTAssertEqual(
            SolverRunner(solver: {
                let S: String = .read()
                let CC: [CChar] = .read()
                print(S.uppercased())
                print(String(cString: CC + ["1",0]))
            })
            .run(input:
            """
            abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
            1111111111111111111111111111111111111111111111111111
            """),
            
            """
            ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ
            11111111111111111111111111111111111111111111111111111
            """)
    }
    
    func testRead3() throws {
        XCTAssertEqual(
            SolverRunner(solver: {
                let CC: [[CChar]] = .read(rows: 3, columns: 3)
                CC.forEach {
                    print(String(cString: $0 + [0]).uppercased())
                }
            })
            .run(input:
            """
            aaa
            bbb
            ccc
            """),
            
            """
            AAA
            BBB
            CCC
            """)
    }

    func testRead4() throws {
        XCTAssertEqual(
            SolverRunner(solver: {
                let SS: [String] = .read(rows: 3, columns: 3)
                SS.forEach {
                    print($0.uppercased())
                }
            })
            .run(input:
            """
            aaa
            bbb
            ccc
            """),
            
            """
            AAA
            BBB
            CCC
            """)
    }
    
    func testRead5() throws {
        XCTAssertEqual(
            SolverRunner(solver: {
                let ABC: [[Int]] = .read(rows: 3, columns: 3)
                ABC.forEach {
                    print($0.map{ $0 * 3 }.map(\.description).joined(separator: " "))
                }
            })
            .run(input:
            """
            1 1 1
            2 2 2
            3 3 3
            """),
            
            """
            3 3 3
            6 6 6
            9 9 9
            """)
    }
    
    func testRead6() throws {
        XCTAssertEqual(
            SolverRunner(solver: {
                let A: [Int] = .read(rows: 3)
                A.forEach {
                    print($0 * 3)
                }
            })
            .run(input:
            """
            1
            2
            3
            """),
            
            """
            3
            6
            9
            """)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
