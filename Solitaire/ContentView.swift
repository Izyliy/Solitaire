//
//  ContentView.swift
//  Solitaire
//
//  Created by Павел Грабчак on 09.10.2024.
//

import SwiftUI

struct ContentView: View {
    let cardStacksSpacing: CGFloat = 5
    let cardStacksCount: Int = 7
    @State var cardSize: CGSize = .zero
    
    @State var deck: [Card]
    @State var exposedDeck: [Card] = []
    
    @State var cardStacks: [[Card]] = []
    
    @State var sortedStacks: [Card.Suit: [Card]] = [:]
    
    init() {
        self.deck = DeckBuilder.create52Cards().shuffled()
    }
    
    var body: some View {
        createUI()
            .background {
                Image("TableBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .onAppear {
                for i in 1...cardStacksCount {
                    let stack = Array(deck.prefix(i))
                    self.deck.removeFirst(i)
                    cardStacks.append(stack)
                }
                
                if cardSize == .zero {
                    let screenWidth = UIScreen.main.bounds.width
                    let cardWidth = screenWidth / CGFloat(cardStacksCount)
                    let cardHeight = cardWidth / 6 * 8
                    cardSize = CGSize(width: cardWidth, height: cardHeight)
                }
            }
    }
    
    func createUI() -> some View {
        VStack {
            ControlView(moveCount: 0, reloadAction: {
                // reload game func
            })
            
            if cardStacks.isEmpty {
                Text("Loading...")
            } else {
                SoliteireMainField(cardSize: $cardSize,
                                   cards: cardStacks)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

struct SoliteireMainField: View {
    @Binding var cardSize: CGSize
    let cards: [[Card]]
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(0..<cards.count, id: \.self) { row in
                SoliteireCardStack(cardSize: $cardSize,
                                   cards: cards[row])
            }
        }
    }
}

struct SoliteireCardStack: View {
    @Binding var cardSize: CGSize
    let cards: [Card]
    
    var body: some View {
        ZStack(alignment: .top) {
            ForEach(0..<cards.count, id: \.self) { index in
                cards[index].getImage()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .padding(.top, (cardSize.height / 2.0) * CGFloat(index))
                    .shadow(color: .gray, radius: 1, y: -2)
            }
        }
    }
}
