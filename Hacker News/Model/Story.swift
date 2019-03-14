//
//  Story.swift
//  Hacker News
//
//  Created by Austin Welch on 2/17/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import Foundation

public struct Story: Codable {
    public let by: String
    public let descendants, id: Int
    public let kids: [Int]
    public let score, time: Int
    public let title, type: String
    public let url: String
}
