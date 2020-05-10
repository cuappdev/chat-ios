//
//  ViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var headerCollectionView: UICollectionView!
    private var feedbackCollectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil) // TODO: For later
        
    private let headersData = ["Customer Service", "Bugs & Requests"]
    private var feedbackData = [Feedback]()
    private var filteredFeedbackData = [Feedback]()
    
    private(set) var countEditTaps: Int = 0
    
    // True is the current header is set to Customer Service, false otherwise
    private var isTwoway: Bool {
        return headersData[headerCollectionView.indexPathsForSelectedItems?[0].item ?? 0] == "Customer Service"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ._backgroundColor
        setupData()
        setupNavigationBar()
        setupHeaderCollectionView()
        setupFeedbackCollectionView()
        setupSearchController()
        setupConstraints()
        setupFeedbackListener()
        setDefaultHeaderCell()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // TODO: hook up to actual server to load the data
    // This is dummy data for testing
    // Add variables to feedbackData to show the tableView + editing functionality
    func setupData() {
        let jsonString = """
        {
            "title" : "Ithaca Transit Bug",
            "message" : "This app sometimes glitches out on me and shows the wrong bus times",
            "hasRead" : false,
            "isTwoWay" : true
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        let _ = try! JSONDecoder().decode(Feedback.self, from: jsonData)
        
        feedbackData = []
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attributedTitle = NSAttributedString(string: "Feedback", attributes: attributes)
        title = attributedTitle.string
        // Set navigation bar items
        navigationItem.backBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: nil,
            action: nil
        )
        let addFeedbackButton = UIBarButtonItem(
            image: UIImage(named: "plus")?.withTintColor(.black),
            style: .plain,
            target: self,
            action: #selector(handleAddFeedbackItemRightTap)
        )
        let searchImage = UIImage(named: "search")?
            .withTintColor(.black)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: -15))
        let searchFeedbackButton = UIBarButtonItem(
            image: searchImage,
            style: .plain,
            target: self,
            action: #selector(handleSearchItemRightTap)
        )
        navigationItem.rightBarButtonItems = [addFeedbackButton, searchFeedbackButton]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes([.foregroundColor : UIColor._darkGray], for: .normal)
    }
    
    func setupHeaderCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        headerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        headerCollectionView.backgroundColor = .white
        headerCollectionView.isScrollEnabled = false
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        headerCollectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.reuseID)
        view.addSubview(headerCollectionView)
    }
    
    func setupFeedbackCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        feedbackCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        feedbackCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feedbackCollectionView.backgroundColor = .white
        feedbackCollectionView.dataSource = self
        feedbackCollectionView.delegate = self
        // TODO: register UICollectionViewCells
        view.addSubview(feedbackCollectionView)
    }
    
    func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func setupConstraints() {
        removeViews()
        NSLayoutConstraint.activate([
            headerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            headerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            headerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            headerCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            feedbackCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedbackCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedbackCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            feedbackCollectionView.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 5)
        ])
    }
    

    func setupSearchingConstraints() {
        removeViews()
        NSLayoutConstraint.activate([
            headerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            headerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            headerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            headerCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    /*
     Because the removeConstraints() function only removes constraints belonging to that view, it did not remove ALL constraints.
     Adding alignment insets is also exceedingly difficult for UICollectionViews.
     So currently, I am removing and re-adding the collection views to reset ALL constraints.
     */
    func removeViews() {
        headerCollectionView.removeFromSuperview()
        view.addSubview(headerCollectionView)
    }

    
    func setupFeedbackListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateBanner), name:NSNotification.Name(rawValue: "AnimateBanner"), object: nil)
    }
    
    func setDefaultHeaderCell() {
        headerCollectionView.selectItem(
            at: .init(item: 0, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
    
    //MARK: - OBJC Functions
    @objc func animateBanner() {
        let banner = BannerView()
        view.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            banner.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
        banner.show()
    }
    
    @objc func handleAddFeedbackItemRightTap() {
        let vc = UINavigationController(rootViewController: FeedbackViewController())
        self.present(vc, animated: true, completion: nil)
    }
        
    @objc func handleSearchItemRightTap() {
        searchController.delegate?.willPresentSearchController?(searchController)
    }
    
}

// MARK: - UICollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return headersData.count
        } else {
            return searchController.isActive ? filteredFeedbackData.count : feedbackData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.reuseID, for: indexPath) as! HeaderCollectionViewCell
            let header = headersData[indexPath.item]
            cell.configure(with: header)
            return cell
        } else {
            return UICollectionViewCell() // TODO: configure cells for feedbackCollectionView
        }
    }
        
}

// MARK: - UICollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == feedbackCollectionView {
            // TODO: if two way communication, open up chat
        }
    }
    
}

// MARK: - UICollectionView DelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            return CGSize(width: (view.frame.width - 60) / 2, height: 40)
        } else {
            return CGSize() // TODO: add proper size later
        }
    }
    
}

// MARK: - UISearchController Delegate
extension ViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupConstraints()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupSearchingConstraints()
        present(searchController, animated: true, completion: nil)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        headerCollectionView.delegate?.collectionView?(self.headerCollectionView, didSelectItemAt: [0,0])
    }
    
}

// MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
            filteredFeedbackData = feedbackData.filter { feedback in
                return (feedback.isTwoWay == isTwoway) &&
                    (feedback.message.lowercased().contains(searchText)
                        || feedback.title.lowercased().contains(searchText))
            }
        }
        feedbackCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        feedbackCollectionView.reloadData()
    }
    
}
