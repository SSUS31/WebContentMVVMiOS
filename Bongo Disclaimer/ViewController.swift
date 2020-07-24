//
//  ViewController.swift
//  Bongo Disclaimer
//
//  Created by Sahad on 23/7/20.
//  Copyright © 2020 Sahad. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var viewModel:ViewModelDelegate!
    var status = (onInitialLoad: true , showWebContent: true)

    lazy var button:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("LOAD_BUTTON_TITLE", comment: ""), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(self.loadButtonAction), for: .touchUpInside)
        button.layer.cornerRadius = 30
        return button
    }()

    lazy var textViewContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.9
        view.clipsToBounds = false

        view.addSubview(self.textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()

    let textView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.isEditable = false
        textView.layer.cornerRadius = 30
        return textView
    }()


    //MARK:- LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        setupViews()
        viewModel.fetchWebContent("", false)
//        showPrintedResultsOnTextView()
        showResponseOnTextView()
    }

    //MARK:- Setup Views
    fileprivate func setupViews() {
        view.addSubview(button)
        view.addSubview(textViewContainer)

        NSLayoutConstraint.activate([
            //Constraints for Button
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            //Constraints for TextView
            textViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textViewContainer.leftAnchor.constraint(equalTo: button.leftAnchor),
            textViewContainer.rightAnchor.constraint(equalTo: button.rightAnchor),
            textViewContainer.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20)
        ])
    }



    @objc fileprivate func loadButtonAction(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchWebData), object: self)//Canceling previous request when frequently button press occurring within 1 second
        perform(#selector(self.fetchWebData), with: self, afterDelay: 1.0)//Delaying 1 sec
    }

    @objc fileprivate func fetchWebData(){
        status.onInitialLoad = false
        let webUrl = "https://www.bioscopelive.com/en/disclaimer"
        viewModel.fetchWebContent(webUrl, true)
    }

    fileprivate func showPrintedResultsOnTextView(){
        status.showWebContent = false
        viewModel.lastCharacterAndEvery10thCharacters = { lastCharacter, every10thCharacters in
            DispatchQueue.main.async {
                let answerOne = "Question 1 Solution:\n \(lastCharacter)"
                let answerTwo = "\n Question 2 Solution:\n \(every10thCharacters)"

                self.textView.text = answerOne + answerTwo
            }
        }

        viewModel.wordCountsInString = { wordCounts in
            DispatchQueue.main.async {
                let answerThree = "\n Question 3 Solution:\n \(wordCounts)"
                let updatedString = self.textView.text + answerThree
                self.textView.text = updatedString
            }
        }
    }

    func showResponseOnTextView() {
        viewModel.allResponseFromWebUrl = {[weak self] content in
            guard let self = self else { return }
            if self.status.onInitialLoad || !self.status.showWebContent { return }
            DispatchQueue.main.async {
                self.textView.text = content
            }
        }
    }
}

