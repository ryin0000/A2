//MODEL
//  MemorizeGame.swift
//  Memorize
//
//  Created by Richard Yin on 4/20/23.
//
import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
        
        // ... rest of the code
        
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 // Add 2 points for a match
                } else {
                    // Deduct 1 point for each card involved in a mismatch that has been seen before
                    if cards[chosenIndex].seenCount > 0 {
                        score -= 1
                    }
                    if cards[potentialMatchIndex].seenCount > 0 {
                        score -= 1
                    }
                }
                cards[chosenIndex].isFaceUp = true
                cards[chosenIndex].seenCount += 1
                cards[potentialMatchIndex].seenCount += 1
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {

            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
            
        }

    }

    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only
        }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0)} //goes through all cards, set them to face down
        }
    }

    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
      
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.isFaceUp == rhs.isFaceUp
            && lhs.isMatched == rhs.isMatched
            && lhs.content == rhs.content
        }
        var hasBeenSeen: Bool = false // Add this property to keep track of seen
        var seenCount: Int = 0
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        var id: String
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? " matched" :  "")"
        }
    }
    
}
struct Theme {
    var name: String
    var emojis: [String]
    var numberOfPairs: Int
    var color: String
}
extension Array {
    var only: Element? {
        count == 1 ? first: nil
    }
}
