import AdaptiveCards_bridge
import AppKit

class ColumnRenderer: BaseCardElementRendererProtocol {
    static let shared = ColumnRenderer()
    
    func render(element: ACSBaseCardElement, with hostConfig: ACSHostConfig, style: ACSContainerStyle, rootView: NSView, parentView: NSView, inputs: [BaseInputHandler]) -> NSView {
        guard let column = element as? ACSColumn else {
            logError("Element is not of type ACSColumn")
            return NSView()
        }
        
        let columnView = ACRColumnView(style: column.getStyle(), parentStyle: style, hostConfig: hostConfig, superview: parentView)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        columnView.setWidth(ColumnWidth(columnWidth: column.getWidth(), pixelWidth: column.getPixelWidth()))
        
        var topSpacingView: NSView?
        if column.getVerticalContentAlignment() == .center || column.getVerticalContentAlignment() == .bottom {
            let view = NSView()
            columnView.addArrangedSubview(view)
            topSpacingView = view
        }
        
        for (index, item) in column.getItems().enumerated() {
            let renderer = RendererManager.shared.renderer(for: item.getType())
            let view = renderer.render(element: item, with: hostConfig, style: style, rootView: rootView, parentView: columnView, inputs: [])
            columnView.configureColumnProperties(for: view)
            let viewWithInheritedProperties = BaseCardElementRenderer.shared.updateView(view: view, element: item, style: style, hostConfig: hostConfig, isfirstElement: index == 0)
            columnView.addArrangedSubview(viewWithInheritedProperties)
        }
        
        if column.getVerticalContentAlignment() == .center, let topView = topSpacingView {
            let view = NSView()
            view.translatesAutoresizingMaskIntoConstraints = false
            topView.translatesAutoresizingMaskIntoConstraints = false
            columnView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        }
        
        if let height = column.getMinHeight(), let heightPt = CGFloat(exactly: height), heightPt > 0 {
            columnView.heightAnchor.constraint(greaterThanOrEqualToConstant: heightPt).isActive = true
        }
        
//        if let selectAction = column.getSelectAction(), let rootView = rootView as? ACRView {
//            var target: TargetHandler?
//            switch selectAction.getType() {
//            case .openUrl:
//                guard let openURLAction = selectAction as? ACSOpenUrlAction else { break }
//                target = ActionOpenURLTarget(element: openURLAction, delegate: rootView)
//
//            case .submit:
//                guard let submitAction = selectAction as? ACSSubmitAction else { break }
//                target = ActionSubmitTarget(element: submitAction, delegate: rootView)
//
//            default:
//                break
//            }
//
//            if let actionTarget = target {
//                columnView.target = actionTarget
//                rootView.addTarget(actionTarget)
//                print("CV: ", columnView.hash, "CV Name:", columnView.className, "TARGET: ", actionTarget.hash)
//            }
//        }
        
        columnView.setupSelectAction(selectAction: column.getSelectAction(), rootView: rootView)
        
        return columnView
    }
}
