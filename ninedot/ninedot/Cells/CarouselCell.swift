////
////  CarausalCell.swift
////  ninedot
////
////  Created by mohd shahid on 25/08/24.
////
//
//import UIKit
//protocol CarouselCellDelegate: AnyObject {
//    func didSelectCategory(_ category: Category)
//}
//
//class CarouselCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    var categories: [Category] = [] {
//        didSet {
//            collectionView.reloadData()
//            pageControl.numberOfPages = categories.count
//        }
//    }
//    
//    weak var delegate: CarouselCellDelegate?
//    
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//        
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.isPagingEnabled = true
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
//        return collectionView
//    }()
//    
//    private lazy var pageControl: UIPageControl = {
//        let pageControl = UIPageControl()
//        pageControl.currentPage = 0
//        pageControl.pageIndicatorTintColor = .lightGray
//        pageControl.currentPageIndicatorTintColor = .black
//        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
//        return pageControl
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        contentView.addSubview(collectionView)
//        contentView.addSubview(pageControl)
//        
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.3),
//            
//            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
//            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            pageControl.widthAnchor.constraint(equalToConstant: 100),
//            pageControl.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
//        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
//        
//        let category = categories[indexPath.item]
//        let imageView = UIImageView(image: UIImage(named: category.image))
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        
//        cell.contentView.addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
//        ])
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let category = categories[indexPath.item]
//        delegate?.didSelectCategory(category)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageWidth = collectionView.frame.width
//        let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
//        pageControl.currentPage = currentPage
//        let category = categories[currentPage]
//        delegate?.didSelectCategory(category)
//        
//    }
//    
//    @objc private func pageControlChanged() {
//        let pageIndex = pageControl.currentPage
//        let indexPath = IndexPath(item: pageIndex, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//    }
//}
import UIKit

protocol CarouselCellDelegate: AnyObject {
    func didSelectCategory(_ category: Category)
}


class CarouselCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categories: [Category] = [] {
        didSet {
            preloadImages()
            collectionView.reloadData()
            pageControl.numberOfPages = categories.count
        }
    }
    
    weak var delegate: CarouselCellDelegate?
    
    private var imageCache = [String: UIImage]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return pageControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.3),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            pageControl.widthAnchor.constraint(equalToConstant: 100),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func preloadImages() {
        categories.forEach { category in
            if let image = UIImage(named: category.image) {
                imageCache[category.image] = image
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let category = categories[indexPath.item]
        
        if let cachedImage = imageCache[category.image] {
            cell.imageView.image = cachedImage
        } else if let image = UIImage(named: category.image) {
            cell.imageView.image = image
            imageCache[category.image] = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        delegate?.didSelectCategory(category)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    private var previousPage: Int = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.width
        let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if currentPage != previousPage {
            previousPage = currentPage
            pageControl.currentPage = currentPage
            let category = categories[currentPage]
            delegate?.didSelectCategory(category)
        }
    }
    
    @objc private func pageControlChanged() {
        let pageIndex = pageControl.currentPage
        let indexPath = IndexPath(item: pageIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
