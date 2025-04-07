//
//  CodeConfirmationViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class CodeConfirmationViewController: ScrollViewController {

    // MARK: - Properties

    private var codeConfirmationView = CodeConfirmationView()

    var output: CodeConfirmationViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        output?.viewLoaded()
        hidesTabBar = true
    }

    override func loadView() {
        super.loadView()
        contentView = codeConfirmationView
    }

}

// MARK: - CodeConfirmationViewInput

extension CodeConfirmationViewController: CodeConfirmationViewInput {

    func setupInitialState(length: Int, email: String) {
        codeConfirmationView.configure(length: length, email: email)
    }

}
