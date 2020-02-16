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
    
    
    var newConversationButton: UIButton!
    var feedbackLabel: UILabel!
    var searchController: UISearchController! // TODO: For later
    var feedbackTableView: UITableView!
        
    var feedbackData: [Feedback]!
    var filteredFeedbackData = [Feedback]() // TODO: For later
    
    var countEditTaps: Int = 0
    var isFeedback: Bool!
    let cellHeight: CGFloat = 75
    let reuseID: String = "FeedbackTableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        // Do any additional setup after loading the view.
        
        isFeedback = setUpData() == 0 ? false : true
        setUpNavigationBar()
        setUpFeedbackLabel()
        setUpConversationButton()
        setUpFeedbackTableView()
        setUpConstraints()
        
    }
    
    // TODO: hook up to actual server to load the data
    // This is dummy data for testing
    // Add variables to feedbackData to show the tableView + editing functionality
    func setUpData() -> Int {
        
        let _ = Feedback(title: "Ithaca Transit Bug", message: "This app sometimes glitches out on me and shows the wrong bus times", hasUnread: true)
        let _ = Feedback(title: "chatOS Idea", message: "what if admin responed via macOS applications and not iOS applications??", hasUnread: false)
        feedbackData = []
        return feedbackData.count
        
    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = Constants.navigationTintColor
        
        let attributedTitle = NSAttributedString(string: "Feedback", attributes: [NSAttributedString.Key.font: UIFont(name: Constants.robotoMedium, size: 21)!, NSAttributedString.Key.foregroundColor: Constants.titleColor])
        title = attributedTitle.string
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "pen"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleNavigationBarRightTap))
        
    }
    
    func setUpFeedbackLabel() {
        
        feedbackLabel = UILabel()
        feedbackLabel.lineBreakMode = .byWordWrapping
        feedbackLabel.numberOfLines = 0

        // format the alignment and spacing between lines
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        
        // format the text with specific color, font, size
        let title = "No Feedback Yet\n"
        let subtitle = "See feedback conversations here"
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: Constants.robotoMedium, size: 17)!, .paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: Constants.titleColor])
        
        attributedText.append(NSAttributedString(string: subtitle, attributes: [NSAttributedString.Key.font: UIFont(name: Constants.robotoRegular, size: 13)!, NSAttributedString.Key.foregroundColor: Constants.subtitleColor]))

        feedbackLabel.attributedText = attributedText
        feedbackLabel.sizeToFit()
        view.addSubview(feedbackLabel)
        
    }
    
    func setUpConversationButton() {
        
        newConversationButton = UIButton()
        newConversationButton.setTitle("Start Conversation", for: .normal)
        newConversationButton.backgroundColor = Constants.themeColor
        newConversationButton.titleLabel?.font = UIFont(name: Constants.robotoMedium, size: 17)
        newConversationButton.layer.cornerRadius = 22
        view.addSubview(newConversationButton)
        
    }
    
    func setUpFeedbackTableView() {
        
        feedbackTableView = UITableView(frame: .zero)
        feedbackTableView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTableView.delegate = self
        feedbackTableView.dataSource = self
        feedbackTableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: reuseID)
        view.addSubview(feedbackTableView)
                    
    }
    
    func setUpConstraints() {
                
        if isFeedback {
            
            feedbackTableView.snp.makeConstraints{ (make) -> Void in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
            
        } else {
            
            feedbackTableView.isHidden = true
            
            newConversationButton.snp.makeConstraints{ (make) -> Void in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(50)
                make.width.equalTo(view.layer.bounds.width / 2)
                make.height.equalTo(45)
            }
            
            feedbackLabel.snp.makeConstraints{ (make) -> Void in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(view.layer.bounds.height/2)
            }
            
        }
        
    }
    
    @objc func handleNavigationBarRightTap() {
        
        if countEditTaps % 2 == 0 {
            feedbackTableView.setEditing(true, animated: true)
        } else {
            feedbackTableView.setEditing(false, animated: true)
        }
        countEditTaps += 1

    }
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = feedbackTableView.cellForRow(at: indexPath) as! FeedbackTableViewCell
        let feedback = feedbackData[indexPath.row]
        feedback.hasUnread.toggle() // TODO: remove this once hooked up to database
        cell.toggleRead(for: feedback) // TODO: remove this once hooked up to database
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            feedbackData.remove(at: indexPath.row)
            feedbackTableView.deleteRows(at: [indexPath], with: .fade)
        }
        // if all conversations removed, go back to default page
        if feedbackData.count == 0 {
            isFeedback = false
            setUpConstraints()
        }
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! FeedbackTableViewCell
        let feedback = feedbackData[indexPath.row]
        cell.configure(feedback: feedback)
        cell.selectionStyle = .none
        return cell
    }
    
}
