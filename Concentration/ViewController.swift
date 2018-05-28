//
//  ViewController.swift
//  Concentration
//
//  Created by Anky An on 19/5/18.
//  Copyright © 2018 Anky An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let halloweenTheme = Theme.init(themeColor: .black, cardColor: .orange, emojis: "👻🎃👹😈🦇👽" )
    private let faceTheme = Theme.init(themeColor: .red, cardColor: .lightGray, emojis: "😫😳😡😵😬🤭" )
    private let animalTheme = Theme.init(themeColor: .darkGray, cardColor: .green, emojis: "😺🐶🐹🦋🦄🐥")
    private let foodTheme = Theme.init(themeColor: .purple, cardColor: .yellow, emojis: "🍎🍇🍉🍓🌶🍒")
    
    private var emojiChoices: String?
    private var themeColor: UIColor?
    private var cardColor: UIColor?
    private var emoji = [Card:String]()
    
    // lazy: only initialised when called, can't use didSet
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // Read only computed property
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : cardColor!
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private(set) var flipCount = 0 {
        // Property observer
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private(set) var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    @IBOutlet private weak var flipCountLabel: UILabel!
//        {
//        didSet {
//            updateFlipCountLabel()
//        }
//    }
    
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            flipCount = game.flipCount
            score = game.score
            updateViewFromModel()
        }
    }
    
    override func viewDidLoad() {
        loadThemeSettings()
        updateFlipCountLabel()
    }
    
    private func loadThemeSettings() {
        let themes = [halloweenTheme, faceTheme, animalTheme, foodTheme]
        let selectedThemeNumber = themes.count.arc4random
        emojiChoices = themes[selectedThemeNumber].emojis
        themeColor = themes[selectedThemeNumber].themeColor
        cardColor = themes[selectedThemeNumber].cardColor
        scoreLabel.textColor = cardColor
        flipCountLabel.textColor = cardColor
        newGameButton.setTitleColor(cardColor, for: .normal)
        emoji = [Card:String]()
        view.backgroundColor = themeColor
    }
    
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : cardColor
            }
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game.startNewGame()
        flipCount = game.flipCount
        score = game.score
        loadThemeSettings()
        updateViewFromModel()
        updateFlipCountLabel()
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices!.count > 0 {
            let randomStringIndex = emojiChoices?.index(emojiChoices!.startIndex, offsetBy: emojiChoices!.count.arc4random)
            emoji[card] = String(emojiChoices!.remove(at: randomStringIndex!))
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
