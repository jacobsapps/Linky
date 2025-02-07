//
//  SwiftUIViewController.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import SwiftUI

class SwiftUIViewController<Content: View>: UIViewController {
    
    public var swiftUIView: Content?

    public convenience init(with view: Content) {
        self.init(nibName: nil, bundle: nil)
        self.swiftUIView = view
    }
    
    override public init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        guard let swiftUIView = swiftUIView else { return }
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        view.pin(subview: hostingController.view)
    }
}

private extension UIView {
    
    func pin(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
