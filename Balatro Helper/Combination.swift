//
//  Combination.swift
//  Balatro Helper
//
//  Created by Burgess, Rick (CHICO-C) on 4/28/24.
//

import Foundation

extension Collection {

    func combinations(choose k: Int) -> [[Element]] {
        if k == 0 {
            return [[]]
        }
        guard k <= count else {
            return []
        }
        guard count > 0 && k > 0 else {
            return []
        }
        guard let first else {
            return []
        }
        var result: [[Element]] = []

        let rest = dropFirst()
        let subcombinations = rest.combinations(choose: k - 1)
        result += subcombinations.map { [first] + $0 }
        result += rest.combinations(choose: k)

        return result
    }
}

extension Collection where Element: Hashable {

    func countOccurrences() -> [Element: Int] {
        var counts: [Element: Int] = [:]
        for item in self {
            counts[item, default: 0] += 1
        }
        return counts
    }
}
