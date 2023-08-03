//
//  HomePageViewController.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import UIKit

final class HomePageViewController: BaseViewController {
    
    @IBOutlet weak var topFilmsLabel: UILabel!
    @IBOutlet weak var topFilmsCollectionView: UICollectionView!
    
    @IBOutlet weak var randomLabel: UILabel!
    @IBOutlet weak var randomCollectionView: UICollectionView!
    
    @IBOutlet weak var lastMonthReleasesLabel: UILabel!
    @IBOutlet weak var lastMonthReleasesCollectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    private weak var headerLabel: UILabel!
    private weak var searchIcon: UIView!
    private var originalSearchOrigin: CGPoint!
    private var isSearchEnable = false
    private weak var searchField: UITextField!
    private let animationDuration = 0.4
    
    private var topFilms: [FilmCell] = []
    private var randomFilms: [FilmCell] = []
    private var lastReleases: [FilmCell] = []
    
    var viewModel: HomePageViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.getTopFilms()
        viewModel.getRandom()
        viewModel.getLastReleases()
        showLoadingIndicator()
    }
    
}

extension HomePageViewController {
    // UI
    private func setupUI() {
        setupNavItem()
        setupCollectionViews()
        topFilmsLabel.textColor = AppColors.lightGray
        randomLabel.textColor = AppColors.lightGray
        lastMonthReleasesLabel.textColor = AppColors.lightGray
        contentView.backgroundColor = AppColors.appBackground
    }
    
    private func setupNavItem() {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 50
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Отрисовка Лого
        let stringNight = NSAttributedString(string: "Night", attributes: [.foregroundColor: AppColors.lightGray, .font: UIFont.systemFont(ofSize: 25, weight: .heavy)])
        let stringBurgerus = NSAttributedString(string: "Burgerus", attributes: [.foregroundColor: AppColors.lightRed, .font: UIFont.systemFont(ofSize: 25, weight: .heavy)])
        let resultString = NSMutableAttributedString(attributedString: stringNight)
        resultString.append(stringBurgerus)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.attributedText = resultString
        label.sizeToFit()
        label.center.y = CGFloat(height / 2)
        self.headerLabel = label
        titleView.addSubview(label)
        
        // Отрисовка значка поиска через кривые Безье (мне было лень
        // искать нужную картинку)
        let searchButtonView = UIView()
        let searchButtonRect = CGRect(x: titleView.bounds.width - height, y: 0, width: height * 0.7, height: height * 0.7)
        searchButtonView.frame = searchButtonRect
        searchButtonView.center.y = titleView.center.y
        
        let searchFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchPath = UIBezierPath()
        searchPath.addArc(withCenter: CGPoint(x: 10, y: 10), radius: 10, startAngle: CGFloat.pi / 4, endAngle: CGFloat.pi / 4 + 0.01, clockwise: false)
        searchPath.addLine(to: CGPoint(x: 25, y: 25))
        searchPath.close()
        
        let searchLayer = CAShapeLayer()
        searchLayer.path = searchPath.cgPath
        searchLayer.strokeColor = AppColors.lightGray.cgColor
        searchLayer.lineWidth = 3
        searchLayer.fillColor = UIColor.clear.cgColor
        searchButtonView.layer.addSublayer(searchLayer)
        searchButtonView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchDidTap))
        searchButtonView.addGestureRecognizer(tap)
        
        self.searchIcon = searchButtonView
        self.originalSearchOrigin = searchButtonView.frame.origin
        titleView.addSubview(searchButtonView)
        
        let searchFieldWidth = UIScreen.main.bounds.width - searchIcon.frame.width * 2
        let searchField = UITextField(frame: CGRect(x: searchIcon.frame.width, y: 0, width: searchFieldWidth, height: titleView.frame.height))
        searchField.backgroundColor = .white
        searchField.layer.cornerRadius = 10
        searchField.layer.isHidden = true
        searchField.layer.opacity = 0
        self.searchField = searchField
        
        titleView.addSubview(searchField)
        
        navigationItem.titleView = titleView
    }
}

