//
//  ViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ViewController: UIViewController {
    
    private let feedbackTableView = UITableView(frame: .zero)
    private let searchController = UISearchController() // TODO: For later
        
    private var feedbackData = [Feedback]()
    private var filteredFeedbackData = [Feedback]() // TODO: For later
    
    private(set) var countEditTaps: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ._backgroundColor
        setupData()
        setupNavigationBar()
        setupFeedbackTableView()
        setupConstraints()
        setupFeedbackListener()
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
            "hasRead" : false
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        let _ = try! JSONDecoder().decode(Feedback.self, from: jsonData)
        
        feedbackData = []
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = ._lightGray
        let attributes = [
            NSAttributedString.Key.font: UIFont._21RobotoMedium!,
            NSAttributedString.Key.foregroundColor: UIColor._darkGray
        ]
        let attributedTitle = NSAttributedString(string: "Feedback", attributes: attributes)
        title = attributedTitle.string
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "pen"),
            style: .plain,
            target: self,
            action: #selector(handleNavigationBarRightTap)
        )
    }
    
    func setupFeedbackTableView() {
        feedbackTableView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableFooterView = UIView()
        feedbackTableView.emptyDataSetSource = self
        feedbackTableView.emptyDataSetDelegate = self
        feedbackTableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseID)
        view.addSubview(feedbackTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            feedbackTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedbackTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedbackTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedbackTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupFeedbackListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateBanner), name:NSNotification.Name(rawValue: "AnimateBanner"), object: nil)
    }
    
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
        
    @objc func handleNavigationBarRightTap() {
        let isEvenNumTaps = countEditTaps % 2 == 0
        feedbackTableView.setEditing(isEvenNumTaps, animated: true)
        countEditTaps += 1
    }
    
}

// MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = feedbackTableView.cellForRow(at: indexPath) as! FeedbackTableViewCell
        var _ = feedbackData[indexPath.row]
        // TODO: navigate to the messaging page
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            feedbackData.remove(at: indexPath.row)
            feedbackTableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
}

// MARK: - TableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.reuseID, for: indexPath) as! FeedbackTableViewCell
        let feedback = feedbackData[indexPath.row]
        cell.configure(feedback: feedback)
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: - DZNEmptyDataSet
extension ViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return NoMessageView(
            onPress: {
                let feedbackViewController = UINavigationController(rootViewController: FeedbackViewController())
                self.present(feedbackViewController, animated: true, completion: nil)
            }
        )
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}
