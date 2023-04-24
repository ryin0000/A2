//VIEW
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Richard Yin on 4/3/23.
//

import SwiftUI
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var emojis: [String] = []


    var body: some View {
        VStack{
            Button("New Game"){
                viewModel.newGame()
            }
            Text("Score: \(viewModel.score)")
                           .font(.subheadline)
                           .foregroundColor(viewModel.themeColor)
                       
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
        }
        
        .foregroundColor(viewModel.themeColor)
        .padding()
    }


    func themeChange(arrayName: Array<String>, text: String, titleText: String) -> some View {
        Button(action: {
            emojis = arrayName;
            emojis.shuffle()

        }, label: {
            VStack{
                Image(systemName: text)
                Text(titleText).font(.system(size: 12))
            }
        })

    }

    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0){
            //can't for for in view
            ForEach(viewModel.cards) { card in //index is set to 0, asked to make view for 0, etc. for each keeps track of them
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                
                
            }
        }
        .foregroundColor(viewModel.themeColor) // Set the theme color for the cards
    }
    
    
    
    struct CardView: View {
        let card: MemoryGame<String>.Card
        
        init(_ card: MemoryGame<String>.Card){
            self.card = card
        }
        var body: some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                Group {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text(card.content)
                        .font(.system(size:200))
                        .minimumScaleFactor(0.01)
                        .aspectRatio(1, contentMode: .fit)
                }
                    .opacity(card.isFaceUp ? 1: 0)
                base.fill()
                    .opacity(card.isFaceUp ? 0: 1)
                
                
            }
            .opacity(card.isFaceUp || !card.isMatched ? 1:0)
        }
    }
}
        struct EmojiMemoryGameView_Preview: PreviewProvider {
        static var previews: some View {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
    

