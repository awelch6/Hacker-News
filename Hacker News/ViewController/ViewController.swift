//
//  ViewController.swift
//  Hacker News
//
//  Created by Austin Welch on 2/17/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
       
        return layout
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    
    let refreshControl = UIRefreshControl()

    public var stories: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchBarStyle = .minimal
        self.navigationItem.searchController = searchController

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        refreshControl.addTarget(self, action: #selector(didRefresh(_:)), for: .valueChanged)
        
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        collectionView.backgroundColor = UIColor(red: 0.1235393509, green: 0.1286152303, blue: 0.1434211135, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.9994125962, green: 0.4018217623, blue: 0, alpha: 1)
        
        getListOfStories()
    }
    
    private func getListOfStories() {
        APIClient.getListOfStoryIds(of: .top) { (storyIds, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let storyIds = storyIds {
                
                let newStoryIds = Array(storyIds[self.stories.count...self.stories.count + 30])
                
                APIClient.renderStory(for: newStoryIds, { [weak self] (stories, error) in
                    self?.stories.append(contentsOf: stories)
                    self?.collectionView.reloadData()
                    self?.refreshControl.endRefreshing()
                })
            }
        }
    }
    
    @objc private func didRefresh(_ sender: UIRefreshControl) {
       getListOfStories()
    }
}

extension ViewController:  UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Update.")
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? StoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.display(story: stories[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == stories.count - 1 && refreshControl.isRefreshing == false {
            getListOfStories()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleViewController = ArticleViewController(story: stories[indexPath.item])
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
}
