// VIEWMODEL
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Richard Yin on 4/20/23.
//

import SwiftUI
class EmojiMemoryGame: ObservableObject {
    private static let themes: [Theme] = [
        Theme(name: "Halloween", emojis: ["👻", "🎃", "🕷️", "👿", "😱"], numberOfPairs: 5, color: .orange),
        Theme(name: "Christmas", emojis: ["❄️", "🎄", "🎁", "👨‍👩‍👦"], numberOfPairs: 4, color: .green),
        Theme(name: "Stanford", emojis: ["🌲", "☀️", "📚", "👀"], numberOfPairs: 4, color: .red),
        Theme(name: "AnimalFaces", emojis: ["🐶", "🐱", "🐻", "🐯", "🦁", "🐭", "🐹", "🐰", "🦊", "🐻‍❄️", "🐨", "🐼"], numberOfPairs: 8, color: .yellow),
        Theme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🥊", "🏊‍♂️", "🏋️‍♂️", "🚴‍♂️", "🏇", "🏌️‍♀️"], numberOfPairs: 10, color: .blue),
        Theme(name: "FoodAndDrinks", emojis: ["🍔", "🍟", "🍕", "🍝", "🌮", "🌯", "🍜", "🥞", "🍣", "🥪", "🍦", "🍺"], numberOfPairs: 9, color: .pink)
                 ]
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        var memoryGame = MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "!?"
            }
        }
        memoryGame.shuffle()  // Shuffle the cards before returning the game
        return memoryGame
    }
    
    var themeColor: Color {
        currentTheme.color
        }
    var score: Int {
            model.score
        }
    @Published private var model: MemoryGame<String> = createMemoryGame(theme: themes.randomElement()!)
    private(set) var currentTheme: Theme = themes.randomElement()!

    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    func shuffle() {
        model.shuffle()
        objectWillChange.send()
    }
    func newGame() {
           currentTheme = EmojiMemoryGame.themes.randomElement()!
           model = EmojiMemoryGame.createMemoryGame(theme: currentTheme)
       }
       
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        
    }
    struct Theme {
           let name: String
           let emojis: [String]
           let numberOfPairs: Int
           let color: Color
           
       }
}


