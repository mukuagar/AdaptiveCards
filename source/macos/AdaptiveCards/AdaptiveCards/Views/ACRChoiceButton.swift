import AdaptiveCards_bridge
import AppKit

enum ChoiceSetButtonType {
    case radio
    case `switch`
}

protocol ACRChoiceButtonDelegate: NSObjectProtocol {
    func acrChoiceButtonDidSelect(_ button: ACRChoiceButton)
    func acrChoiceButtonShouldReadError(_ button: ACRChoiceButton) -> Bool
}

class ACRChoiceButton: NSView, NSTextFieldDelegate, InputHandlingViewProtocol {
    weak var delegate: ACRChoiceButtonDelegate?
    weak var errorDelegate: InputHandlingViewErrorDelegate?
    
    public var buttonValue: String?
    private let idString: String?
    private let valueOn: String?
    private let valueOff: String?
    private let wrap: Bool
    
    private let renderConfig: RenderConfig
    private let buttonConfig: ChoiceSetButtonConfig?
    private let buttonType: ChoiceSetButtonType
    private let localisedStringConfig: LocalisedStringConfig
    private let buttonLabel: String?
    private let buttonTitle: String?
    private let errorMessage: String?
    var isRequired = false
    
    init(renderConfig: RenderConfig, buttonType: ChoiceSetButtonType, element: ACSToggleInput) {
        // initialize configs
        self.renderConfig = renderConfig
        self.buttonType = buttonType
        self.buttonConfig = buttonType == .switch ? renderConfig.checkBoxButtonConfig : renderConfig.radioButtonConfig
        self.localisedStringConfig = renderConfig.localisedStringConfig
        
        // initialize variables
        idString = element.getId()
        isRequired = element.getIsRequired()
        // This function returns true/fase even if data not set in json
        valueOn = element.getValueOn()
        valueOff = element.getValueOff()
        wrap = element.getWrap()
        buttonLabel = element.getLabel()
        errorMessage = element.getErrorMessage()
        buttonTitle = element.getTitle()
        
        super.init(frame: .zero)
        initialise()
    }
    
    init(renderConfig: RenderConfig, buttonType: ChoiceSetButtonType, element: ACSChoiceSetInput, title: String?) {
        // initialize configs
        self.renderConfig = renderConfig
        self.buttonType = buttonType
        self.buttonConfig = buttonType == .switch ? renderConfig.checkBoxButtonConfig : renderConfig.radioButtonConfig
        self.localisedStringConfig = renderConfig.localisedStringConfig
        // initialise variables
        self.idString = nil
        self.valueOn = nil
        self.valueOff = nil
        wrap = element.getWrap()

        self.buttonLabel = element.getLabel()
        self.errorMessage = element.getErrorMessage()
        self.buttonTitle = title
        super.init(frame: .zero)
        initialise()
    }
    
