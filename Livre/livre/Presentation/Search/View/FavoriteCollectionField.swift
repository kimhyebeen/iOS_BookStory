//
//  FavoriteCollectionField.swift
//  livre
//
//  Created by 김혜빈 on 2021/03/30.
//

import UIKit

protocol FavoriteCollectionDelegate: class {
    func removeBookData(_ item: FavoriteBook)
}

class FavoriteCollectionField: UIView {
    private let emptyLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    var items: [FavoriteBook] = []
    var isEditMode: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: FavoriteCollectionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        setupEmptyLabel()
        setupFlowLayout()
        setupCollectionView()
    }
    
    func setFavoriteItems(_ items: [FavoriteBook]) {
        self.items = items
        if items.count == 0 { emptyLabel.isHidden = false }
        else { emptyLabel.isHidden = true }
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

extension FavoriteCollectionField {
    func setupEmptyLabel() {
        emptyLabel.text = "즐겨찾는 책이 없어요 😂"
        emptyLabel.fontGmarketSansLight(14)
        emptyLabel.textColor = UIColor(named: "label_color")
        emptyLabel.isHidden = true
        self.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupFlowLayout() {
        flowLayout.itemSize = CGSize(width: 75, height: 100)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.left = 35
        collectionView.contentInset.right = 35
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .normal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BookImageCell.self, forCellWithReuseIdentifier: BookImageCell.identifier)
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

extension FavoriteCollectionField: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count == 0 { emptyLabel.isHidden = false }
        else { emptyLabel.isHidden = true }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookImageCell.identifier, for: indexPath) as? BookImageCell else {
            return BookImageCell()
        }
        
        cell.loadImage(link: items[indexPath.item].image!)
        cell.editingMode(isEditMode)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if !isEditMode { return true }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.delegate?.removeBookData(self.items[indexPath.item])
        }
        
        return true
    }
    
}
