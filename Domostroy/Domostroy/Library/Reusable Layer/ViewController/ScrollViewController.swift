//
//  ScrollableViewController.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 06.04.2025.
//

import UIKit

class ScrollViewController: BaseViewController {

    // MARK: - Properties

    var keyboardHeight: CGFloat {
        _keyboardHeight
    }
    private var _keyboardHeight: CGFloat = 0

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

    deinit {
        NotificationCenter.default.removeObserver(self)
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

    func scrollToView(_ target: UIView, offsetY: CGFloat = 0) {
        let convertedFrame = target.convert(target.bounds, to: view)
        let visibleRectHeight = scrollView.bounds.height - keyboardHeight - offsetY
        let activeBottom = convertedFrame.maxY

        if activeBottom > visibleRectHeight {
            let offsetY = activeBottom - visibleRectHeight
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentInset.bottom = self.keyboardHeight
                self.scrollView.verticalScrollIndicatorInsets.bottom = self.keyboardHeight
                self.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
                self.scrollView.layoutIfNeeded()
            }
        }
    }

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    @objc
    func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        self._keyboardHeight = keyboardHeight
    }

    @objc
    func keyboardWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                self?.scrollView.contentInset.bottom = .zero
                self?.scrollView.verticalScrollIndicatorInsets.bottom = .zero
                self?.view.layoutIfNeeded()
            }
        }
    }

}
