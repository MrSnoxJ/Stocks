//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 15.12.2023.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {

    static let identifier = "WatchListTableViewCell"
    
    static let preferredHeight : CGFloat = 60
    
    struct ViewModel {
        let symbol : String
        let companyName : String
        let price : String
        let changeColor : UIColor
        let changePercentage : String
      //  let chartViewModel : StockChartView.ViewModel
    }
    
    
    private let  symbolLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight: .medium)
        
        return label
    }()
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight: .regular)
        
        return label
    }()
    private let  priceLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,weight: .regular)
        
        return label
    }()
    private let  changeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15,weight: .regular)
        
        return label
    }()
    
    private let miniChartView: StockChartView = {
       let chart = StockChartView()
        chart.backgroundColor = .link
        return chart
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(symbolLabel,nameLabel,miniChartView,priceLabel,changeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.sizeToFit()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        let yStart : CGFloat = (contentView.height - symbolLabel.height - nameLabel.height)/2
        symbolLabel.frame = CGRect(x: separatorInset.left, y: yStart, width: symbolLabel.width, height: symbolLabel.height)
        nameLabel.frame = CGRect(x: separatorInset.left, y: symbolLabel.bottom, width: nameLabel.width, height: nameLabel.height)
        priceLabel.frame = CGRect(x: contentView.width - 10 - priceLabel.width, y: 0, width: priceLabel.width, height: priceLabel.height)
        changeLabel.frame = CGRect(x: contentView.width - 10 - changeLabel.width, y: priceLabel.bottom, width: changeLabel.width, height: changeLabel.height)
        miniChartView.frame = CGRect(x: priceLabel.left - (contentView.width/3) - 6, y: 6, width: contentView.width/3, height: contentView.height - 12)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel : ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
    }
}
