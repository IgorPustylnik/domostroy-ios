//
//  FullScreenImageCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.06.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class FullScreenImageCollectionViewCell: UICollectionViewCell {

    // MARK: - ViewModel

    struct ViewModel {
        let loadImage: LoadImageClosure
    }

    // MARK: - Constants

    private enum Constants {
        static let maxZoomScale: CGFloat = 2
        static let doubleTapZoomScale: CGFloat = 1.3
    }

    // MARK: - UI Elements

    private lazy var scrollView = {
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.scrollsToTop = false
        return $0
    }(UIScrollView())

    private lazy var imageView = {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())

    private var imageViewTopConstraint: Constraint?
    private var imageViewBottomConstraint: Constraint?
    private var imageViewLeadingConstraint: Constraint?
    private var imageViewTrailingConstraint: Constraint?

    private lazy var spinner = {
        $0.tintColor = .white
        return $0
    }(DLoadingIndicator())

    private lazy var doubleTapGesture = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        updateConstraintsForSize(bounds.size)
        updateMinZoomScaleForSize(bounds.size)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(scrollView)
        addSubview(spinner)
        scrollView.addSubview(imageView)

        scrollView.addGestureRecognizer(doubleTapGesture)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            imageViewTopConstraint = make.top.equalToSuperview().constraint
            imageViewBottomConstraint = make.bottom.equalToSuperview().constraint
            imageViewLeadingConstraint = make.leading.equalToSuperview().constraint
            imageViewTrailingConstraint = make.trailing.equalToSuperview().constraint
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = Constants.maxZoomScale
        scrollView.zoomScale = minScale
    }

    func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint?.update(offset: yOffset)
        imageViewBottomConstraint?.update(offset: yOffset)
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint?.update(offset: xOffset)
        imageViewTrailingConstraint?.update(offset: xOffset)
        layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate

extension FullScreenImageCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(bounds.size)
    }
}

// MARK: - ConfigurableItem

extension FullScreenImageCollectionViewCell: ConfigurableItem {
    func configure(with model: ViewModel) {
        spinner.isHidden = false
        model.loadImage(imageView) { [weak self] in
            self?.spinner.isHidden = true
        }
    }
}

// MARK: - Gesture handling

private extension FullScreenImageCollectionViewCell {
    @objc
    func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: imageView)

        let currentScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = min(Constants.doubleTapZoomScale, scrollView.maximumZoomScale)

        let newScale: CGFloat
        if currentScale == minScale {
            newScale = maxScale
        } else {
            newScale = minScale
        }

        let scrollViewSize = scrollView.bounds.size
        let zoomRect = zoomRectForScale(newScale, center: pointInView, scrollViewSize: scrollViewSize)

        scrollView.zoom(to: zoomRect, animated: true)
    }

    func zoomRectForScale(_ scale: CGFloat, center: CGPoint, scrollViewSize: CGSize) -> CGRect {
        let zoomRectSize = CGSize(
            width: scrollViewSize.width / scale,
            height: scrollViewSize.height / scale
        )

        let zoomRectOrigin = CGPoint(
            x: center.x - zoomRectSize.width / 2,
            y: center.y - zoomRectSize.height / 2
        )

        return CGRect(origin: zoomRectOrigin, size: zoomRectSize)
    }
}
