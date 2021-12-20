import AdaptiveCards_bridge
import AppKit

// MARK: ACRChoiceSetView
class ACRChoiceSetView: NSView, InputHandlingViewProtocol {
    private lazy var stackview: NSStackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var errorMessageHandler: ErrorMessageHandlerDelegate?
    public var isRadioGroup = false
    public var previousButton: ACRChoiceButton?
    public var wrap = false
    public var idString: String?
    
    private let renderConfig: RenderConfig
    var isRequired = false
    
    init(renderConfig: RenderConfig) {
        self.renderConfig = renderConfig
        super.init(frame: .zero)
        addSubview(stackview)
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        stackview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func handleClickAction(_ clickedButton: ACRChoiceButton) {
        errorMessageHandler?.hideErrorMessage(for: self)
        guard isRadioGroup else { return }
        if previousButton != clickedButton {
            previousButton?.state = .off
            previousButton = clickedButton
        } else {
            clickedButton.state = .on
        }
    }
    
    public func addChoiceButton(_ choiceButton: ACRChoiceButton) {
        choiceButton.delegate = self
        stackview.addArrangedSubview(choiceButton)
    }
    
    public func setupButton(attributedString: NSMutableAttributedString, value: String?) -> ACRChoiceButton {
        let newButton = ACRChoiceButton(renderConfig: renderConfig, buttonType: isRadioGroup ? .radio : .switch)
        newButton.labelAttributedString = attributedString
        newButton.wrap = self.wrap
        newButton.buttonValue = value
        newButton.setAccessibilityLabel(attributedString.string)
        return newButton
    }
    
    func showError() {
        errorMessageHandler?.showErrorMessage(for: self)
    }
    
    var value: String {
        var stringOfSelectedValues: [String] = []
        let arrayViews = stackview.arrangedSubviews
        for view in arrayViews {
            if let view = view as? ACRChoiceButton, view.state == .on {
                stringOfSelectedValues.append(view.buttonValue ?? "")
            }
        }
        return stringOfSelectedValues.joined(separator: ",")
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        return isRequired ? stackview.arrangedSubviews.contains(where: { let elem = $0 as? ACRChoiceButton; return elem?.state == .on }) : true
    }
    
    var isRequired: Bool {
        return false
    }
    
    func showError() {
        // do nothing
    }
}
// MARK: Extension
extension ACRChoiceSetView: ACRChoiceButtonDelegate {
    func acrChoiceButtonDidSelect(_ button: ACRChoiceButton) {
        handleClickAction(button)
    }
}

// MARK: ACRChoiceSetFieldCompactView
class ACRChoiceSetCompactView: NSPopUpButton, InputHandlingViewProtocol {
    weak var errorMessageHandler: ErrorMessageHandlerDelegate?
    public let type: ACSChoiceSetStyle = .compact
    public var idString: String?
    public var valueSelected: String?
    public var arrayValues: [String?] = []
    var isRequired = false
    
    override func viewDidMoveToSuperview() {
        guard let superview = superview else { return }
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
    
    init() {
        super.init(frame: .zero, pullsDown: false)
        target = self
        action = #selector(popUpButtonUsed(_:))
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseEntered(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRChoiceSetCompactView else { return }
        contentView.isHighlighted = true
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let contentView = event.trackingArea?.owner as? ACRChoiceSetCompactView else { return }
        contentView.isHighlighted = false
    }
    
    @objc private func popUpButtonUsed(_ sender: NSPopUpButton) {
        errorMessageHandler?.hideErrorMessage(for: self)
    }
    
    func showError() {
        errorMessageHandler?.showErrorMessage(for: self)
    }
    
    var value: String {
        return arrayValues[indexOfSelectedItem] ?? ""
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        return isRequired ? (arrayValues[indexOfSelectedItem] != nil) : true
    }
    
    var isRequired: Bool {
        return false
    }
    
    func showError() {
        // do nothing
    }
}
