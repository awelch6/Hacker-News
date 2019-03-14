//
//  Profile.swift
//  Hacker News
//
//  Created by Austin Welch on 2/23/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

public struct Profile: Codable {
    public let about: String
    public let created: Int
    public let id: String
    public let karma: Int
    public let submitted: [Int]
}