extension HomePageViewController {
    // Gestures
    @objc
    private func searchDidTap() {
        if !isSearchEnable {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut]) {
                self.headerLabel.layer.opacity = 0
                self.searchIcon.frame.origin = self.headerLabel.frame.origin
                self.contentView.layer.opacity = 0
            }
            searchField.layer.isHidden = false
            UIView.animate(withDuration: animationDuration, delay: animationDuration) {
                self.searchField.layer.opacity = 1
            }
        } else {
            UIView.animate(withDuration: animationDuration, delay: 0) {
                self.searchField.layer.opacity = 0
            }
            UIView.animate(withDuration: animationDuration, delay: animationDuration, options: [.curveEaseInOut]) {
                self.headerLabel.layer.opacity = 1
                self.searchIcon.frame.origin = self.originalSearchOrigin
                self.contentView.layer.opacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                self.searchField.layer.isHidden = true
            }
        }
        isSearchEnable.toggle()
    }
}

// MARK: - PopularFilmsCollectionView
extension HomePageViewController: UICollectionViewDataSource {
    func setupCollectionViews() {
        self.topFilmsCollectionView.backgroundColor = AppColors.appBackground
        self.topFilmsCollectionView.dataSource = self
        self.topFilmsCollectionView.register(UINib(nibName: "\(FilmCollectionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(FilmCollectionCell.self)")
        self.topFilmsCollectionView.showsHorizontalScrollIndicator = false
        
        self.randomCollectionView.backgroundColor = AppColors.appBackground
        self.randomCollectionView.dataSource = self
        self.randomCollectionView.register(UINib(nibName: "\(FilmCollectionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(FilmCollectionCell.self)")
        self.randomCollectionView.showsHorizontalScrollIndicator = false
        
        self.lastMonthReleasesCollectionView.backgroundColor = AppColors.appBackground
        self.lastMonthReleasesCollectionView.dataSource = self
        self.lastMonthReleasesCollectionView.register(UINib(nibName: "\(FilmCollectionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(FilmCollectionCell.self)")
        self.lastMonthReleasesCollectionView.showsHorizontalScrollIndicator = false
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == randomCollectionView {
            return randomFilms.count
        }
        if collectionView == topFilmsCollectionView {
            return topFilms.count
        }
        return lastReleases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FilmCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FilmCollectionCell.self)", for: indexPath) as? FilmCollectionCell else {
            return UICollectionViewCell()
        }
        var currentFilm: FilmCell!
        if collectionView == randomCollectionView {
            currentFilm = randomFilms[indexPath.item]
        } else if collectionView == topFilmsCollectionView {
            currentFilm = topFilms[indexPath.item]
        } else {
            currentFilm = lastReleases[indexPath.item]
        }
        
        cell.setup(with: currentFilm.image,
                   name: currentFilm.name,
                   date: currentFilm.year)
        return cell
    }
}

extension HomePageViewController: HomePageViewInput {
    func showTopFilms(_ films: [FilmCell]) {
        self.topFilms = films
        topFilmsCollectionView.reloadData()
        if !randomFilms.isEmpty && !lastReleases.isEmpty && !loadingIndicatorIsHidden {
            hideLoadingIndicator()
        }
    }
    
    func showRandomFilms(_ films: [FilmCell]) {
        self.randomFilms = films
        print("~", films)
        randomCollectionView.reloadData()
        if !randomFilms.isEmpty && !lastReleases.isEmpty && !loadingIndicatorIsHidden {
            hideLoadingIndicator()
        }
    }
    
    func showLastReleases(_ films: [FilmCell]) {
        self.lastReleases = films
        lastMonthReleasesCollectionView.reloadData()
        if !randomFilms.isEmpty && !topFilms.isEmpty && !loadingIndicatorIsHidden {
            hideLoadingIndicator()
        }
    }
}
