//
//  ViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

public class PortalViewController: UIViewController {
    
    private var headerCollectionView: UICollectionView!
    private var feedbackCollectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil) // TODO: For later
    
    private var bugsRequestsData = [Feedback]()
    private var customerServiceData = [Feedback]()
    private var filteredBugsRequestsData = [Feedback]()
    private var filteredCustomerServiceData = [Feedback]()
    private let headersData = ["Customer Service", "Bugs & Requests"]
    
    private(set) var countEditTaps: Int = 0

    public override func viewDidLoad() {
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
        let twoWayFeedbackJson = """
        {
            "admin_rep" : {
                "name": "Admin Name"
            },
            "hasRead" : false,
            "message" : "How can I do this?",
            "tags" : [],
            "image_urls": [],
            "created_at" : 1589112659,
            "title" : "Question",
            "type" : "Customer Service"
        }
        """
        let oneWayFeedbackJson = """
        {
            "message" : "This app sometimes glitches out on me and shows the wrong bus times",
            "tags" : ["UX/UI"],
            "image_urls": [],
            "created_at" : 1589112659,
            "title" : "Ithaca Transit Bug",
            "type" : "Bug Report"
        }
        """
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let twoWayJsonData = twoWayFeedbackJson.data(using: .utf8) else { return }
        let twoWayDummyFeedback = try! jsonDecoder.decode(TwoWayFeedback.self, from: twoWayJsonData)
        guard let oneWayJsonData = oneWayFeedbackJson.data(using: .utf8) else { return }
        let oneWayDummyFeedback = try! jsonDecoder.decode(OneWayFeedback.self, from: oneWayJsonData)
        
        bugsRequestsData = [oneWayDummyFeedback, oneWayDummyFeedback]
        customerServiceData = [twoWayDummyFeedback, twoWayDummyFeedback]
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
            image: UIImage(named: "back", in: PatchKitImages.resourceBundle, compatibleWith: nil),
            style: .plain,
            target: nil,
            action: nil
        )
        let addFeedbackButton = UIBarButtonItem(
            image: UIImage(named: "plus", in: PatchKitImages.resourceBundle, compatibleWith: nil)?.withTintColor(.black),
            style: .plain,
            target: self,
            action: #selector(handleAddFeedbackItemRightTap)
        )
        let searchImage = UIImage(named: "search", in: PatchKitImages.resourceBundle, compatibleWith: nil)?
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        feedbackCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        feedbackCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feedbackCollectionView.backgroundColor = .white
        feedbackCollectionView.isPagingEnabled = true
        feedbackCollectionView.showsHorizontalScrollIndicator = false
        feedbackCollectionView.dataSource = self
        feedbackCollectionView.delegate = self
        feedbackCollectionView.register(FeedbackCollectionViewCell.self, forCellWithReuseIdentifier: FeedbackCollectionViewCell.reuseIdentifier)
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
        
        NSLayoutConstraint.activate([
            feedbackCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedbackCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedbackCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            feedbackCollectionView.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 5)
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
extension PortalViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return headersData.count
        } else {
            return 2
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.reuseID, for: indexPath) as! HeaderCollectionViewCell
            let header = headersData[indexPath.item]
            cell.configure(with: header)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedbackCollectionViewCell.reuseIdentifier, for: indexPath) as! FeedbackCollectionViewCell

            if indexPath.row == 0 {
                let data = searchController.isActive ? filteredCustomerServiceData : customerServiceData
                /*
                 TODO: Don't think we rly need this section param. Potentially refactor
                 BusRequestsCell and CustomerServiceCell into one
                */
                cell.configure(section: .customerService, items: data)
            } else {
                let data = searchController.isActive ? filteredBugsRequestsData : bugsRequestsData
                cell.configure(section: .bugsAndRequests, items: data)
            }

            return cell
        }
    }
    
}

// MARK: - UICollectionView Delegate
extension PortalViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            feedbackCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        headerCollectionView.delegate?.collectionView?(self.headerCollectionView, didSelectItemAt: [0,0])
    }
    
}

// MARK: - UICollectionView DelegateFlowLayout
extension PortalViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            return CGSize(width: (view.frame.width - 60) / 2, height: 40)
        } else {
            return CGSize(width: feedbackCollectionView.frame.width, height: feedbackCollectionView.frame.height)
        }
    }
    
}

// MARK: - UIScrollView Delegate
extension ViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(page), section: 0)

        headerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }

}

// MARK: - UISearchController Delegate
extension PortalViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {>>>>>>> master:SupportClient/Controllers/ViewController.swift
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchController.isActive = true
        setupSearchingConstraints()
        feedbackCollectionView.reloadData()
        present(searchController, animated: true, completion: nil)
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        filteredBugsRequestsData = []
        filteredCustomerServiceData = []
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupConstraints()
    }
    
}

// MARK: - UISearchResultsUpdating
extension PortalViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased() {
            filteredCustomerServiceData = customerServiceData.filter { feedback in
                return feedback.message.lowercased().contains(searchText)
            }

            filteredBugsRequestsData = bugsRequestsData.filter { feedback in
                return feedback.message.lowercased().contains(searchText)
            }
        }
        feedbackCollectionView.reloadData()
    }

}
