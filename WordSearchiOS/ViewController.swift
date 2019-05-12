//
//  ViewController.swift
//  WordSearchiOS
//
//  Created by Anmol Bajaj on 2019-05-11.
//  Copyright © 2019 Anmol Bajaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    var score = 0
    
    let  words = [["Q","A","S","J","X","V","J","F","Z","C"],
                 ["W","W","E","G","C","J","J","Q","E", "D"],
                 ["D","B","E","K","C","R","H","V","A","X"],
                 ["M","N","Q","L","O","S","I","U","V","M"],
                 ["G","L","R","V","W","T","M","D","J","O"],
                 ["R","N","P","I","C","U","L","I","Z","B"],
                 ["Z","L","F","E","C","S","G","I","O","I"],
                 ["F","T","J","A","V","A","J","F","N","L"],
                 ["C","B","V","A","R","I","A","B","L","E"],
                 ["O","E","F","V","X","B","U","S","K","E"]]
    
    let targetWords = ["KOTLIN", "JAVA","VARIABLE","OBJECTIVEC","MOBILE", "SWIFT"]
    var selectedWord  = ""

    
    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    let cellIdentifier = "WordCell"
    
    /*ItemsPerRow variable is used in the UICollectionViewDelegateFlowLayout extension to
      set the number of items in a row in any screen size.
      Currently set to 10 for a 10x10 matrix
     Tested for: iPhone XR, iPhone 8, iPhone 5S.
     */
    private let itemsPerRow: CGFloat = 10
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
        // The random() generates dark colors sometimes, which make the black word font unreadable. Come back to it.
        //cell.backgroundColor = UIColor.random()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = wordCollectionView.cellForItem(at: indexPath) as! WordCollectionViewCell
        let unselectedColor = UIColor.white
        let selectedColor = UIColor.green
        
        if cell.backgroundColor == unselectedColor {
            cell.backgroundColor = selectedColor
            selectedWord.append(words[indexPath.section][indexPath.item])
        } else {
            cell.backgroundColor = unselectedColor
            if selectedWord.isEmpty == false { selectedWord.removeLast() }
        }
        print(indexPath.section,indexPath.item)
        print(words[indexPath.section][indexPath.item])
        print(selectedWord)
        for i in targetWords{
            if selectedWord == i {
                print("YESS")
                score += 1
                scoreLabel.text = String(score)
                selectedWord.removeAll()
            }
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

