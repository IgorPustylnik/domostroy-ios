//
//  RequestsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class RequestsViewController: BaseViewController {

    // MARK: - Properties

    private var requestsView = RequestsView()

    var output: RequestsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        view = requestsView
    }
}

// MARK: - RequestsViewInput

extension RequestsViewController: RequestsViewInput {

    func setupInitialState() {

    }

}
