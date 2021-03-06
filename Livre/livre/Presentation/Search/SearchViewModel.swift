//
//  DetailViewModel.swift
//  BookStory
//
//  Created by 김혜빈 on 2021/01/19.
//

import RxSwift
import RxCocoa

class SearchViewModel {
    let input = Input()
    let output = Output()
    private var editMode = false
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchWord = PublishSubject<String>()
        let searchButton = PublishSubject<Void>()
        let favoriteEditButton = PublishSubject<Void>()
    }
    
    struct Output {
        let executeToast = PublishRelay<String>()
        let booksResult = PublishRelay<[Book]>()
        let blogsResult = PublishRelay<[BlogItem]>()
        let recentSearchedText = RecentSearchConfig.shared.replayRelay
        let favoriteEditMode = BehaviorRelay<Bool>(value: false)
        let favoriteResult = PublishRelay<[FavoriteBook]>()
    }
    
    init() {
        input.searchButton.withLatestFrom(input.searchWord)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                self?.requestBookItems(value: text)
                self?.output.recentSearchedText.accept(text)
            }).disposed(by: disposeBag)
        
        input.favoriteEditButton.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.editMode = !self.editMode
            self.output.favoriteEditMode.accept(self.editMode)
        }).disposed(by: disposeBag)
    }
    
    func requestBookItems(value: String) {
        func mappingToBook(_ data: BookResponse) -> Book { Book(title: data.title, image: data.image, author: data.author, price: data.priceString, isbn: data.isbn, description: data.description, publisher: data.publisher, publishDate: data.publishDate)}
        
        NetworkConfig.shared.books(query: value).subscribe(onNext: { [weak self] items in
            self?.output.booksResult.accept( items.map { mappingToBook($0) } )
        }).disposed(by: disposeBag)
    }
    
    func requestBlogItems(value: String) {
        func mappingToBlogItem(_ data: BlogResponse) -> BlogItem { BlogItem(title: data.title, link: data.link, description: data.description, bloggername: data.bloggername, postDate: data.postDate) }
        
        NetworkConfig.shared.blogs(query: value).subscribe(onNext: { [weak self] items in
            self?.output.blogsResult.accept( items.map { mappingToBlogItem($0) } )
        }).disposed(by: disposeBag)
    }
    
    func updatePoint(value: String) {
        RewardConfig.shared.addPoint(point: Float(value.count * 2))
    }
    
    func fetchFavorites() {
        print("Search ViewModel - 즐겨찾기 목록을 가져와요.")
        let result = PersistenceManager.shared.fetch(request: FavoriteBook.fetchRequest())
        output.favoriteResult.accept(result)
    }
    
    func isExistInFavorite(_ title: String) -> Bool {
        return PersistenceManager.shared.fetchBookForTitle(title).count > 0 ? true : false
    }
    
    func deleteForTitle(_ title: String) {
        let result = PersistenceManager.shared.deleteBookForTitle(title)
        if !result {
            output.executeToast.accept("🚫 즐겨찾기 삭제 실패")
            return
        }
        print("Search ViewModel - 타이틀로 즐겨찾기 삭제 성공")
        fetchFavorites()
    }
    
    func deleteBook(_ item: FavoriteBook) {
        let result = PersistenceManager.shared.delete(object: item)
        if !result {
            output.executeToast.accept("🚫 즐겨찾기 삭제 실패")
            return
        }
        print("Search ViewModel - 즐겨찾기 아이템 삭제 성공")
        fetchFavorites()
    }
    
    func insertFavorite(_ item: Book) {
        let result = PersistenceManager.shared.insertBook(item)
        if !result {
            output.executeToast.accept("🚫 즐겨찾기에 등록 실패")
            return
        }
        print("Search ViewModel - 즐겨찾기 추가 성공")
        fetchFavorites()
    }
}
