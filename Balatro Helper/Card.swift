//
//  Card.swift
//  Balatro Helper
//
//  Created by Burgess, Rick (CHICO-C) on 4/28/24.
//

import Foundation

struct Card: Equatable {
    let suite: Suit
    let cardType: CardType
    let value: Int
    let modifiers: [Modifier]

    var chips: Double { 0 }
    var chipMultiplier: Double { 1.0 }
    var multMultiplier: Double { 1.0 }

    enum Suit: Equatable {
        case heart
        case club
        case diamond
        case spade
        case wild
    }

    enum CardType: Equatable {
        case ace
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case jack
        case queen
        case king
        case stone

        var isFaceCard: Bool {
            false
        }
    }

    var addMultiplier: Double { 0 }

    struct Modifier: Equatable {
        
    }
}
