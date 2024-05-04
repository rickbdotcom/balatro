//
//  Balatro_HelperTests.swift
//  Balatro HelperTests
//
//  Created by Burgess, Rick (CHICO-C) on 4/28/24.
//

import XCTest
@testable import Balatro_Helper

final class Balatro_HelperTests: XCTestCase {
    
    func testCombinations() throws {
        let hand = [1,2,3,4,5,6,7,8,9,10,11]
        
        (1...5).forEach { size in
            let array = hand.combinations()
            print(array.count)
        }
    }
}
