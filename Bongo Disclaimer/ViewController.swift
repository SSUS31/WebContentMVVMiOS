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

        setupViews()
        viewModel = ViewModel()
        updateFirstCharacter()
    }

    //MARK:- Setup Views
    fileprivate func setupViews() {
        view.addSubview(button)
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            //Constraints for Button
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            //Constraints for TextView
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leftAnchor.constraint(equalTo: button.leftAnchor),
            textView.rightAnchor.constraint(equalTo: button.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20)
        ])
    }



    @objc fileprivate func loadButtonAction(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchWebData), object: self)//Canceling previous request when frequently button press occurring within 1 second
        perform(#selector(self.fetchWebData), with: self, afterDelay: 1.0)//Delaying 1 sec
    }

    @objc fileprivate func fetchWebData(){
        let webUrl = "https://www.bioscopelive.com/en/disclaimer"
        print(webUrl)
        viewModel.fetchWebContent(webUrl)
    }

    fileprivate func updateFirstCharacter(){
        viewModel.lastCharacter = { lastCharacter in
            DispatchQueue.main.async {
                let updatedString = "1:\n \(lastCharacter)" + self.textView.text
                self.textView.text = updatedString
            }
        }

        viewModel.wordCountsInString = { wordCounts in

            DispatchQueue.main.async {
                let updatedString = self.textView.text + "2:\n \(wordCounts)"
                self.textView.text = updatedString
            }
        }
    }
}

