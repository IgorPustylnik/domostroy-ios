//
//  ScrollableViewController.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 06.04.2025.
//

import UIKit

class ScrollViewController: BaseViewController {

    // MARK: - Properties

    var scrollView: UIScrollView {
        _scrollView
    }
    private var _scrollView = UIScrollView()

    var contentView = UIView()

    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _scrollView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupScrollView()
        super.viewDidLoad()
    }

    private func setupScrollView() {
        view.addSubview(_scrollView)
        _scrollView.addSubview(contentView)
        _scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(_scrollView.safeAreaLayoutGuide)
            make.size.equalTo(_scrollView.safeAreaLayoutGuide)
        }
    }

}
