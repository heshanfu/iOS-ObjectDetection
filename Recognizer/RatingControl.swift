//
//  RatingControl.swift
//  Recognizer
//
//  Created by AdamZJK on 21/05/2017.
//  Copyright © 2017 AdamZJK. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    let generalPositiveWords:[String] = ["not bad", "good", "nice", "better", "accurate",]
    let veryPositiveWords:[String] = ["impressive", "supris", "great"]
    let negativeWords:[String] = ["bad", "not good"]
    
    func sentimentAnalysisAndAdjustScore(text: String) {
        let text = text.lowercased()
        var score:Int = 3
        // bad
        if text.range(of: "not bad") != nil{
            score += 1
        } else if text.range(of: "bad") != nil{
            score -= 2
        }
        // good
        if text.range(of: "not good") != nil{
            score -= 1
        } else if text.range(of: "good") != nil{
            score += 1
        }
        if text.range(of: "nice") != nil {score += 1}
        if text.range(of: "accurate") != nil {score += 1}
        if text.range(of: "impressive") != nil {score += 2}
        if text.range(of: "great") != nil {score += 2}
        
        if text.range(of: "very") != nil {
            if score > 3{
                score += 1;
            }
            if score < 3{
                score -= 1;
            }
        }
        
        if text.range(of: "awful") != nil {score -= 2}
        if text.range(of: "acceptable") != nil {score = 3}
        
        
        if score > 5 { score = 5 }
        if score < 0 { score = 0 }
        
        print(text)
        self.rating = score
    }
    
    private func setupButtons() {
        
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(filledStar, for: .highlighted)
            button.setImage(filledStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    
    

}
