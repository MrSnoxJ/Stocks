//
//  SearchResultViewController.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 13.12.2023.
//

import UIKit


protocol SearchResultsViewControllerDelegate : AnyObject {
    func searchResultsViewControllerDidSelect(searchResult : SearchResults)
    
}

class SearchResultsViewController: UIViewController {

    weak var delegate : (SearchResultsViewControllerDelegate)?
    
    private var results: [SearchResults] = []
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifire)
        table.isHidden = true
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTable()
       
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func setUpTable () {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    public func update(with results : [SearchResults]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }

}
extension SearchResultsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifire, for: indexPath)
        let model = results[indexPath.row]
        cell.textLabel?.text = model.displaySymbol
        cell.detailTextLabel?.text = model.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = results[indexPath.row]
        delegate?.searchResultsViewControllerDidSelect(searchResult: model)
    }
    
}
