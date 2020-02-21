//
//  ViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import SnapKit
import DZNEmptyDataSet

class ViewController: UIViewController {
    
    private let feedbackTableView = UITableView(frame: .zero)
    private let searchController = UISearchController() // TODO: For later
        
    private var feedbackData = [Feedback]()
    private var filteredFeedbackData = [Feedback]() // TODO: For later
    
    private(set) var countEditTaps: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor        
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
        navigationController?.navigationBar.barTintColor = UIColor.navigationTintColor
        let attributes = [
            NSAttributedString.Key.font: UIFont._21RobotoMedium!,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedTitle = NSAttributedString(string: "Feedback", attributes: attributes)
        title = attributedTitle.string
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "pen"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(handleNavigationBarRightTap)
        )
    }
    
    func setupFeedbackTableView() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableFooterView = UIView()
        feedbackTableView.emptyDataSetSource = self
        feedbackTableView.emptyDataSetDelegate = self
        feedbackTableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseID)
        view.addSubview(feedbackTableView)
    }
    
    func setupConstraints() {
        feedbackTableView.snp.makeConstraints { make  in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
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
        
        let customView = UIView()

        // Create ParagraphStyle to format label text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        
        // Tell user there is no feedback to display
        let feedbackLabel = UILabel()
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
        newConversationButton.setTitle("Start Conversation", for: .normal)
        newConversationButton.backgroundColor = UIColor.themeColor
        newConversationButton.titleLabel?.font = UIFont._17RobotoMedium
        newConversationButton.layer.cornerRadius = 22
        
        // Add elements to UIView
        customView.addSubview(newConversationButton)
        customView.addSubview(feedbackLabel)
        
        // Set up constraints
        feedbackLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        
        newConversationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(feedbackLabel.snp.bottom).offset(view.frame.height / 2.5)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(45)
        }
        
        // Adds animation
        newConversationButton.alpha = 0
        feedbackLabel.alpha = 0
        UIView.transition(with: customView, duration: 1.25, animations: {
            newConversationButton.alpha = 1
            feedbackLabel.alpha = 1
        }, completion: nil)

        return customView
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}
