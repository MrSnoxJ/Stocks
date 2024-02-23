//
//  ViewController.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 13.12.2023.
//

import UIKit
import FloatingPanel
class WatchListViewController: UIViewController {

    
    private var searchTimer: Timer?
    private var panel: FloatingPanelController?
    
    
    
    //Comment Model
    private var watchListMap:[String :[CandleStick]] = [:]
    
    //Comment ViewModel
    
    private var viewModels : [WatchListTableViewCell.ViewModel] = []
    private let tableView : UITableView = {
       let table = UITableView()
        table.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSearchController()
        setUpTableView()
        fetchUpWatchListData()
        setUpFloatingPanel()
        setUpTitleView()
        
       
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func fetchUpWatchListData() {
        let symbols = PersistenceManager.shared.watchlist
        
        
        let group = DispatchGroup()
        
        for symbol in symbols {
            group.enter()
            APICaller.shared.merketData(for: symbol) { [weak self] result in
                defer{
                    group.leave()
                }
                switch result{
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchListMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
       
        group
            .notify(queue: .main) {[weak self] in
                self?.createViewModel()
                self?.tableView.reloadData()
            }
    }
    
    
    private func createViewModel () {
        var viewModels = [WatchListTableViewCell.ViewModel]()
        for(symbol , candleSticks) in watchListMap {
            
            let changePercentage = getChangePercentage(symbol: symbol, for: candleSticks)
            viewModels.append(.init(symbol: symbol, companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company", price: getLatestClosingPrice(from: candleSticks), changeColor: changePercentage < 0 ? .systemRed : .systemGreen, changePercentage: .persentage(from: changePercentage)))
        }
        
        
        self.viewModels = viewModels
    }
    
    
    private func getChangePercentage( symbol : String ,for data : [CandleStick]) -> Double {
        let today = Date()
        let latestDate = data[0].date
      guard let latestClose = data.first?.close,
            let prioreClose = data.first(where: {
                !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
            })?.close else {
            return 0
        }
        
        let diff = 1 - ( prioreClose/latestClose)
        print("\(symbol): \(diff)%")
        return diff
    }
    
    private func getLatestClosingPrice (from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else {
            return ""
        }
        
        return String.formatted(number: closingPrice)
    }
    
    private func setUpTableView () {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpFloatingPanel() {
        let vc = NewsViewController(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
        
    }
    private func setUpTitleView () {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        titleView.addSubview(label)
        
        navigationItem.titleView = titleView
    }
    private func setUpSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        
        navigationItem.searchController = searchVC
    }
    
}

extension WatchListViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, 
                let resultsVS = searchController.searchResultsController as? SearchResultsViewController,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        //Comment user finished taping
        //Comment reset timer
        searchTimer?.invalidate()
        //Comment Call API
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false , block: { _ in //Comment Do not call timer every time when press the key on keybord 0.3 is time between every API call if user is typing fast
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultsVS.update(with: response.result)
                    }
                case .failure(let error):		
                    DispatchQueue.main.async {
                        resultsVS.update(with: [])
                    }
                    print(error)
                }
            }
        })
        //Comment update result controller
        
    }
}
extension WatchListViewController  : SearchResultsViewControllerDelegate{
    func searchResultsViewControllerDidSelect(searchResult: SearchResults) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        let vc = StockDetailsViewController(symbol: searchResult.displaySymbol,
                                            companyName: searchResult.description,
                                            candleStickData: [])
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
}
extension WatchListViewController : FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full //Comment when move FloatinPanel all the way to the top title will hide
    }
}
extension WatchListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier, for: indexPath) as? WatchListTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = viewModels[indexPath.row]
        let vc = StockDetailsViewController(symbol: viewModel.symbol,
                                            companyName: viewModel.companyName,
                                            candleStickData: watchListMap[viewModel.symbol] ?? [])
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
        
    }
}
