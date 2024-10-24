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
    @State var cardStacksFrames: [Int : CGRect] = [:]
    
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
                                   cards: cardStacks,
                                   onDragEnded: { cards, endPoint in
                    handleDragEnd(of: cards, at: endPoint)
                }, onRowAppeared: { row, frame in
                    cardStacksFrames[row] = frame
                })
            }
            
            Spacer()
        }
    }
    
    func handleDragEnd(of cards: [Card], at endPoint: CGPoint) {
        guard let endStackIndex = cardStacksFrames.first(where: { $0.value.contains(endPoint) })?.key,
              let startStackIndex = cardStacks.firstIndex(where: { $0.contains(where: { $0.id == cards.first?.id }) })
        else { return }
        
        cardStacks[startStackIndex].removeLast(cards.count)
        cardStacks[endStackIndex].append(contentsOf: cards)
    }
}

#Preview {
    ContentView()
}

struct SoliteireMainField: View {
    @Binding var cardSize: CGSize
    
    let cards: [[Card]]
    /// Dragged cards array, drag end location
    let onDragEnded: (([Card], CGPoint) -> Void)
    /// ID of a row, it's frame
    let onRowAppeared: ((Int, CGRect) -> Void)
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(0..<cards.count, id: \.self) { row in
                GeometryReader { geometry in
                    SoliteireCardStack(cardSize: $cardSize,
                                       cards: cards[row],
                                       onDragEnded: onDragEnded)
                    .onAppear {
                        onRowAppeared(row, geometry.frame(in: .global))
                    }
                }
            }
        }
    }
}

struct SoliteireCardStack: View {
    @Binding var cardSize: CGSize
    @State var draggedOffset: CGSize = .zero
    
    let cards: [Card]
    
    let onDragEnded: (([Card], CGPoint) -> Void)

    var body: some View {
        if let card = cards.first {
            ZStack(alignment: .top) {
                getCardView(for: card)
                if cards.count > 1 {
                    let subDeck = Array(cards.dropFirst())
                    SoliteireCardStack(cardSize: $cardSize,
                                       cards: subDeck,
                                       onDragEnded: onDragEnded)
                        .padding(.top, (cardSize.height / 2.0))
                }
            }
            .offset(draggedOffset)
            .gesture(DragGesture(coordinateSpace: .global)
                .onChanged { value in
                    draggedOffset = value.translation
                }
                .onEnded { value in
                    draggedOffset = .zero
                    onDragEnded(cards, value.location)
                }
            )
        } else {
            getEmptyCardView()
        }
    }
    
    func getEmptyCardView() -> some View {
        Image("Ace_spades")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: cardSize.width, height: cardSize.height)
            .opacity(0)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 244/255, green: 247/255, blue: 224/255), lineWidth: 1)
            )
    }
    
    func getCardView(for card: Card) -> some View {
        card.getImage()
            .frame(width: cardSize.width, height: cardSize.height)
            .shadow(color: .gray, radius: 1, y: -2)
    }
}
