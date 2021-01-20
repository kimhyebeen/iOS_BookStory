//
//  NewsTableCell.swift
//  BookStory
//
//  Created by 김혜빈 on 2021/01/20.
//

import UIKit

class NewsTableCell: UITableViewCell {
    static let identifier = "NewsTableCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
    }

}
