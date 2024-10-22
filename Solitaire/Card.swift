//
//  Card.swift
//  Solitaire
//
//  Created by Павел Грабчак on 09.10.2024.
//

import SwiftUI

struct Card {
    let id: UUID
    let rank: Rank
    let suit: Suit
    var isFaceUp: Bool
    
    var name: String {
        rank.rawValue + " of " + suit.rawValue.capitalized
    }
    
    var imageName: String {
        isFaceUp ? rank.rawValue + "_" + suit.rawValue : "CardBack"
    }
    
    var value: Int {
        switch rank {
        case ._2: 2
        case ._3: 3
        case ._4: 4
        case ._5: 5
        case ._6: 6
        case ._7: 7
        case ._8: 8
        case ._9: 9
        case ._10: 10
        case .jack: 11
        case .queen: 12
        case .king: 13
        case .ace: 1
        }
    }
    
    func getImage() -> some View {
        return Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    enum Rank: String, CaseIterable {
        case _2 = "2"
        case _3 = "3"
        case _4 = "4"
        case _5 = "5"
        case _6 = "6"
        case _7 = "7"
        case _8 = "8"
        case _9 = "9"
        case _10 = "10"
        case jack = "Jack"
        case queen = "Queen"
        case king = "King"
        case ace = "Ace"
    }
    
    enum Suit: String, CaseIterable {
        case spades
        case hearts
        case diamonds
        case clubs
    }
}

struct DeckBuilder {
    static func create52Cards() -> [Card] {
        var deck: [Card] = []
        
        for rank in Card.Rank.allCases {
            for suit in Card.Suit.allCases {
                deck.append(Card(id: UUID(), rank: rank, suit: suit, isFaceUp: true))
            }
        }
        
        return deck
    }
}