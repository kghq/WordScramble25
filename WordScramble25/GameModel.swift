//
//  GameModel.swift
//  WordScramble25
//
//  Created by Krzysztof Garmulewicz on 24/06/2025.
//

import Foundation
import SwiftUI

@Observable
class GameModel {
    var wordsArray: [String] = []
    
    var usedWords: [String] = []
    var userWord: String = ""
    var rootWord: String = ""
    var score: Int = 0

    var showingAlert: Bool = false
    var errorTitle: String = ""
    var errorMessage: String = ""
    
    init() {
        startGame()
    }
    
    func submitWord() {
        let word = userWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard !word.isEmpty else { return }

        guard isReal(word: word) else {
            return wordError(title: "Non-Existent Word", message: "That word is not in the English language. Try again!")
        }

        guard isValid(word: word) else {
            return wordError(title: "Invalid Word", message: "Your word must be a subset of the current word. Try again!")
        }

        guard isOriginal(word: word) else {
            return wordError(title: "Word Used Before", message: "You have already used this word. Try again!")
        }

        withAnimation {
            usedWords.insert(word, at: 0)
            score += word.count
        }

        userWord = ""
    }
    
    func startGame() {
        
        if let wordsFile = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let wordsList = try? String(contentsOf: wordsFile, encoding: .utf8) {
                wordsArray = wordsList.components(separatedBy: "\n")
            } else {
                fatalError("Could not load start.txt from bundle")
            }
        } else {
            fatalError("Could not load start.txt from bundle")
        }
        
        withAnimation() {
            usedWords = []
            score = 0
        }
        rootWord = wordsArray.randomElement() ?? "silkworm"
    }
    
    func newGame() {
        withAnimation() {
            usedWords = []
            score = 0
        }
        
        rootWord = wordsArray.randomElement() ?? "silkworm"
    }
    
    private func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    private func isValid(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }

    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelled = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )

        return misspelled.location == NSNotFound
    }

    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingAlert = true
        userWord = ""
    }
}
