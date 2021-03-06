@testable import AdaptiveCards
import AdaptiveCards_bridge
import XCTest

class ActionOpenURLRendererTests: XCTestCase {
    private var hostConfig: FakeHostConfig!
    private var actionOpenURL: FakeOpenURLAction!
    private var acrView: ACRView!
    private var delegate: FakeACRViewOpenURLDelegate!
    private var actionOpenURLRenderer: ActionOpenURLRenderer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        hostConfig = .make()
        actionOpenURL = .make()
        delegate = FakeACRViewOpenURLDelegate()
        acrView = ACRView(style: .default, hostConfig: hostConfig, renderConfig: .default)
        actionOpenURLRenderer = ActionOpenURLRenderer()
    }
    
    func testRendersNormalButton() {
        let button = renderButton()
        XCTAssertFalse(button.showsChevron)
    }
    
    func testSetsTitle() {
        actionOpenURL = .make(title: "Hello world!")
        let button = renderButton()
        XCTAssertEqual(button.title, "Hello world!")
    }
    
    func testSetsTargets() {
        actionOpenURL = .make(url: "www.google.com")
        let button = renderButton()
        guard let target = acrView.targets.first as? ActionOpenURLTarget else { return XCTFail() }
        XCTAssertEqual(acrView.targets.count, 1)
        XCTAssertEqual(button.target as! ActionOpenURLTarget, target)
    }
    
    func testViewCallsDelegateAction() {
        acrView.delegate = delegate
        acrView.handleOpenURLAction(actionView: NSButton(), urlString: "www.google.com")
        XCTAssertEqual(delegate.calledURL, "www.google.com")
    }
    
    private func renderButton() -> ACRButton {
        let view = actionOpenURLRenderer.render(action: actionOpenURL, with: hostConfig, style: .default, rootView: acrView, parentView: NSView(), inputs: [], config: .default)
        
        XCTAssertTrue(view is ACRButton)
        guard let button = view as? ACRButton else { fatalError() }
        return button
    }
}

private class FakeACRViewOpenURLDelegate: ACRViewDelegate {
    var calledURL: String?
    func acrView(_ view: ACRView, didSelectOpenURL url: String, actionView: NSView) {
        calledURL = url
    }
    
    func acrView(_ view: ACRView, didSubmitUserResponses dict: [String : Any], actionView: NSView) { }
    func acrView(_ view: ACRView, didUpdateBoundsFrom oldValue: NSRect, to newValue: NSRect) { }
    func acrView(_ view: ACRView, didShowCardWith actionView: NSView, previousHeight: CGFloat, newHeight: CGFloat) { }
}
