//
//  StoryCollectionViewCell.swift
//  Hacker News
//
//  Created by Austin Welch on 2/22/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class StoryCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.9418521523, green: 0.9527716041, blue: 0.9624406695, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "Futura", size: 15)
        label.numberOfLines = 2
        label.sizeToFit()
        
        return label
    }()
    
    let likeIcon = LOTAnimationView(name: "animation-w128-h128")
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.6509608626, green: 0.6733736396, blue: 0.7168717384, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 12)
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.6509608626, green: 0.6733736396, blue: 0.7168717384, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 12)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.6509608626, green: 0.6733736396, blue: 0.7168717384, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 12)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        
        return label
    }()
    
    public var isLiked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    private var story: Story?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = layer.cornerRadius
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    public func display(story: Story) {
        self.story = story
        
        titleLabel.text = story.title
        pointsLabel.text = "\(story.score) points"
        authorLabel.text = "by: \(story.by)"
        commentsLabel.text = "\(story.descendants) comments"
    }
    
    private func configureView() {
        backgroundColor = UIColor(red: 0.2190627456, green: 0.2282821834, blue: 0.2461982667, alpha: 1)
        
        setLikeIcon()
        setTitle()
        setAuthorLabel()
        setCommentsLabel()
        setPointsLabel()
    }
    
    private func setLikeIcon() {
        addSubview(likeIcon)
        likeIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(55)
        }
        likeIcon.loopAnimation = false
        likeIcon.animationSpeed = 2.2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeIconPressed(_:)))
        likeIcon.addGestureRecognizer(tapGesture)
    }
    
    private func setTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.right.equalTo(likeIcon.snp.left)
            make.left.equalToSuperview().inset(15)
        }
    }
    
    private func setAuthorLabel() {
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped(_:)))
        authorLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setCommentsLabel() {
        addSubview(commentsLabel)
        commentsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(authorLabel.snp.right).inset(-10)
            make.bottom.equalToSuperview().inset(5)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commentLabelTapped(_:)))
        commentsLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setPointsLabel() {
        addSubview(pointsLabel)
        pointsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(likeIcon)
            make.top.equalTo(likeIcon.snp.bottom).inset(8)
        }
    }
    
    @objc private func authorLabelTapped(_ gesture: UITapGestureRecognizer) {
        print(authorLabel.text)
    }
    
    @objc private func commentLabelTapped(_ gesture: UITapGestureRecognizer) {
        print(commentsLabel.text)
    }
    @objc private func likeIconPressed(_ recognizer: UITapGestureRecognizer) {
        if !isLiked {
            likeIcon.play(toProgress: 0.5) { (_) in
                self.pointsLabel.text = "\(self.story!.score + 1) points"
            }
        } else {
            likeIcon.play(fromProgress: 0.5, toProgress: 1) { (_) in
                self.pointsLabel.text = "\(self.story!.score) points"
            }
        }
        isLiked = !isLiked
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind: String, linkURL: String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
