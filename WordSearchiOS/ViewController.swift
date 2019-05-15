//
//  ViewController.swift
//  WordSearchiOS
//
//  Created by Anmol Bajaj on 2019-05-11.
//  Copyright © 2019 Anmol Bajaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // UI Labels for View
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var javaLabel: UILabel!
    @IBOutlet weak var variableLabel: UILabel!
    @IBOutlet weak var kotlinLabel: UILabel!
    @IBOutlet weak var objectiveCLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var swiftLabel: UILabel!
    var score = 0
    
    @IBAction func startNewGame(_ sender: UIButton) {
        refreshGrid()
        score = 0
        scoreLabel.text = String(score)
        wordCollectionView.reloadData()
    }
    
    
    // Hardcoded grid of values
    
    var  words : [[String]]  = [["Q","A","S","J","X","V","J","F","Z","C","A"],
                                ["W","W","E","G","C","J","J","Q","E", "D","D"],
                                ["D","B","E","K","C","R","H","V","A","X","G"],
                                ["M","N","Q","L","O","S","I","U","V","M","E"],
                                ["G","L","R","V","W","T","M","D","J","O","L"],
                                ["R","N","P","I","C","U","L","I","Z","B","O"],
                                ["Z","L","F","E","C","S","G","I","O","I","Q"],
                                ["F","T","J","A","V","A","J","F","N","L","K"],
                                ["C","B","V","A","R","I","A","B","L","E","E"],
                                ["O","E","F","V","X","B","U","S","K","E","L"],
                                ["O","E","F","V","X","B","U","S","K","E","W"]]
    
    let targetWords = ["KOTLIN", "JAVA", "SWIFT", "MOBILE", "VARIABLE", "OBJECTIVEC"]
    var totalRows = 10
    var totalColumns = 10

    var selectedWord = ""
    var selectedDir = -1
    var firstWordIndex:[Int] = [0,0]
    var lastWordIndex:[Int] = [0,0]
    var possibleWordSelections: [[Int]] = [[]]
    var north = false
    var west = false
    var south = false
    var east = false
    var northWest = false
    var northEast = false
    var southEast = false
    var southWest = false

    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    let cellIdentifier = "WordCell"
    
    /*ItemsPerRow variable is used in the UICollectionViewDelegateFlowLayout extension to
      set the number of items in a row in any screen size.
      Currently set to 11 for a 11x11 matrix
     Tested for: iPhone XR, iPhone 8, iPhone 5S.
     */
    private let itemsPerRow: CGFloat = 11
    private let sectionInsets = UIEdgeInsets(top: 0,
                                             left:0,
                                             bottom: 0,
                                             right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()

    }
    
    //Set up data source methods
    private func collectionViewSetup() {
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
    }
    
    // Generate random alphabet
    func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    // Create a new grid with random alphabets
    func createGrid() -> [[String]] {
        for row in 0...10{
            for column in 0...10 {
                words[row][column] = randomString(length: 1)
            }
        }
        print(words.forEach{print($0, terminator:"\n")})
        return words
    }
    
    
    // Generate a list of target words with some of them in reverse order
    func randomizeTargetWords(targetWords: [String]) -> [String] {
        var wordOrReverse: [String] = []
        var zeroOrOne = 0
        for word in targetWords{
            zeroOrOne = Int.random(in: 0...1)
            if zeroOrOne == 0 {
                wordOrReverse.append(word)
            } else {
                wordOrReverse.append(String(word.reversed()))
            }
        }
        print(wordOrReverse)
        return wordOrReverse
    }
    
    func refreshGrid() {
        createGrid()
        let randomizedWords = randomizeTargetWords(targetWords: targetWords)
        // [0,1] -> Word is placed vertically
        // [1,0] -> Word is placed horizontaly
        // [1,1] -> Word is placed diagonally
        let  directionOptions = [[0,1],[1,0],[1,1]]
        var direction: [Int] = []
        for randomWord in randomizedWords {
            // Choose the direction randomly from avilable directions
            direction = directionOptions[Int.random(in: 0...2)]
            print(direction)
            // Determine the placement on the grid
            var maxColumnPlacement = totalColumns
            var maxRowPlacement = totalRows
            
            // When the word needs to be placed vertically, the max column placement will be the number of columns
            if direction[0] == 0 {
                maxColumnPlacement = totalColumns
            } else { // Word to be placed horizonally or diagonally
                maxColumnPlacement = totalColumns - randomWord.count
            }
            // Determine maxRowPlacement
            if direction[1] == 0 {
                maxRowPlacement = totalRows
            } else {
                maxRowPlacement = totalRows - randomWord.count
            }
            
            print(maxRowPlacement)
            print(maxColumnPlacement)
            
            // Determine the row and column to place the word
            var row = Int.random(in: 0...maxRowPlacement)
            var column = Int.random(in: 0...maxColumnPlacement)
            
            for i in 0..<randomWord.count {
                print(randomWord)
                var wordStrToArray = Array(randomWord)
                words[row + direction[1]*i][column + direction[0]*i] = String(wordStrToArray[i])
            }
            
            print("Word \(randomWord) is at \(row) \(column)")
            
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WordCollectionViewCell
        cell.wordLabel.text = words[indexPath.section][indexPath.item]
        cell.wordLabel.textAlignment = NSTextAlignment.center;
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = wordCollectionView.cellForItem(at: indexPath) as! WordCollectionViewCell
        let unselectedColor = UIColor.white
        let selectedColor = UIColor.green
        var currentWordPosition = [indexPath.section,indexPath.item]
        if selectedWord.isEmpty {
            firstWordIndex = [indexPath.section, indexPath.item]
            lastWordIndex = [indexPath.section, indexPath.item]
        }
 
        print("First Word Initial")
        print(firstWordIndex)
        print("Last Word Initial")
        print(lastWordIndex)
        
        // Determine the direction after looking at first two selections
        setDirection(row: currentWordPosition[0], column: currentWordPosition[1])

        print("Selected direction is")
        print(selectedDir)

        // Check if the word being added can be added (Follows the word search logic of Horizonal, Verticle, or Diagonal selections)
        if (selectedWord.isEmpty || possibleToSelect(availableToSelect: possibleWordSelections, row: currentWordPosition[0], column:
            currentWordPosition[1])) {
            cell.backgroundColor = selectedColor //Initalize selected color to green
            // Check if the first word index is being updated. Prepend the value.
            if (currentWordPosition[0] == firstWordIndex[0]-1 || (currentWordPosition[0] == firstWordIndex[0]-1 && currentWordPosition[1] == firstWordIndex[0]-1) || (currentWordPosition[0]==firstWordIndex[0] && currentWordPosition[1]==firstWordIndex[1]-1) || currentWordPosition[0] == firstWordIndex[0] + 1 && currentWordPosition[1]==firstWordIndex[1]-1) {
                selectedWord = words[indexPath.section][indexPath.item] + selectedWord
            } else { // Otherwise, the last word is being updated and should be appended to the string.
                selectedWord.append(words[indexPath.section][indexPath.item])
            }
  
            print("Selected words")
            print(selectedWord)
            
            possibleWordSelections = nextDirection(row: indexPath.section, column: indexPath.item, lenOfWord: selectedWord.count+1)
            print("Possible word selections")
            print(possibleWordSelections)
            
        }
        // Already selected cell is selected again. Deselect the  cell.
        else if ((currentWordPosition[0] == lastWordIndex[0] && currentWordPosition[1] == lastWordIndex[1]))  {
            cell.backgroundColor = unselectedColor
            if selectedWord.count > 1 {
                selectedWord.removeLast()
                // update last word
                if east {
                    lastWordIndex = [lastWordIndex[0], lastWordIndex[1]-1]
                } else if south {
                    lastWordIndex = [lastWordIndex[0]-1, lastWordIndex[1]]
                } else if southEast {
                    lastWordIndex = [lastWordIndex[0]-1, lastWordIndex[1]-1]
                } else if northEast {
                    lastWordIndex = [lastWordIndex[0]+1, lastWordIndex[1]-1]
                } else if east {
                    lastWordIndex = [lastWordIndex[0],lastWordIndex[1]-1]
                }
                possibleWordSelections = nextDirection(row: lastWordIndex[0], column: lastWordIndex[1], lenOfWord: selectedWord.count+1)
            }
            // No word is selected. Reset all values.
            else {
                selectedWord.removeAll()
                firstWordIndex = [0,0]
                lastWordIndex = [0,0]
                possibleWordSelections.removeAll()
                north = false
                west = false
                south = false
                east = false
                northWest = false
                northEast = false
                southEast = false
                southWest = false
                selectedDir = -1
            }
        } else if (currentWordPosition[0] == firstWordIndex[0] && currentWordPosition[1] == firstWordIndex[1]) {
            cell.backgroundColor = unselectedColor
            
            print("Current word position")
            print(currentWordPosition)
            print("First Word Index")
            print(firstWordIndex)
            
            if selectedWord.count > 1 {
                print("Selected words after before removal")
                print(selectedWord)
                selectedWord.removeFirst()
                if north {
                    firstWordIndex = [firstWordIndex[0]+1, firstWordIndex[1]]
                    print("its north")
                } else if northWest {
                    firstWordIndex = [firstWordIndex[0]+1, firstWordIndex[1]+1]
                } else if west {
                    firstWordIndex = [firstWordIndex[0], firstWordIndex[1]+1]
                } else if southWest{
                    firstWordIndex = [firstWordIndex[0]-1, firstWordIndex[1]+1]
                }
                possibleWordSelections = nextDirection(row: firstWordIndex[0], column: firstWordIndex[1], lenOfWord: selectedWord.count+1)
                print("Selected words after first removal")
                print(selectedWord)
        } else {
            selectedWord.removeAll()
            firstWordIndex = [0,0]
            lastWordIndex = [0,0]
            possibleWordSelections.removeAll()
            north = false
            west = false
            south = false
            east = false
            northWest = false
            northEast = false
            southEast = false
            southWest = false
            selectedDir = -1
        }
    }
        // Check if the selected word on the grid matches one of the target words
        for i in targetWords{
            if selectedWord == i {
                print("YESS")
                updateScore()
                foundWords()
                selectedWord.removeAll()
                firstWordIndex.removeAll()
                lastWordIndex.removeAll()
                selectedDir = -1
            }
        }
    }
    
    // Determine if it is possible to select the word being selected
    func possibleToSelect(availableToSelect: [[Int]], row: Int, column: Int) -> Bool {
        for i in availableToSelect {
            if i[0] ==  row && i[1] == column {
                return true
            }
        }
        return false
    }
    
    
    func inRange(vari: Int)->Bool{
        if ( vari >= 0 && vari <= 10){
            return true
        }
        return false
    }
    
    // Return possible directions a user can select
    func nextDirection(row: Int,column: Int, lenOfWord: Int) -> [[Int]] {
        // First word being selected. Return 8 possible outcomes.
        if (selectedDir < 1 ) {
            return [[row-1,column-1],[row-1,column],[row-1,column+1],[row,column-1],[row,column+1],[row+1,column-1],[row+1,column],[row+1,column+1]]
        }
        // Word direction is horizontal
        else if(selectedDir == 1){
             // If the current word is in East, update 'lastWordIndex'
            if (column == lastWordIndex[1] + 1 && row == lastWordIndex[0]) {
                if (inRange(vari: lastWordIndex[1] + 1)) {
                    lastWordIndex[0] = row
                    lastWordIndex[1] = column
                    east = true // checked
                    print(lastWordIndex)
                }
            }
            // if the current word is in West, update 'firstWordIndex'
            if (column == firstWordIndex[1] - 1 && row == firstWordIndex[0]) {
                if (inRange(vari: firstWordIndex[1] - 1)) {
                    firstWordIndex[0] = row;
                    firstWordIndex[1] = column;
                    west = true
                }
            }
            // Return possible moves in the next select
            return [ [lastWordIndex[0], lastWordIndex[1] + 1 ], [firstWordIndex[0], firstWordIndex[1] - 1] ]
        }
        // Word direction is verticle
        else if(selectedDir == 2){
            // If word current word is in North, update 'firstWordIndex'
            if(row == firstWordIndex[0] - 1 && column == firstWordIndex[1]){
                if (inRange(vari: firstWordIndex[0] - 1)) {
                    firstWordIndex[0] = row
                    firstWordIndex[1] = column
                    north = true
                }
            }
            // If the current word is in South, update 'lastWordIndex'
            if (row == lastWordIndex[0] + 1 && column == lastWordIndex[1]) {
                if inRange(vari: lastWordIndex[0] + 1) {
                    lastWordIndex[0] = row
                    lastWordIndex[1] = column
                    south = true
                }
            }
            // Return possible moves in the next select
            return [ [lastWordIndex[0] + 1, lastWordIndex[1]] , [firstWordIndex[0] - 1, firstWordIndex[1]] ]
        }
        // Word direction is Diagonal Left
        else if (selectedDir == 3 ){
            // If the current word is in North East, update 'lastWordIndex'
            if (row == lastWordIndex[0]-1 && column == lastWordIndex[1]+1) {
                if (inRange(vari: lastWordIndex[0]-1) && inRange(vari: lastWordIndex[1]+1)){
                    lastWordIndex[0] = row
                    lastWordIndex[1] = column
                    northEast = true
                }
            }
            // if the current word is in North West, update 'firstWordIndex'
            if (row == firstWordIndex[0]+1 && column == firstWordIndex[1]-1) {
                if (inRange(vari: firstWordIndex[0]+1) && inRange(vari: firstWordIndex[1]-1)){
                    firstWordIndex[0] = row
                    firstWordIndex[1] = column
                    southWest = true
                }
            }
            // Return possible moves in the next select
            return [[lastWordIndex[0] - 1, lastWordIndex[1] + 1], [firstWordIndex[0] + 1, firstWordIndex[1] - 1] ]
        }
        // Word direction is Diagonal Right
        else if (selectedDir == 4){
            // if the current word is in North West, update 'firstWordIndex'
            if(row == firstWordIndex[0] - 1 && column == firstWordIndex[1] - 1) {
                if (inRange(vari: firstWordIndex[0] - 1) && inRange(vari: firstWordIndex[1] - 1)) {
                    firstWordIndex[0] = row
                    firstWordIndex[1] = column
                    northWest = true
                }
            }
            // If the current word is in South East, update 'lastWordIndex'
            if (row == lastWordIndex[0] + 1 && column == lastWordIndex[1]+1) {
                if (inRange(vari: lastWordIndex[0]+1) && inRange(vari: lastWordIndex[1]+1)) {
                    lastWordIndex[0] = row
                    lastWordIndex[1] = column
                    southEast = true
                }
            }
            // Return possible moves in the next select
            return [ [lastWordIndex[0] + 1, lastWordIndex[1] + 1] , [firstWordIndex[0] - 1, firstWordIndex[1] - 1 ]]
        }
        return [[]]
    }
    
    // A red "strikethough" line appears over the word labels as they are found in the word search
    func foundWords() {
        if (selectedWord == "JAVA" ) {
            javaLabel.attributedText = selectedWord.strikeThrough()
        } else if selectedWord == "SWIFT" {
            swiftLabel.attributedText = selectedWord.strikeThrough()
        } else if selectedWord == "VARIABLE"{
            variableLabel.attributedText = selectedWord.strikeThrough()
        } else if selectedWord == "KOTLIN" {
            kotlinLabel.attributedText = selectedWord.strikeThrough()
        } else if selectedWord == "OBJECTIVEC" {
            objectiveCLabel.attributedText = selectedWord.strikeThrough()
        } else if selectedWord == "MOBILE" {
            mobileLabel.attributedText = selectedWord.strikeThrough()
        }
    }
    
    // Update the "Found" score as words are found by the user
    func updateScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    // Direction can only be set after the user has made atleast 2 selections on the grid
    func setDirection(row: Int, column: Int) {
        if selectedWord.count == 1 {
            //Horizontal
            if (firstWordIndex[0] == row){
                selectedDir = 1
            }
                //Verticle
            else if(firstWordIndex[1] == column){
                selectedDir = 2
            }
                //Diagonal Left
            else if((row == firstWordIndex[0] + 1 && column == firstWordIndex[1] - 1) || (row == firstWordIndex[0]-1 && column == firstWordIndex[1] + 1)){
                selectedDir = 3
            }
                //Diagonal Right
            else{
                selectedDir = 4
            }
            lastWordIndex = [row,column]

        }
    }
    
}
    


// MARK: - Collection View Flow Layout Delegate
// Ensure that every row has atleast 10 words
// Code snippet inspired by: https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started
extension ViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}


//Extend UIColor to generate random colors for cell background color.
extension UIColor {
    static func random () -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0)
    }
}


// Allow a red "strikethough" line over the word when it is found in the word search
extension String{
    func strikeThrough()->NSAttributedString{
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

