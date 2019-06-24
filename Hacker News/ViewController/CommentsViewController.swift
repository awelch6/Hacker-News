//
//  CommentsViewController.swift
//  Hacker News
//
//  Created by Austin Welch on 2/23/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import UIKit

class CommentDetailView: UIView {
    
    private let story: Story
    
    init(story: Story) {
        self.story = story
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class CommentsViewController: UIViewController {
   
    let tableView = UITableView()
    
    let refreshControl = UIRefreshControl()
    
    public var comments: [Comment] = []
    
    private var story: Story {
        didSet {
            APIClient.getComments(for: story) { (comments) in
                self.comments = comments
                self.tableView.reloadData()
            }
        }
    }
    
    init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
        
        defer { self.story = story }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "cell")
        
        refreshControl.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
        tableView.alwaysBounceVertical = true
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = UIColor(red: 0.1235393509, green: 0.1286152303, blue: 0.1434211135, alpha: 1)
        
        tableView.tableHeaderView = CommentDetailView(story: story)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.9994125962, green: 0.4018217623, blue: 0, alpha: 1)
    }

    @objc private func didRefresh(_ sender: UIRefreshControl) {
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return comments[indexPath.row].kids.count
    }
}

class CommentTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
