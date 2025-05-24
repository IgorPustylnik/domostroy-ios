//
//  AdminPanelViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class AdminPanelViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let searchSettingsViewHeight: CGFloat = 36
    }

    // MARK: - UI Elements

    private lazy var mainBar = {
        navigationBar.mainBar
    }()

    private lazy var segmentedControl = UISegmentedControl()

    private lazy var searchTextField = {
        $0.onBeginEditing = { [weak self] _ in
            self?.output?.setSearch(active: true)
        }
        $0.onEndEditing = { [weak self] _ in
            self?.output?.setSearch(active: false)
        }
        $0.onShouldReturn = { [weak self] textField in
            self?.output?.setSearch(active: false)
            self?.output?.search(query: textField.text)
        }
        $0.onCancel = { [weak self] textField in
            self?.output?.cancel()
        }
        return $0
    }(DSearchTextField())

    private lazy var offerSearchSettingsView = {
        $0.onOpenCity = { [weak self] in
            self?.output?.showOfferSearchCity()
        }
        $0.onOpenSort = { [weak self] in
            self?.output?.showOfferSearchSort()
        }
        $0.onOpenFilters = { [weak self] in
            self?.output?.showOfferSearchFilters()
        }
        $0.snp.makeConstraints { make in
            make.height.equalTo(Constants.searchSettingsViewHeight)
        }
        return $0
    }(SearchSettingsView())

    private lazy var overlayView = {
        $0.backgroundColor = .systemBackground
        $0.alpha = 0
        return $0
    }(UIView())

    private var currentViewController: UIViewController?
    private lazy var contentView = UIView()

    // MARK: - Properties

    var output: AdminPanelViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupContentView()
        setupSearchOverlayView()
        super.viewDidLoad()
        setupNavbar()
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hidesTabBar = true
    }

    private func setupNavbar() {
        navigationBar.title = L10n.Localizable.AdminPanel.title
        navigationBar.addArrangedSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedIndex(_:)), for: .valueChanged)
        navigationBar.addArrangedSubview(searchTextField)
        navigationBar.addArrangedSubview(offerSearchSettingsView)
    }

    private func setupSearchOverlayView() {
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - AdminPanelViewInput

extension AdminPanelViewController: AdminPanelViewInput {
    func setupSegments(_ values: [String], selectedIndex: Int) {
        segmentedControl.removeAllSegments()
        for (index, value) in values.enumerated() {
            segmentedControl.insertSegment(withTitle: value, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedIndex
    }

    func setRoot(_ presentable: Presentable, as segment: AdminPanelPresenterModel.Segment, scrollView: UIScrollView?) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        guard let vc = presentable.toPresent() else {
            return
        }
        addChild(vc)
        vc.didMove(toParent: self)

        observeScrollOffset(scrollView)

        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        currentViewController = vc

        offerSearchSettingsView.isHidden = segment != .offers
        offerSearchSettingsView.alpha = segment != .offers ? 0 : 1
    }

    func setSearchQuery(_ query: String?) {
        searchTextField.setText(query)
    }

    func setOffersCity(_ city: String) {
        offerSearchSettingsView.set(city: city)
    }

    func setOffersSort(_ sort: String) {
        offerSearchSettingsView.set(sort: sort)
    }

    func setOffersHasFilters(_ hasFilters: Bool) {
        offerSearchSettingsView.set(hasFilters: hasFilters)
    }

    func setSearchOverlay(active: Bool, from segment: AdminPanelPresenterModel.Segment) {
        if active {
            segmentedControl.snp.makeConstraints { make in
                make.height.equalTo(segmentedControl.frame.height)
            }
        } else {
            segmentedControl.snp.removeConstraints()
        }
        UIView.animate(withDuration: 0.3) {
            self.mainBar.alpha = active ? 0 : 1
            self.mainBar.isHidden = active
            self.segmentedControl.alpha = active ? 0 : 1
            self.segmentedControl.isHidden = active
            if segment == .offers {
                self.offerSearchSettingsView.alpha = active ? 0 : 1
                self.offerSearchSettingsView.isHidden = active
            }
            self.overlayView.alpha = active ? 1 : 0
            self.navigationBar.layoutIfNeeded()
        }
    }
}

// MARK: - Selectors

@objc
private extension AdminPanelViewController {
    func segmentedControlChangedIndex(_ sender: UISegmentedControl) {
        output?.selectSegment(sender.selectedSegmentIndex)
    }
}
