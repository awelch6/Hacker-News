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
    
    let storyInformationLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.6509608626, green: 0.6733736396, blue: 0.7168717384, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "Futura", size: 12)
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.6509608626, green: 0.6733736396, blue: 0.7168717384, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 12)
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    
    let commentButton = UIButton()
    
    private var story: Story?
    
    weak var delegate: StoryDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = layer.cornerRadius
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    public func display(viewModel: StoryViewModel) {
        self.story = viewModel.story        
        titleLabel.text = viewModel.story.title
        storyInformationLabel.text = viewModel.storyInformation
        commentsLabel.text = viewModel.comments
    }
    
    private func configureView() {
        backgroundColor = UIColor(red: 0.2190627456, green: 0.2282821834, blue: 0.2461982667, alpha: 1)
        
        setCommentButton()
        setCommentsLabel()
        setTitle()
        setStoryInformationLabel()
    }
    
    private func setCommentButton() {
        addSubview(commentButton)
        commentButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.width.equalTo(25)
        }
        commentButton.setImage(UIImage(named: "chat-5"), for: .normal)
        commentButton.addTarget(self, action: #selector(commentButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setCommentsLabel() {
        addSubview(commentsLabel)
        commentsLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(commentButton)
            make.top.equalTo(commentButton.snp.bottom).inset(-5)
        }
    }
    
    private func setTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.right.equalTo(commentButton.snp.left)
            make.left.equalToSuperview().inset(15)
        }
    }
    
    private func setStoryInformationLabel() {
        addSubview(storyInformationLabel)
        storyInformationLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
            make.right.equalTo(commentButton.snp.left).inset(10)
        }
    }

    @objc private func commentButtonPressed(_ sender: UIButton) {
        guard let story = self.story else { return }
        delegate?.story( story, wasSelected: true)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
