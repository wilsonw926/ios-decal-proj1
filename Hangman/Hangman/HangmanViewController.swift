//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Modified by Wilson Wang on 2/18/17.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {

    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var HangmanState: UIImageView!
    @IBOutlet weak var WordLabel: UILabel!
    @IBOutlet weak var GuessedLetters: UILabel!
    @IBOutlet weak var LettersInput: UITextField!
    @IBOutlet weak var GuessButton: UIButton!
    
    var phrase: String = ""
    var phraseArray: [Character] = []
    var phraseSet = Set<String>()
    var phraseLength: Int?
    
    //used to track if character has been guessed yet
    var correctGuesses: [Bool] = []
    
    var incorrectGuesses: [String] = []
    var wrongGuessesCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HangmanState.image = UIImage(named: "hangman1.png")
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        phrase = hangmanPhrases.getRandomPhrase()
        
        //NEW GAME RESET
        GuessedLetters.text = "Previous Guesses: "
        WordLabel.text = ""
        correctGuesses = []
        incorrectGuesses = []
        wrongGuessesCount = 1
        
        //storing characters into Array
        phraseArray = [Character](phrase.characters)
        phraseLength = phraseArray.count
        phraseSet = Set<String>()
        
        //searched stackoverflow for adding values into Boolean Array
        correctGuesses = [Bool](repeating: false, count: phraseLength!)
        let range = 0..<phraseLength!
        for index in range {
            if (String(phraseArray[index]) == " ") {
                correctGuesses[index] = true
            }
        }
        
        for i in phraseArray {
            phraseSet.insert(String(i))
        }
        
        WordBlanks()
        print(phrase)
    }

    //This is what's displayed on the screen: "AB- D-FGH IJ--MNOP..."
    func WordBlanks() {
        WordLabel.text = ""
        LettersInput.text = ""
        let range = 0..<phraseLength!
            for index in range {
                if (phraseArray[index] == " ") {
                    WordLabel.text! += " "
                }
                if correctGuesses[index] {
                    WordLabel.text! += String(phraseArray[index])
                }
                else {
                    WordLabel.text! += "- "
                }
            }
    }
    
    func determineWinner() -> Bool {
        for index in 0...phraseLength!-1 {
            if (correctGuesses[index] == false) {
                return false
            }
        }
        return true
    }
    
    @IBAction func GuessAction(_ sender: UIButton) {
        let guessedLetter = LettersInput.text
        if guessedLetter!.characters.count == 1 {
            if (phraseSet.contains(guessedLetter!)) {
                for index in 0...phraseLength!-1 {
                    if guessedLetter == String(phraseArray[index]) {
                        correctGuesses[index] = true
                    }
                WordBlanks()
                }
                if (determineWinner()) {
                    let alertController = UIAlertController(
                        title: "You Won!!",
                        message: "Play Again?",
                        preferredStyle: .alert)
                    let newGame = UIAlertAction(title: "Sure!!", style: .default) {
                        action in self.viewDidLoad()
                    }
                    alertController.addAction(newGame)
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                if !incorrectGuesses.contains(String(guessedLetter!)) {
                    incorrectGuesses.insert(String(guessedLetter!), at: wrongGuessesCount - 1)
                    wrongGuessesCount += 1
                }
                let picture = "hangman" + String(wrongGuessesCount) + ".png"
                HangmanState.image = UIImage(named: picture)
                WordBlanks()
                if wrongGuessesCount > 6 {
                    let alertController = UIAlertController(
                        title: "You Lost :(",
                        message: "Play Again?",
                        preferredStyle: .alert)
                    let newGame = UIAlertAction(title: "New Game?", style: .default) {
                        action in self.viewDidLoad()
                    }
                    alertController.addAction(newGame)
                    self.present(alertController, animated: true, completion: nil)
                }
                GuessedLetters.text = String(describing: incorrectGuesses)
            }
        } else {
            LettersInput.text = ""
            WordBlanks()
        }
    }
    
    
    @IBAction func TypedLetter(_ sender: UITextField) {
        if LettersInput.text!.characters.count != 1 {
            LettersInput.text = ""
        }
    }
    
    @IBAction func NewGame(_ sender: UIButton) {
        print("NEW GAME!!!")
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