    private func initialise() {
        button.setButtonType(buttonType == .switch ? .switch : .radio)
        setupViews()
        setupConstraints()
        setupActions()
        updateButtonImage()
        setupTrackingArea()
        setupAccessibility()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Label
    private (set) lazy var buttonLabelField: NSTextField = {
        let view = NSTextField()
        view.isEditable = false
        view.delegate = self
        view.isBordered = false
        view.isHighlighted = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.cell?.wraps = wrap
        return view
    }()
    
    // Button
    private (set) lazy var button: NSButton = {
        let view = NSButton()
        view.title = ""
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Click on Text to change state
    override func mouseDown(with event: NSEvent) {
        state = buttonType == .switch && state == .on ? .off : .on
        if  state == .on {
            handleButtonAction()
        }
        updateButtonImage()
    }
    
    private func setupViews() {
        addSubview(button)
        addSubview(buttonLabelField)
    }
    
    private func setupActions() {
        // random action
        button.target = self
        button.action = #selector(handleButtonAction)
    }
    
    private func setupConstraints() {
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        buttonLabelField.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: buttonConfig?.elementSpacing ?? 8).isActive = true
        buttonLabelField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonLabelField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        buttonLabelField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    private func setupAccessibility() {
        setAccessibilityElement(true)
        setAccessibilityRole(buttonType == .radio ? .radioButton : .checkBox)
    }
    
    override func mouseEntered(with event: NSEvent) {
        button.isHighlighted = true
    }
    override func mouseExited(with event: NSEvent) {
        button.isHighlighted = false
    }
    
    private func updateButtonImage() {
        switch state {
        case .on:
            button.image = buttonConfig?.selectedHighlightedIcon
            button.alternateImage = buttonConfig?.selectedIcon
        case .off:
            button.alternateImage = buttonConfig?.highlightedIcon
            button.image = buttonConfig?.normalIcon
        default:
            break
        }
        button.image?.size = NSSize(width: 16, height: 16)
        button.alternateImage?.size = NSSize(width: 16, height: 16)
        button.imageScaling = .scaleProportionallyUpOrDown
        if buttonType == .switch {
            NSAccessibility.announce(valueChangedMessage())
        }
    }
    
    func showError() {
        errorDelegate?.inputHandlingViewShouldShowError(self)
    }
    
    private var isErrorVisible: Bool {
        if let delegate = delegate {
            return delegate.acrChoiceButtonShouldReadError(self)
        }
        if let errorDelegate = errorDelegate {
            return errorDelegate.isErrorVisible
        }
        return false
    }
    
    override func accessibilityLabel() -> String? {
        guard renderConfig.supportsSchemeV1_3 else {
            return buttonTitle
        }
        var accessibilityLabel = ""
        if isErrorVisible {
            accessibilityLabel += "Error "
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                accessibilityLabel += errorMessage + ", "
            }
        }
        if let label = buttonLabel, !label.isEmpty {
            accessibilityLabel += label + ", "
        }
        accessibilityLabel += buttonTitle ?? ""
        return accessibilityLabel
    }
    
    @objc private func handleButtonAction() {
        delegate?.acrChoiceButtonDidSelect(self)
        updateButtonImage()
        if buttonType == .radio {
            NSAccessibility.announce(valueChangedMessage())
        }
        errorDelegate?.inputHandlingViewShouldHideError(self, currentFocussedView: button)
    }
    
    var value: String {
        return (state == .on ? valueOn: valueOff) ?? ""
    }
    
    var key: String {
        guard let id = idString else {
            logError("ID must be set on creation")
            return ""
        }
        return id
    }
    
    var isValid: Bool {
        return isRequired ? (state == .on) : true
    }
    
    override func accessibilityValue() -> Any? {
        return state
    }

    private func valueChangedMessage() -> String {
        var message: String
        message = state == .on ? (buttonType == .switch ? localisedStringConfig.choiceSetTickBoxTicked : localisedStringConfig.choiceSetRadioButtonSelected) : (buttonType == .switch ? localisedStringConfig.choiceSetTickBoxUnticked : "")
        message += ", " + (accessibilityLabel() ?? "")
        message += ", " + (accessibilityRole()?.description(with: .none) ?? "")
        return message
    }
}
// MARK: EXTENSION
extension ACRChoiceButton {
    var backgroundColor: NSColor {
        get { buttonLabelField.backgroundColor ?? .clear }
        set {
            buttonLabelField.backgroundColor = newValue
        }
    }
    
    var labelAttributedString: NSAttributedString {
        get { buttonLabelField.attributedStringValue }
        set {
            buttonLabelField.attributedStringValue = newValue
        }
    }
    
    var state: NSControl.StateValue {
        get { button.state }
        set {
            button.state = newValue
            updateButtonImage()
        }
    }
}

extension NSAccessibility {
    public static func announce(_ message: String) {
        DispatchQueue.main.asyncAfter(duration: 0.2, execute: {
            self.post(
                element: NSApp.mainWindow as Any,
                notification: .announcementRequested,
                userInfo: [.announcement: message, .priority: NSAccessibilityPriorityLevel.high.rawValue]
            )
        })
    }
}

extension DispatchQueue {
    func asyncAfter(duration: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + duration, execute: execute)
    }
}
