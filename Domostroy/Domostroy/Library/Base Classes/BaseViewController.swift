//
//  BaseViewController.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 05.04.2025.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    // MARK: - Properties

    private lazy var _navigationBar = DNavigationBar()
    var navigationBar: DNavigationBar {
        _navigationBar
    }

    private var shouldUpdateTopInset: Bool = true

    private var contentOffsetObservation: NSKeyValueObservation?

    var shouldShowBackButton: Bool {
        guard let navigationController = navigationController else {
            return false
        }
        return navigationController.viewControllers.count > 1 && navigationController.viewControllers.first != self
    }

    var hidesTabBar: Bool = false

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController != nil {
            setCustomNavigationBar()
            setupInteractivePopGesture()
            setBackButtonIfNeeded()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabBarController = tabBarController as? MainTabBarViewController else {
            return
        }

        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                tabBarController.setTabBarHidden(self.hidesTabBar, animated: false)
            }, completion: nil)
        } else {
            tabBarController.setTabBarHidden(hidesTabBar, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let coordinator = transitionCoordinator,
              let tabBarController = tabBarController as? MainTabBarViewController else {
            return
        }

        coordinator.notifyWhenInteractionChanges { [weak self] context in
            guard let self else {
                return
            }
            if context.isCancelled {
                tabBarController.setTabBarHidden(self.hidesTabBar, animated: true)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldUpdateTopInset {
            additionalSafeAreaInsets.top = 0
            navigationBar.topInset = view.safeAreaInsets.top
            navigationBar.invalidateIntrinsicContentSize()
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                self.navigationBar.setNeedsLayout()
                self.navigationBar.layoutIfNeeded()
            }
            shouldUpdateTopInset = false
        }
        additionalSafeAreaInsets.top = navigationBar.frame.height - navigationBar.topInset
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.shouldUpdateTopInset = true
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }

}

// MARK: - Scroll handling

extension BaseViewController {

    func observeScrollOffset(_ scrollView: UIScrollView) {
        contentOffsetObservation = scrollView.observe(
            \.contentOffset, options: [.new]
        ) { [weak self] scrollView, change in
            guard let offsetY = change.newValue?.y, let self else {
                return
            }
            self.handleScroll(offsetY: offsetY + self.navigationBar.frame.height)
        }
    }

    func handleScroll(offsetY: CGFloat) {
        let threshold: Double = 2
        let progress = min(max(offsetY / threshold, 0), 1)
        navigationBar.setScrollEdgeAppearance(progress: progress)
    }

}

// MARK: - Private methods

private extension BaseViewController {

    func setCustomNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        if !view.subviews.contains(navigationBar) {
            view.addSubview(navigationBar)
            navigationBar.topInset = view.safeAreaInsets.top
            navigationBar.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
            }
        }
    }

    func setupInteractivePopGesture() {
        guard let navigationController = self.navigationController else {
            return
        }

        if let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            if navigationController.viewControllers.count > 1 &&
                interactivePopGestureRecognizer.delegate != nil {
                interactivePopGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
                interactivePopGestureRecognizer.isEnabled = true
            }
        }
    }

    func setBackButtonIfNeeded() {
        if shouldShowBackButton {
            navigationBar.addButtonToLeft(image: .NavigationBar.chevronLeft) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

}
