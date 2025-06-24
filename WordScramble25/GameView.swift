//
//  ContentView.swift
//  WordScramble25
//
//  Created by Krzysztof Garmulewicz on 24/06/2025.
//

// persistence: save the previous games
// spellchecker as a utility

import SwiftUI

struct GameView: View {
    
    @Bindable var game = GameModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("enter your word", text: $game.userWord)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .onSubmit(game.submitWord)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Score:")
                        Text("\(game.score)")
                            .bold()
                        Spacer()
                    }
                }
                
                Section {
                    ForEach(game.usedWords, id: \.self) {
                        Text("\(Image(systemName: "\($0.count).circle")) \($0)")
                    }
                }
            }
            .navigationTitle(game.rootWord)
            .toolbar() {
                Button("New Game") {
                    game.newGame()
                }
            }
        }
        .onAppear(perform: game.startGame)
        .alert(game.errorTitle, isPresented: $game.showingAlert) { } message: {
            Text(game.errorMessage)
        }
    }
    
}

#Preview {
    GameView()
}
