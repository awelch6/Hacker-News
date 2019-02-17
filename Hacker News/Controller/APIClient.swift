//
//  Authentication.swift
//  Hacker News
//
//  Created by Austin Welch on 2/17/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import Alamofire

public enum StoryType: String {
    case best, new, top
    
    var endPoint: String {
        switch self {
        case .best: return "beststories.json"
        case .new: return "newstories.json"
        case .top: return "topstories.json"
        }
    }
}

public struct APIClient {
    
    static public func getListOfStoryIds(of type: StoryType,_ completion: @escaping (StoryIds?, Error?) -> Void) {
        
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/\(type.endPoint)")!
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                completion(nil, error)
            } else if let data = response.data {
                let stories = try? JSONDecoder().decode(StoryIds.self, from: data)
                completion(stories, nil)
            }
        }
    }
    
    static public func renderStory(for storyIds: [Int],_ completion: @escaping ([Story], Error?) -> Void) {
        let group = DispatchGroup()

        let urlString = "https://hacker-news.firebaseio.com/v0/item"
        
        var stories: [Story] = []
        var someError: Error? = nil
        
        for id in storyIds {
            group.enter()

            Alamofire.request(URL(string: "\(urlString)/\(id).json")!, method: .get).responseJSON { (response) in
                defer { group.leave() }
                
                if let error = response.error {
                    someError = error
                } else if let data = response.data {
                    guard let story = try? JSONDecoder().decode(Story.self, from: data) else { return }
                    stories.append(story)
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(stories, nil)
        }
    }
}
