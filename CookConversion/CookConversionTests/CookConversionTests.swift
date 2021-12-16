//
//  CookConversionTests.swift
//  CookConversionTests
//
//  Created by Gabriel on 11/1/21.
//

import XCTest
import SwiftUI
@testable import Cook_Conversion

class InputValueTests: XCTestCase {

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

    // THEN - 'convertButtonText' message showed indication of an empty
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("empty-number").stringValue())
  }

  func testInputValueIsNegative() {
    // GIVEN - User typed value below zero
    sut.currentTypedValue = "-1"
    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of invalid number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("invalid-number").stringValue())
  }

  func testInputValueIsTooHigh() {
    // GIVEN - User typed value that is too high
    sut.currentTypedValue = String(Constants.maxInputValue + 1)

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of too high number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("too-high-number").stringValue())
  }
}

class StepperTest: XCTestCase {

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

  func testStepperIncrease() {
    // GIVEN
    sut.currentTypedValue = "10"

    // WHEN - User tapped + stepper
    sut.increaseCurrentTypedValueByOne()

    // THEN - 'currentTypedValue' was increased by one
    sut.currentTypedValue = "11"
  }

  func testStepperDecrease() {
    // GIVEN
    sut.currentTypedValue = "10"

    // WHEN - User tapped + stepper
    sut.increaseCurrentTypedValueByOne()

    // THEN - 'currentTypedValue' was decreased by one
    sut.currentTypedValue = "9"
  }

}
