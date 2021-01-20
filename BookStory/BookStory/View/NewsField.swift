//
//  NewsField.swift
//  BookStory
//
//  Created by 김혜빈 on 2021/01/20.
//

import UIKit

class NewsField: UIView {
    let title = UILabel()
        .then {
            $0.text = "NEWS"
            $0.textColor = UIColor(named: "navy")
            $0.font = UIFont.boldSystemFont(ofSize: 17)
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        self.setRoundedRectangle(radius: 20)
        self.backgroundColor = UIColor(named: "pale_gray")
        
        setupTitleLabel()
        setupDivider()
        setupMoreNewsButton()
        setupTableView()
    }

}

// MARK: +UI
extension NewsField {
    private func setupTitleLabel() {
        self.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 22.5).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
    }
    
    private func setupDivider() {
        
    }
    
    private func setupMoreNewsButton() {
        setupMoreInformationButtonView()
        
    }
    
    private func setupMoreInformationButtonView() {
        
    }
    
    private func setupTableView() {
        
    }
}
