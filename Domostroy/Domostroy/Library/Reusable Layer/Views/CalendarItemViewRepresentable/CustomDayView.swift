//
//  CustomDayView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 15.05.2025.
//

import UIKit
import HorizonCalendar

// MARK: - CustomDayView

/// A view that represents a day in the calendar.
public final class CustomDayView: UIView {

    // MARK: Lifecycle

    fileprivate init(invariantViewProperties: InvariantViewProperties) {
        self.invariantViewProperties = invariantViewProperties

        backgroundLayer = CAShapeLayer()
        let backgroundShapeDrawingConfig = invariantViewProperties.backgroundShapeDrawingConfig
        backgroundLayer.fillColor = backgroundShapeDrawingConfig.fillColor.cgColor
        backgroundLayer.strokeColor = backgroundShapeDrawingConfig.borderColor.cgColor
        backgroundLayer.lineWidth = backgroundShapeDrawingConfig.borderWidth

        let isUserInteractionEnabled: Bool
        let supportsPointerInteraction: Bool
        switch invariantViewProperties.interaction {
        case .disabled:
            isUserInteractionEnabled = false
            supportsPointerInteraction = false
            highlightLayer = nil

        case .enabled(_, let _supportsPointerInteraction):
            isUserInteractionEnabled = true
            supportsPointerInteraction = _supportsPointerInteraction

            highlightLayer = CAShapeLayer()
            let highlightShapeDrawingConfig = invariantViewProperties.highlightShapeDrawingConfig
            highlightLayer?.fillColor = highlightShapeDrawingConfig.fillColor.cgColor
            highlightLayer?.strokeColor = highlightShapeDrawingConfig.borderColor.cgColor
            highlightLayer?.lineWidth = highlightShapeDrawingConfig.borderWidth
        }

        label = UILabel()
        label.font = invariantViewProperties.font
        label.textAlignment = invariantViewProperties.textAlignment
        label.textColor = invariantViewProperties.textColor

        super.init(frame: .zero)

        self.isUserInteractionEnabled = isUserInteractionEnabled

        backgroundColor = invariantViewProperties.backgroundColor

        layer.addSublayer(backgroundLayer)
        highlightLayer.map { layer.addSublayer($0) }

        addSubview(label)

        setHighlightLayerVisibility(isHidden: true, animated: false)

        if supportsPointerInteraction {
            addInteraction(UIPointerInteraction(delegate: self))
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    public override func layoutSubviews() {
        super.layoutSubviews()

        let edgeInsets = invariantViewProperties.edgeInsets
        let insetBounds = bounds.inset(
            by: UIEdgeInsets(
                top: edgeInsets.top,
                left: edgeInsets.leading,
                bottom: edgeInsets.bottom,
                right: edgeInsets.trailing))

        let path: CGPath
        switch invariantViewProperties.shape {
        case .circle:
            let radius = min(insetBounds.size.width, insetBounds.size.height) / 2
            let origin = CGPoint(x: insetBounds.midX - radius, y: insetBounds.midY - radius)
            let size = CGSize(width: radius * 2, height: radius * 2)
            path = UIBezierPath(ovalIn: CGRect(origin: origin, size: size)).cgPath

        case .rectangle(let cornerRadius):
            path = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius).cgPath
        }

        backgroundLayer.path = path
        highlightLayer?.path = path

        label.frame = CGRect(
            x: edgeInsets.leading,
            y: edgeInsets.top,
            width: insetBounds.width,
            height: insetBounds.height)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        setHighlightLayerVisibility(isHidden: false, animated: true)

        if
            case .enabled(let playsHapticsOnTouchDown, _) = invariantViewProperties.interaction,
            playsHapticsOnTouchDown {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        setHighlightLayerVisibility(isHidden: true, animated: true)

        feedbackGenerator?.selectionChanged()
        feedbackGenerator = nil
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        setHighlightLayerVisibility(isHidden: true, animated: true)
        feedbackGenerator = nil
    }

    // MARK: Fileprivate

    fileprivate func setContent(_ content: Content) {
        if invariantViewProperties.strikethrough {
            let attributedString = NSMutableAttributedString(string: content.dayText)
            attributedString.addAttribute(.strikethroughStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            label.attributedText = attributedString
        } else {
            label.text = content.dayText
        }

        accessibilityLabel = content.accessibilityLabel
        accessibilityHint = content.accessibilityHint
    }

    // MARK: Private

    private let invariantViewProperties: InvariantViewProperties
    private let backgroundLayer: CAShapeLayer
    private let highlightLayer: CAShapeLayer?
    private let label: UILabel

    private var feedbackGenerator: UISelectionFeedbackGenerator?

    private func setHighlightLayerVisibility(isHidden: Bool, animated: Bool) {
        guard let highlightLayer else {
            return
        }

        let opacity: Float = isHidden ? 0 : 1

        if animated {
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            animation.fromValue = highlightLayer.presentation()?.opacity ?? highlightLayer.opacity
            animation.toValue = opacity
            animation.duration = 0.06
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            highlightLayer.add(animation, forKey: "fade")
        }

        highlightLayer.opacity = opacity
    }

}

// MARK: Accessibility

extension CustomDayView {

    public override var isAccessibilityElement: Bool {
        get { true }
        set { }
    }

    public override var accessibilityTraits: UIAccessibilityTraits {
        get { invariantViewProperties.accessibilityTraits }
        set { }
    }

}

// MARK: UIPointerInteractionDelegate

extension CustomDayView: UIPointerInteractionDelegate {

    public func pointerInteraction(
        _ interaction: UIPointerInteraction,
        styleFor _: UIPointerRegion)
    -> UIPointerStyle? {
        guard let interactionView = interaction.view else {
            return nil
        }

        let previewParameters = UIPreviewParameters()
        previewParameters.visiblePath = backgroundLayer.path.map { UIBezierPath(cgPath: $0) }

        let targetedPreview = UITargetedPreview(view: interactionView, parameters: previewParameters)

        return UIPointerStyle(effect: .highlight(targetedPreview))
    }

}

// MARK: CustomDayView.Content

extension CustomDayView {

    /// Encapsulates the data used to populate a `CustomDayView`'s text label. Use a `DateFormatter` to create the
    /// `accessibilityLabel` string.
    ///
    /// - Note: To avoid performance issues, reuse the same `DateFormatter` for each day, rather than creating
    /// a new `DateFormatter` for each day.
    public struct Content: Equatable {

        // MARK: Lifecycle

        public init(
            dayText: String,
            accessibilityLabel: String?,
            accessibilityHint: String?) {
            self.dayText = dayText
            self.accessibilityLabel = accessibilityLabel
            self.accessibilityHint = accessibilityHint
        }

        // MARK: Public

        public let dayText: String
        public let accessibilityLabel: String?
        public let accessibilityHint: String?
    }

}

// MARK: CustomDayView.InvariantViewProperties

extension CustomDayView {

    /// Encapsulates configurable properties that change the appearance and behavior of `CustomDayView`.
    /// These cannot be changed after a`CustomDayView` is initialized.
    public struct InvariantViewProperties: Hashable {

        // MARK: Lifecycle

        private init() { }

        // MARK: Public

        public enum Interaction: Hashable {
            case disabled
            case enabled(playsHapticsOnTouchDown: Bool = true, supportsPointerInteraction: Bool = true)
        }

        public static let baseNonInteractive = InvariantViewProperties()
        public static let baseInteractive: InvariantViewProperties = {
            var properties = baseNonInteractive
            properties.interaction = .enabled()
            properties.accessibilityTraits = .button
            return properties
        }()

        /// Whether user interaction is enabled or disabled. If this is set to disabled, the highlight layer will
        /// not appear on touch down and`isUserInteractionEnabled` will be set to `false`.
        public var interaction = Interaction.disabled

        /// The background color of the entire view, unaffected by `edgeInsets` and behind the background
        /// and highlight layers.
        public var backgroundColor = UIColor.clear

        /// Edge insets that apply to the background layer, highlight layer, and text label.
        public var edgeInsets = NSDirectionalEdgeInsets.zero

        /// The shape of the the background and highlight layers.
        public var shape = Shape.circle

        /// The drawing config for the always-visible background layer.
        public var backgroundShapeDrawingConfig = DrawingConfig.transparent

        /// Strikethrough line on the label
        public var strikethrough: Bool = false

        /// The drawing config for the highlight layer that shows up on touch-down if `self.interaction` is `.enabled`.
        public var highlightShapeDrawingConfig: DrawingConfig = {
            let color: UIColor
            if #available(iOS 13.0, *) {
                color = .systemFill
            } else {
                color = .lightGray
            }

            return DrawingConfig(fillColor: color, borderColor: .clear)
        }()

        /// The font of the day's label.
        public var font = UIFont.systemFont(ofSize: 18)

        /// The text alignment of the day's label.
        public var textAlignment = NSTextAlignment.center

        /// The text color of the day's label.
        public var textColor: UIColor = {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }()

        /// The accessibility traits of the `CustomDayView`.
        public var accessibilityTraits = UIAccessibilityTraits.staticText

        public func hash(into hasher: inout Hasher) {
            hasher.combine(interaction)
            hasher.combine(backgroundColor)
            hasher.combine(edgeInsets.leading)
            hasher.combine(edgeInsets.trailing)
            hasher.combine(edgeInsets.top)
            hasher.combine(edgeInsets.bottom)
            hasher.combine(shape)
            hasher.combine(backgroundShapeDrawingConfig)
            hasher.combine(highlightShapeDrawingConfig)
            hasher.combine(font)
            hasher.combine(textAlignment)
            hasher.combine(textColor)
            hasher.combine(accessibilityTraits)
        }

    }

}

// MARK: CalendarItemViewRepresentable

extension CustomDayView: CalendarItemViewRepresentable {

    public static func makeView(
        withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> CustomDayView {
        CustomDayView(invariantViewProperties: invariantViewProperties)
    }

    public static func setContent(_ content: Content, on view: CustomDayView) {
        view.setContent(content)
    }

}
