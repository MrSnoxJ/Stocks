//
//  NewsStoryTableViewCell.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 15.12.2023.
//

import UIKit
import SDWebImage
class NewsStoryTableViewCell: UITableViewCell {

    static let identifire = "NewsStoryTableViewCell"
    
    static let preferredHeight : CGFloat = 140
    
    struct ViewModel {
        let source : String
        let headline : String
        let dateString : String
        let imageURL : URL?
        
        init(model : NewsStory ) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = .string(from: model.datetime)
            self.imageURL = URL(string: model.image)
        }
    }
    
    private let sourceLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .medium)
        
        return label
    }()
    
    private let headLineLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22,weight: .regular)
        
        return label
    }()
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14,weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let storyImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLabel,headLineLabel,dateLabel,storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = contentView.height/1.4
        storyImageView.frame = CGRect(x: contentView.width - imageSize - 10, y: (contentView.height - imageSize)/2, width: imageSize, height: imageSize)
        let availableWidth : CGFloat = contentView.width - separatorInset.left - imageSize - 15
        dateLabel.frame = CGRect(x: separatorInset.left, y: contentView.height - 40, width: availableWidth, height: 40)
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(x: separatorInset.left, y: 4, width: availableWidth, height: sourceLabel.height)
        headLineLabel.frame = CGRect(x: separatorInset.left, y: sourceLabel.bottom + 5, width: availableWidth, height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
        
        
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headLineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel: ViewModel) {
        headLineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
        
        storyImageView.sd_setImage(with: viewModel.imageURL,completed: nil)
       // storyImageView.setImage(with: viewModel.imageURL)
    }
}
