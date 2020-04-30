# ScrollingContainer

- Helps you easily create forms and add scrolling capability to your view controller
- Handles keyboard management out of the box so that you can easily add text fields to your scroll view

||||
|---|---|---|
||||

Usage:

- Create a subclass of `ScrollingContainer`
- Add the scrollable content to the `contentView`

Example:

    import UIKit
    import ScrollingContainer

    class ViewController: ScrollingContainer {
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }

       override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .darkGray
        
            let label: UILabel = UILabel()
            label.text = "Address Form"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
            label.textColor = .white
            
            let hStack1: UIStackView = UIStackView(arrangedSubviews: [
                textField(text: "First Name"), textField(text: "Last Name")
            ])
            hStack1.axis = .horizontal
            hStack1.alignment = .bottom
            hStack1.distribution = .fillEqually
            hStack1.spacing = 8
        
            let hStack2: UIStackView = UIStackView(arrangedSubviews: [
                textField(text: "City"), textField(text: "PIN code")
            ])
            hStack2.axis = .horizontal
            hStack2.alignment = .bottom
            hStack2.distribution = .fillEqually
            hStack2.spacing = 8
        
            let vStack: UIStackView = UIStackView(arrangedSubviews:
                [
                spacer(height: 40),
                label,
                spacer(height: 20),
                hStack1,
                textField(text: "Apartment number"),
                textField(text: "Address Line 1"),
                textField(text: "Address Line 2"),
                hStack2,
                textField(text: "State"),
                textField(text: "Country"),
                textField(text: "Phone number")
                    ]
            )
            vStack.axis = .vertical
            vStack.spacing = 16
            
            contentView.addSubview(vStack)
            vStack.translatesAutoresizingMaskIntoConstraints = false
            
            [vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
                ].forEach { $0.isActive = true
            }
        }
        
        private func textField(text: String = "Your text here") -> UITextField {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textColor = .white
            textField.text = text
            textField.placeholder = text
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            textField.backgroundColor = .darkGray
            return textField
        }
        
        private func spacer(height: CGFloat) -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            return view
        }
    }


