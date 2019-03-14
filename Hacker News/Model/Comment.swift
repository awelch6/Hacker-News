//
//  Commwnr.swift
//  Hacker News
//
//  Created by Austin Welch on 2/23/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//
//   let comment = try? newJSONDecoder().decode(Comment.self, from: jsonData)

import Foundation

public struct Comment: Codable {
    public let by: String
    public let id: Int
    public let kids: [Int]
    public let parent: Int
    public let text: String
    public let time: Int
    public let type: String
    
    public var depth: Int = 0
}
