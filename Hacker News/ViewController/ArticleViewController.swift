//
//  ArticleViewController.swift
//  Hacker News
//
//  Created by Austin Welch on 2/17/19.
//  Copyright © 2019 Austin Welch. All rights reserved.
//

import WebKit

class ArticleViewController: UIViewController {
    
    private let story: Story
    private let webView = WKWebView()

    init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: story.url)!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ArticleViewController: WKNavigationDelegate { }
