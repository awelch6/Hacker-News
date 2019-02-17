//
//  Story.swift
//  Hacker News
//
//  Created by Austin Welch on 2/17/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import Foundation

public struct Story: Codable {
    let by: String
    let descendants, id: Int
    let kids: [Int]
    let score, time: Int
    let title, type: String
    let url: String
}
