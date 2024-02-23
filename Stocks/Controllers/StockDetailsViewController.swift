//
//  StockDetailsViewController.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 13.12.2023.
//

import UIKit

class StockDetailsViewController: UIViewController {

    //Comment Symbol, name , data
    
    private let symbol : String
    private let companyName : String
    private let candleStickData : [CandleStick]
    
    
    
    init(symbol : String,
         companyName : String,
         candleStickData : [CandleStick] = []
    ){
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    



}
