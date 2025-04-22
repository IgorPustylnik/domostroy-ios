//
//  ScrollableViewController.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 06.04.2025.
//

import UIKit

private final class TouchesCancellableScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is DButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}

class ScrollViewController: BaseViewController {

    // MARK: - Properties

    private(set) var keyboardHeight: CGFloat = 0

    private(set) var scrollView: UIScrollView = TouchesCancellableScrollView()

    private var activityIndicator = UIActivityIndicatorView(style: .medium)

    var contentView = UIView()

    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        observeScrollOffset(scrollView)
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
        setupIndicatorView()
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        scrollView.delaysContentTouches = false
    }

    func setupIndicatorView() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    func scrollToView(_ target: UIView, offsetY: CGFloat = 0) {
        let targetFrame = target.convert(target.bounds, to: scrollView)
        let blockedAreaHeight = keyboardHeight + offsetY

        let visibleY = scrollView.contentOffset.y
        let visibleHeight = scrollView.bounds.height - blockedAreaHeight
        let visibleBottomY = visibleY + visibleHeight

        if targetFrame.minY < visibleY {
            let newOffsetY = max(targetFrame.minY - 16, 0)
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentInset.bottom = blockedAreaHeight
                self.scrollView.verticalScrollIndicatorInsets.bottom = blockedAreaHeight
                self.scrollView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: false)
                self.scrollView.layoutIfNeeded()
            }
        } else if targetFrame.maxY > visibleBottomY {
            let newOffsetY = min(
                targetFrame.maxY - visibleHeight + 16,
                scrollView.contentSize.height - scrollView.bounds.height
            )
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentInset.bottom = blockedAreaHeight
                self.scrollView.verticalScrollIndicatorInsets.bottom = blockedAreaHeight
                self.scrollView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: false)
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        self.keyboardHeight = keyboardHeight
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

extension ScrollViewController: Loadable {

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.isHidden = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()

        }
    }

}
