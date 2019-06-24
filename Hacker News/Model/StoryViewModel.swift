//
//  StoryViewModel.swift
//  Hacker News
//
//  Created by Austin Welch on 2/23/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import Foundation

public struct StoryViewModel: Codable {
    
    public let story: Story
    
    public var storyInformation: String {
        var host: String = ""
        
        if let urlHost = URL(string: story.url)?.host {
            host = "(\(urlHost))"
        }
        
        return "by: \(story.by) | \(story.score) points | \(host)"
    }
    
    public var comments: String {
        return "\(story.descendants)"
    }
    
    public var points: String {
        return "\(story.score)"
    }
}
