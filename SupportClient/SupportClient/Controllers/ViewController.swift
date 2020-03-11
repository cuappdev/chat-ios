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
        view.backgroundColor = .backgroundColor
        setupData()
        setupNavigationBar()
        setupFeedbackTableView()
        setupConstraints()
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
        let feedback = try! JSONDecoder().decode(Feedback.self, from: jsonData)
        
        feedbackData = [feedback]
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .navigationTintColor
        let attributes = [
            NSAttributedString.Key.font: UIFont._21RobotoMedium!,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
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
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let customView = CustomView(width: view.layer.bounds.width, height: view.layer.bounds.height)

        // Create ParagraphStyle to format label text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        
        // Tell user there is no feedback to display
        let feedbackLabel = UILabel()
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.lineBreakMode = .byWordWrapping
        feedbackLabel.numberOfLines = 0
        let title = "No Feedback Yet\n"
        let subtitle = "See feedback conversations here"
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont._17RobotoMedium!,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont._13RobotoRegular!,
            NSAttributedString.Key.foregroundColor: UIColor.subtitleColor
        ]
        attributedText.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        feedbackLabel.attributedText = attributedText
        feedbackLabel.sizeToFit()
        
        // Start new conversation button
        let newConversationButton = UIButton()
        newConversationButton.translatesAutoresizingMaskIntoConstraints = false
        newConversationButton.setTitle("Start Conversation", for: .normal)
        newConversationButton.backgroundColor = UIColor.themeColor
        newConversationButton.titleLabel?.font = UIFont._17RobotoMedium
        newConversationButton.layer.cornerRadius = 22
        newConversationButton.addTarget(self, action: #selector(handleNewConversationButtonTap), for: .touchUpInside)
        
        // Add elements to UIView
        customView.addSubview(newConversationButton)
        customView.addSubview(feedbackLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            feedbackLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            feedbackLabel.centerYAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.centerYAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            newConversationButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            newConversationButton.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: view.frame.height / 2.5),
            newConversationButton.widthAnchor.constraint(equalToConstant: 220),
            newConversationButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        // Adds animation
        newConversationButton.alpha = 0
        feedbackLabel.alpha = 0
        UIView.transition(with: customView, duration: 0.75, animations: {
            newConversationButton.alpha = 1
            feedbackLabel.alpha = 1
        }, completion: nil)

        return customView
    }
    
    // TODO: change to intended functionality
    @objc func handleNewConversationButtonTap() {
        let feedbackViewController = UINavigationController(rootViewController: FeedbackViewController())
        self.present(feedbackViewController, animated: true, completion: nil)
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}
