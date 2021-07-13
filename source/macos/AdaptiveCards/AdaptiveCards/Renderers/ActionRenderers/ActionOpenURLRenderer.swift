import AdaptiveCards_bridge
import AppKit

class ActionOpenURLRenderer: BaseActionElementRendererProtocol {
    static let shared = ActionOpenURLRenderer()
    
    func render(action: ACSBaseActionElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: ACRView, parentView: NSView, targetHandlerDelegate: TargetHandlerDelegate, inputs: [BaseInputHandler], config: RenderConfig) -> NSView {
        guard let openURLAction = action as? ACSOpenUrlAction else {
            logError("Element is not of type ACSOpenUrlAction")
            return NSView()
        }
        
        let button: ACRButton
        let buttonStyle = ActionStyle(rawValue: openURLAction.getStyle() ?? "") ?? .default
        if let iconUrl = openURLAction.getIconUrl(), !iconUrl.isEmpty {
            button = ACRButton(wantsIcon: true, style: buttonStyle, buttonConfig: config.buttonConfig)
            rootView.registerImageHandlingView(button, for: iconUrl)
        } else {
            button = ACRButton(wantsIcon: false, style: buttonStyle, buttonConfig: config.buttonConfig)
        }
        button.title = openURLAction.getTitle() ?? ""
        
        let target = ActionOpenURLTarget(element: openURLAction, delegate: targetHandlerDelegate)
        target.configureAction(for: button)
        rootView.addTarget(target)
        
        return button
    }
}
