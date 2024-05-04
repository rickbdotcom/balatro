//
//  PokerHand.swift
//  Balatro Helper
//
//  Created by Burgess, Rick (CHICO-C) on 4/28/24.
//

import Foundation

protocol PokerHandRecognizer {
    func hand(_ cards: [Card]) -> [Card]?
}

struct HighCardRecognizer: PokerHandRecognizer {

    func hand(_ cards: [Card]) -> [Card]? {
        if let highCard = cards.max(by: { $0.rank < $1.rank }) {
            [highCard]
        } else {
            nil
        }
    }
}
/*
struct PairRecognizer: PokerHandRecognizer {

    func hand(_ cards: [Card]) -> [Card]? {
        let cardTypes = cards.map { $0.cardType }
        let pairs = cardTypes.countOccurrences().filter {
            $0.value >= 2
        }
        cardTypes.filter {

        }
    }
}*/

struct PokerHand {
    let identifier: String
    let level: Int
    let chips: Int
    let chipMultiplier: Int
    let recognizer: PokerHandRecognizer

    static let highCard = PokerHand(identifier: "HIGH_CARD", level: 1, chips: 5, chipMultiplier: 1, recognizer: HighCardRecognizer())
}
