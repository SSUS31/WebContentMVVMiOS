//
//  ViewModelTests.swift
//  Bongo DisclaimerTests
//
//  Created by Sahad on 25/7/20.
//  Copyright © 2020 Sahad. All rights reserved.
//

import XCTest
@testable import Bongo_Disclaimer

class ViewModelTests: XCTestCase {

    var sut: ViewModel!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = ViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testViewModel_everyNthCharacter_fromString() {//Position starts with 0.
        let input = "abcdefgdijkdz"
        let output = sut.getEveryCharacters(at: 3, for: input)// Getting every 3rd characters
        let expectedResult = "d d d"

        XCTAssertEqual(output, expectedResult)
    }

    func testViewModel_everyWordCount_fromString() {
        let expected = expectation(description: "Words count calculation")
        let input = "My name is Sahad."
        let expectedResult = "2 4 2 5"
        var output = ""
        sut.wordCountsInString = { result in
            output = result

            expected.fulfill()
        }
        sut.wordCounts(_string: input)
        wait(for: [expected], timeout: 3.0)

        XCTAssertEqual(expectedResult, output)
    }

    func testViewModel_lastCharacter_fromString() {
        let expected = expectation(description: "Getting last character")
        let input = "My name is Sahad."
        let expectedResult = Character(".")
        var output:Character = "\u{1F1FA}\u{1F1F8}"

        sut.lastCharacterAndEvery10thCharacters = { lastCharacter, _ in
            output = lastCharacter

            expected.fulfill()
        }
        sut.getLastCharacterAndEveryNthCharacters(input)
        wait(for: [expected], timeout: 3.0)

        XCTAssertNotNil(output)
        XCTAssertEqual(expectedResult, output)
    }

}
