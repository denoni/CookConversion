//
//  CookConversionTests.swift
//  CookConversionTests
//
//  Created by Gabriel on 11/1/21.
//

import XCTest
import SwiftUI
@testable import CookConversion

class CookConversionTests: XCTestCase {

  // System under test
  var sut: CookConversionViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = CookConversionViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

// MARK: - Input Value Tests

  func testInputValueIsNotANumber() {
    // GIVEN - User typed value that is not a number
    sut.currentTypedValue = "abc"

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of invalid number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("invalid-number").stringValue())
  }

  func testInputValueIsEmpty() {
    // GIVEN - User typed value that is not a number
    sut.currentTypedValue = ""

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of invalid number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("invalid-number").stringValue())
  }

  func testInputValueIsNegative() {
    // GIVEN - User typed value below zero
    sut.currentTypedValue = "-1"
    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of too high number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("invalid-number").stringValue())
  }

  func testInputValueIsTooHigh() {
    // GIVEN - User typed value that is too high
    sut.currentTypedValue = "5001" // TODO: HARD CODED MAGIC NUMBER

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of too high number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("too-high-number").stringValue())
  }




}
