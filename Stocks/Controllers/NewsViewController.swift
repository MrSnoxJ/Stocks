//
//  TopStoriesViewController.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 13.12.2023.
//

import UIKit
import SafariServices //Comment open a link (news)
class NewsViewController: UIViewController {
    
    
    
    public let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifire)
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifire)
        table.backgroundColor = .clear
        return table
    }()
    private var stories = [NewsStory]()
    
    
    private let type : Type
    enum `Type` { //Comment name of the enum
        case topStories
        case company(symbol : String)
        
        var title : String {
            switch self {
            case .topStories:
                return "Top stories"
            case .company(let symbol):
                return symbol.uppercased()
            }
        }
    }
    
    init(type : Type){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //Comment Private
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func fetchNews() {
        
        APICaller.shared.news(for: type) { [weak self ] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async{
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }  
        
    }
    
    private func open(url : URL) {

        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
}
extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifire, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifire) as? NewsHeaderView else {return nil}
        header.configure(with: .init(title: self.type.title, shouldShowAddButton: false))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Comment new story
        let story = stories[indexPath.row]
        guard let url = URL(string: story.url)else{
            presentFailedToOpenAlert()
            return
        }
        open(url: url)
    }
    
    
    private func presentFailedToOpenAlert() {
        let alert = UIAlertController(title: "Unable to open", message: "I can't open it", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
