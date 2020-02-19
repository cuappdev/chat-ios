//
//  ViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let feedbackLabel = UILabel()
    private let feedbackTableView = UITableView(frame: .zero)
    private let newConversationButton = UIButton()
    private let searchController = UISearchController() // TODO: For later
        
    private var feedbackData = [Feedback]()
    private var filteredFeedbackData = [Feedback]() // TODO: For later
    
    private(set) var countEditTaps: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        // Do any additional setup after loading the view.
        
        setupData()
        setupNavigationBar()
        setupFeedbackLabel()
        setupConversationButton()
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
    
    func setupFeedbackLabel() {
        feedbackLabel.lineBreakMode = .byWordWrapping
        feedbackLabel.numberOfLines = 0

        // Format the alignment and spacing between lines
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        
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
        view.addSubview(feedbackLabel)
    }
    
    func setupConversationButton() {
        newConversationButton.setTitle("Start Conversation", for: .normal)
        newConversationButton.backgroundColor = UIColor.themeColor
        newConversationButton.titleLabel?.font = UIFont._17RobotoMedium
        newConversationButton.layer.cornerRadius = 22
        view.addSubview(newConversationButton)
    }
    
    func setupFeedbackTableView() {
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.tableFooterView = UIView()
        feedbackTableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.reuseID)
        view.addSubview(feedbackTableView)
    }
    
    func setupConstraints() {
        if !feedbackData.isEmpty {
            feedbackTableView.snp.makeConstraints{ make  in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        } else {
            feedbackTableView.isHidden = true
            newConversationButton.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(50)
                make.width.equalTo(view.frame.width / 2)
                make.height.equalTo(45)
            }
            feedbackLabel.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(view.frame.height / 2)
            }
        }
    }
    
    @objc func handleNavigationBarRightTap() {
        let isEvenNumTaps = countEditTaps % 2 == 0
        feedbackTableView.setEditing(isEvenNumTaps, animated: true)
        countEditTaps += 1
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = feedbackTableView.cellForRow(at: indexPath) as! FeedbackTableViewCell
        var feedback = feedbackData[indexPath.row]
        feedback.hasRead.toggle() // TODO: remove this once hooked up to database
        cell.toggleRead(for: feedback) // TODO: remove this once hooked up to database
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            feedbackData.remove(at: indexPath.row)
            feedbackTableView.deleteRows(at: [indexPath], with: .fade)
        }
        // If all conversations removed, go back to default page
        if feedbackData.isEmpty {
            view.snp.removeConstraints()
            feedbackTableView.isHidden = true
            newConversationButton.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(50)
                make.width.equalTo(view.frame.width / 2)
                make.height.equalTo(45)
            }
            feedbackLabel.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(view.frame.height / 2)
            }
        }
    }
    
}

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
