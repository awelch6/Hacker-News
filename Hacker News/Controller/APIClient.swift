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
    
    public static func getListOfStoryIds(of type: StoryType,_ completion: @escaping (StoryIds?, Error?) -> Void) {
        
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
    
    public static func renderStory(for storyIds: [Int],_ completion: @escaping ([Story], Error?) -> Void) {
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
    
    public static func getUserProfile(_ username: String, completion: @escaping (Profile?, Error?) -> Void) {
        let urlString: String = "https://hacker-news.firebaseio.com/v0/user/\(username).json"
        
        Alamofire.request(URL(string: urlString)!, method: .get).responseJSON { (response) in
            if let data = response.data {
               let profile = try? JSONDecoder().decode(Profile.self, from: data)
                completion(profile, response.error)
            } else {
                completion(nil, response.error)
            }
        }
    }
    
    public static func getComments(for story: Story,_ completion: @escaping ([Comment]) -> Void) {
        let group = DispatchGroup()
        var comments: [Comment] = []
        
        for kid in story.kids {
            group.enter()
            let urlString: String = "https://hacker-news.firebaseio.com/v0/item/\(kid).json"
            
            Alamofire.request(URL(string: urlString)!, method: .get).responseComment { (response) in
                if let comment = response.value {
                    comments.append(comment)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(comments)
        }
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseComment(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Comment>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
