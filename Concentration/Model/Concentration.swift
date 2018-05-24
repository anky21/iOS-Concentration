//
//  Concentration.swift
//  Concentration
//
//  Created by Anky An on 20/5/18.
//  Copyright © 2018 Anky An. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    
    private(set) var score = 0
    
    private(set) var cardsSeen = [Int]()
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the carsd")
            
        flipCount += 1
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    updateScore(index: index)
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
                
                updateScore(index: index)
            }
        }
    }
    
    // Update the score
    func updateScore(index: Int) {
        if cardsSeen.contains(cards[index].identifier) {
            score -= 1
        } else {
            cardsSeen.append(cards[index].identifier)
        }
    }
    
    // Shuffle cards
    func shuffleCards() {
        for index in cards.indices {
            cards.swapAt(index, Int(arc4random_uniform(UInt32(cards.count))))
        }
    }
    
    func startNewGame() {
        flipCount = 0
        score = 0
        cardsSeen = [Int]()
        indexOfOneAndOnlyFaceUpCard = nil
        
        shuffleCards()
        
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): must have at least 1 pair of cards")
        
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards.append(card)
            cards.append(card)
            
            // cards += [card, card]
        }
        
        // Shuffle the cards
        shuffleCards()
    }
}
