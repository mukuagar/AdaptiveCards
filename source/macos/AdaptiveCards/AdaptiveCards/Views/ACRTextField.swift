import AdaptiveCards_bridge
import AppKit

protocol ACRTextFieldDelegate: AnyObject {
    func acrTextFieldDidSelectClear(_ textField: ACRTextField)
}

class ACRTextField: NSTextField {
    weak var textFieldDelegate: ACRTextFieldDelegate?
    private let config: InputFieldConfig
    private let isDarkMode: Bool?
    private let textFieldMode: Mode
    
    init(dateTimeFieldWith config: RenderConfig) {
        self.config = config.inputFieldConfig
        textFieldMode = .dateTime
        isDarkMode = config.isDarkMode
        super.init(frame: .zero)
        initialise()
        setupConstraints()
    }
    
    init(config: InputFieldConfig) {
        self.config = config
        textFieldMode = .text
        self.isDarkMode = nil
        super.init(frame: .zero)
        initialise()
        setupConstraints()
    }
    
    init(numericFieldWith config: InputFieldConfig) {
        self.config = config
        textFieldMode = .number
        isDarkMode = nil
        super.init(frame: .zero)
        initialise()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialise() {
        let customCell = VerticallyCenteredTextFieldCell()
        customCell.drawsBackground = true
        customCell.backgroundColor = .clear
        // 20 points extra padding for calendar/clock icons
        var leftPadding: CGFloat = 0
        if textFieldMode == .dateTime {
            // 20 is image width and 12 is the spacing after image to text
            leftPadding += 32
            if config.clearButtonImage == nil {
                // Implies old date field, so clear button hugs edge
                leftPadding -= 12
            }
        } else {
            leftPadding += config.leftPadding
        }
        customCell.setupSpacing(rightPadding: config.rightPadding, leftPadding: leftPadding, focusRingCornerRadius: config.focusRingCornerRadius, borderWidth: config.borderWidth, borderColor: config.borderColor, wantsClearButton: wantsClearButton, isNumericField: textFieldMode == .number)
        cell = customCell
        font = config.font
        if wantsClearButton {
            addSubview(clearButton)
            clearButton.isHidden = true
        }
        // Add inintial backgound color to text box
        wantsLayer = true
        layer?.backgroundColor = config.backgroundColor.cgColor
        setupTrackingArea()
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: config.height).isActive = true
        if wantsClearButton {
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -config.rightPadding).isActive = true
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    private (set) lazy var clearButton: NSButtonWithImageSpacing = {
        let clearImage: NSImage?
        if let isDarkMode = isDarkMode, config.clearButtonImage == nil, wantsClearButton {
            // displaying old clear button
            let resourceName = isDarkMode ? "clear_18_w" : "clear_18"
            clearImage = BundleUtils.getImage(resourceName, ofType: "png")
        } else {
            clearImage = config.clearButtonImage
        }
        let view = NSButtonWithImageSpacing(image: clearImage ?? NSImage(), target: self, action: #selector(handleClearAction))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        view.isBordered = false
        return view
    }()
    
    private var isEmpty: Bool {
        return stringValue.isEmpty && attributedStringValue.string.isEmpty
    }
    
    @objc private func handleClearAction() {
        self.stringValue = ""
        textFieldDelegate?.acrTextFieldDidSelectClear(self)
        updateClearButton()
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        updateClearButton()
    }
    
    override var attributedStringValue: NSAttributedString {
        didSet {
            updateClearButton()
        }
    }
    
    override var stringValue: String {
        didSet {
            updateClearButton()
        }
    }
    
    override var doubleValue: Double {
        didSet {
            updateClearButton()
        }
    }
    
    private func setupTrackingArea() {
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.layer?.backgroundColor = config.highlightedColor.cgColor
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.layer?.backgroundColor = config.backgroundColor.cgColor
    }
    
    private func updateClearButton() {
        clearButton.isHidden = isEmpty
    }
    
    private var wantsClearButton: Bool {
        return config.wantsClearButton || (textFieldMode == .dateTime)
    }
    
    private enum Mode {
        case text
        case dateTime
        case number
    }
}

 class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    private var rightPadding: CGFloat = 0
    private var leftPadding: CGFloat = 0
    private var yPadding: CGFloat = 0
    private var focusRingCornerRadius: CGFloat = 0
    private var borderWidth: CGFloat = 0.1
    private var borderColor: NSColor = .black
    private var wantsClearButton: Bool = false
    private var isNumericField: Bool = false

    func setupSpacing(rightPadding: CGFloat = 0, leftPadding: CGFloat = 0, yPadding: CGFloat = 0, focusRingCornerRadius: CGFloat = 0, borderWidth: CGFloat = 0.1, borderColor: NSColor = .black, wantsClearButton: Bool, isNumericField: Bool) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.yPadding = yPadding
        self.focusRingCornerRadius = focusRingCornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.wantsClearButton = wantsClearButton
        self.isNumericField = isNumericField
    }

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight
        titleRect.origin.x += leftPadding
        // 16px is the image size(clear button)
        titleRect.size.width -= rightPadding + leftPadding + (wantsClearButton ? 16 : 0)
        return titleRect
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        controlView.layer?.borderWidth = borderWidth
        controlView.layer?.borderColor = borderColor.cgColor
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        controlView.layer?.cornerRadius = focusRingCornerRadius
        controlView.layer?.borderWidth = borderWidth
        controlView.layer?.borderColor = borderColor.cgColor
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        let path = NSBezierPath()
        if isNumericField {
            path.move( to: CGPoint(x: cellFrame.midX, y: cellFrame.minY ))
            path.line(to: CGPoint(x: cellFrame.maxX, y: cellFrame.minY ))
            path.line(to: CGPoint(x: cellFrame.maxX, y: cellFrame.maxY ))
            path.line(to: CGPoint(x: cellFrame.minX + focusRingCornerRadius, y: cellFrame.maxY ))
            path.curve(to: CGPoint(x: cellFrame.minX, y: cellFrame.maxY - focusRingCornerRadius ), controlPoint1: CGPoint(x: cellFrame.minX + focusRingCornerRadius, y: cellFrame.maxY ), controlPoint2: CGPoint(x: cellFrame.minX, y: cellFrame.maxY ))
            path.line(to: CGPoint(x: cellFrame.minX, y: cellFrame.minY + focusRingCornerRadius))
            path.curve(to: CGPoint(x: cellFrame.minX + focusRingCornerRadius, y: cellFrame.minY), controlPoint1: CGPoint(x: cellFrame.minX, y: cellFrame.minY + focusRingCornerRadius), controlPoint2: CGPoint(x: cellFrame.minX, y: cellFrame.minY ))
            path.line(to: CGPoint(x: cellFrame.midX, y: cellFrame.minY ))
        } else {
            path.appendRoundedRect(cellFrame, xRadius: focusRingCornerRadius, yRadius: focusRingCornerRadius)
        }
        path.fill()
    }
 }
