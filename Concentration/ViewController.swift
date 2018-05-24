//
//  ViewController.swift
//  Concentration
//
//  Created by Anky An on 19/5/18.
//  Copyright © 2018 Anky An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let halloweenTheme = Theme.init(themeColor: .black, cardColor: .orange, emojis: ["👻", "🎃", "👹", "😈", "🦇", "👽" ])
    let faceTheme = Theme.init(themeColor: .red, cardColor: .lightGray, emojis: ["😫", "😳", "😡", "😵", "😬", "🤭" ])
    let animalTheme = Theme.init(themeColor: .darkGray, cardColor: .green, emojis: ["😺", "🐶", "🐹", "🦋", "🦄", "🐥"])
    let foodTheme = Theme.init(themeColor: .purple, cardColor: .yellow, emojis: ["🍎", "🍇", "🍉", "🍓", "🌶", "🍒"])
    
    var emojiChoices: [String]?
    var themeColor: UIColor?
    var cardColor: UIColor?
    var emoji = [Int:String]()
    
    // lazy: only initialised when called, can't use didSet
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // Read only computed property
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var flipCount = 0 {
        // Property observer
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
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
    }
    
    func loadThemeSettings() {
        let themes = [halloweenTheme, faceTheme, animalTheme, foodTheme]
        let selectedThemeNumber = Int(arc4random_uniform(UInt32(themes.count)))
        emojiChoices = themes[selectedThemeNumber].emojis
        themeColor = themes[selectedThemeNumber].themeColor
        cardColor = themes[selectedThemeNumber].cardColor
        scoreLabel.textColor = cardColor
        flipCountLabel.textColor = cardColor
        newGameButton.setTitleColor(cardColor, for: .normal)
        emoji = [Int:String]()
        view.backgroundColor = themeColor
    }
    
    
    func updateViewFromModel() {
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
    }
    
    func emoji(for card: Card) -> String {
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else{
//            return "?"
//        }
        if emoji[card.identifier] == nil, emojiChoices!.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices!.count)))
            emoji[card.identifier] = emojiChoices!.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}

