//
//  ViewController.swift
//  Hacker News
//
//  Created by Austin Welch on 2/17/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    public var stories: [Story] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        APIClient.getListOfStoryIds(of: .top) { [weak self] (storyIds, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let storyIds = storyIds {
                
                APIClient.renderStory(for: storyIds, { (stories, error) in
                    self?.stories = stories
                    self?.tableView.reloadData()
                })
            }
        }
    }    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(stories[indexPath.row].title)
        
        return cell
    }
}
