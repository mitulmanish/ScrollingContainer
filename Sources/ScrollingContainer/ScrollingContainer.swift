import UIKit

open class ScrollingContainer: UIViewController {
        
    public let contentView: UIView
    private let keyboardLayoutGuide: KeyboardLayoutGuide
    
    public init() {
        contentView = UIView()
        keyboardLayoutGuide = KeyboardLayoutGuide()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: .none, bundle: .none)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let scrollViewContainer = UIView()
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollViewContainer)
        view.addLayoutGuide(keyboardLayoutGuide)
        
        let scrollViewBottomAnchor = scrollViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        scrollViewBottomAnchor.priority = UILayoutPriority.required - 1
        
        [scrollViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        scrollViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        scrollViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollViewBottomAnchor
        ].forEach { $0.isActive = true }
        
        scrollViewContainer.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor).isActive = true
        
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        [scrollView.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: scrollViewContainer.trailingAnchor),
        scrollView.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: scrollViewContainer.bottomAnchor)]
            .forEach { $0.isActive = true }
        
        scrollView.addSubview(contentView)
        [contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ].forEach { $0.isActive = true }
    }
}

 private final class KeyboardLayoutGuide: UILayoutGuide, UILayoutSupport {

     public var length: CGFloat {
         layoutFrame.height
     }

     public override var owningView: UIView? {
         didSet {
             owningView?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
             owningView?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
             owningView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
             heightConstraint = heightAnchor.constraint(equalToConstant: 0)
             heightConstraint?.isActive = true
         }
     }

     private var heightConstraint: NSLayoutConstraint?
    
     override init() {
         super.init()
        [
        (#selector(keyboardWillShow(_:)),UIResponder.keyboardWillShowNotification),
        (#selector(keyboardDidShow(_:)), UIResponder.keyboardDidShowNotification),
        (#selector(keyboardWillHide(_:), UIResponder.keyboardWillHideNotification),
        (#selector(keyboardDidHide(_:)), UIResponder.keyboardDidHideNotification)
        ].forEach { selector, notificationName in
            self.addObserver(selector: selector, name: notificationName)
        }
     }

     required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func addObserver(
        selector: Selector,
        name: NSNotification.Name) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: name,
            object: nil
        )
    }

     @objc private func keyboardWillShow(_ notification: Notification) {
         let (duration, options) = notification.animationInfo
         owningView?.layoutIfNeeded()
         heightConstraint?.constant = notification.keyboardHeight
          UIView.animate(
             withDuration: duration,
              delay: 0.0,
              options: options,
              animations: {
                  self.owningView?.layoutIfNeeded()
              }
          )
     }

     @objc private func keyboardDidShow(_ notification: Notification) {
        heightConstraint?.constant = notification.keyboardHeight
        owningView?.setNeedsLayout()
     }

     @objc private func keyboardWillHide(_ notification: Notification) {
        let (duration, options) = notification.animationInfo
         owningView?.layoutIfNeeded()
         heightConstraint?.constant = 0
         UIView.animate(
             withDuration: duration,
             delay: 0.0,
             options: options,
             animations: { [weak self] in
                 self?.owningView?.layoutIfNeeded()
             }
         )
     }

     @objc private func keyboardDidHide(_ notification: Notification) {
         heightConstraint?.constant = 0
         owningView?.setNeedsLayout()
     }
 }

private extension Notification {
    
    var animationInfo: (animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        let animationDuration = userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
        let rawAnimationCurve = userInfo![UIResponder.keyboardAnimationCurveUserInfoKey]
        return (
            animationDuration as! TimeInterval,
            UIView.AnimationOptions(rawValue: rawAnimationCurve as! UInt)
        )
    }
    
    var keyboardHeight: CGFloat {
        let keyboardEndFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        return keyboardEndFrame.height
    }
}
