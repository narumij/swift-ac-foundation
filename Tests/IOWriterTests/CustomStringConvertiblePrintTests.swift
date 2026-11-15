import IOWriter
import TestingUtil
import XCTest

// CustomStringConvertible なので printableDescription を省略できる
private struct Mint: PrintableElement, CustomStringConvertible {
  var v: Int
  var description: String { "\(v)" }
}

// CustomStringConvertible ではないので printableDescription を自分で書く
private struct Plain: PrintableElement {
  var v: Int
  var printableDescription: String { "<\(v)>" }
}

final class CustomStringConvertiblePrintTests: XCTestCase {

  func testInt() throws {
    XCTAssertEqual(try SolverRunner(solver: { [1, 2, 3].print() }).outputOnly(), "1 2 3")
  }

  func testDouble() throws {
    XCTAssertEqual(try SolverRunner(solver: { [1.5, 2.0].print() }).outputOnly(), "1.5 2.0")
  }

  func testUInt8() throws {
    XCTAssertEqual(try SolverRunner(solver: { ([65, 66] as [UInt8]).print() }).outputOnly(), "AB")
  }

  func testCharacter() throws {
    XCTAssertEqual(try SolverRunner(solver: { (["a", "b"] as [Character]).print() }).outputOnly(), "ab")
  }

  func testPrintableElement() throws {
    XCTAssertEqual(try SolverRunner(solver: { [Mint(v: 1), Mint(v: 2)].print() }).outputOnly(), "1 2")
  }

  func testPrintableElementSeparator() throws {
    XCTAssertEqual(
      try SolverRunner(solver: { [Mint(v: 1), Mint(v: 2)].print(separator: ",") }).outputOnly(), "1,2")
  }

  func testPrintableElementWithoutCustomStringConvertible() throws {
    XCTAssertEqual(try SolverRunner(solver: { [Plain(v: 1), Plain(v: 2)].print() }).outputOnly(), "<1> <2>")
  }

  func testNestedInt() throws {
    XCTAssertEqual(try SolverRunner(solver: { [[1, 2], [3]].print() }).outputOnly(), "1 2\n3")
  }

  func testNestedPrintableElement() throws {
    XCTAssertEqual(
      try SolverRunner(solver: { [[Mint(v: 1), Mint(v: 2)], [Mint(v: 3)]].print() }).outputOnly(), "1 2\n3")
  }
}
