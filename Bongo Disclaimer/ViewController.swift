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
    ///Saving data locally
    var dataSource = (onInitialLoad: true , response: NSAttributedString() , result: String())

    lazy var button:UIButton = {
        let font = UIFont(name: "Chalkduster", size: 20)
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("LOAD_BUTTON_TITLE_RESPONSE", comment: ""), for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1411764706, alpha: 0.5)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(self.loadButtonAction), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        button.layer.shadowOpacity = 0.9
        button.layer.shadowRadius = 10
        button.tag = 1
        return button
    }()

    lazy var textViewContainer:UIView = {
        let view = UIView()
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.shadowColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1411764706, alpha: 0.9039223031)
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: -16)
        view.layer.shadowOpacity = 0.4
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
        textView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        textView.isEditable = false
        textView.layer.cornerRadius = 30
        textView.textContainerInset.top = 20
        return textView
    }()


    //MARK:- LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        setupViews()
//        viewModel.fetchWebContent("", false)
        fetchWebData()
        showPrintedResultsOnTextView()
        showResponseOnTextView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        appearanceAnimationOfViews()
    }

    //MARK:- Setup Views
    fileprivate func setupViews() {
        view.addSubview(button)
        view.addSubview(textViewContainer)

        NSLayoutConstraint.activate([
            //Constraints for Button
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            //Constraints for TextViewContainer
            textViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            textViewContainer.leftAnchor.constraint(equalTo: button.leftAnchor),
            textViewContainer.rightAnchor.constraint(equalTo: button.rightAnchor),
            textViewContainer.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20)
        ])
    }

    //MARK: Animations
    fileprivate func appearanceAnimationOfViews() {
        UIView.animate(withDuration: 1.2, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.textViewContainer.alpha = 1
            self.textViewContainer.transform = .identity

        }, completion: { success in
            if success {
                UIView.animate(withDuration: 0.3) {
                    self.button.layer.cornerRadius = 25
                    self.button.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
                }
            }
        })
    }


    //MARK: Button Action
    @objc fileprivate func loadButtonAction(){
        if self.button.tag == 1 {
            self.textView.attributedText = dataSource.response
        } else {
            self.textView.text = dataSource.result
            toggleButtonTitle()

            return
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchWebData), object: self)//Canceling previous request when frequently button press occurring within 1 second
        perform(#selector(self.fetchWebData), with: self, afterDelay: 1.2)//Delaying 1.2 sec
    }

    //MARK:- API calling by ViewModel
    @objc fileprivate func fetchWebData(){
        let webUrl = "https://www.bioscopelive.com/en/disclaimer"
        viewModel.fetchWebContent(webUrl, dataSource.onInitialLoad)
        dataSource.onInitialLoad = false
    }

    //MARK:- Showing calculated result in UITextView
    fileprivate func showPrintedResultsOnTextView(){
        viewModel.lastCharacterAndEvery10thCharacters = {[weak self] lastCharacter, every10thCharacters in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let answerOne = "Printing the last character:\n \(lastCharacter)"
                let answerTwo = "\n Printing every 10th character:\n \(every10thCharacters)"

                self.dataSource.result = answerOne + answerTwo
            }
        }

        viewModel.wordCountsInString = {[weak self] wordCounts in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let answerThree = "\n Printing the count of every word:\n \(wordCounts)"
                let updatedString = self.dataSource.result + answerThree

                self.dataSource.result = updatedString
            }
        }
    }

    //MARK:- Toggling button title
    fileprivate func toggleButtonTitle() {
        self.button.tag = self.button.tag == 1 ? 0 : 1
        let title = self.button.tag == 1 ? NSLocalizedString("LOAD_BUTTON_TITLE_RESPONSE", comment: "") : NSLocalizedString("LOAD_BUTTON_TITLE_RESULT", comment: "")

        self.button.setTitle(title, for: .normal)
    }

    //MARK:- Showing web response in UITextView
    func showResponseOnTextView() {
        viewModel.allResponseFromWebUrl = {[weak self] content in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.dataSource.response = content
                self.textView.attributedText = content

                self.toggleButtonTitle()
            }
        }
    }
}

