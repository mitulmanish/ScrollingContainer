# ScrollingContainer

- Helps you easily create forms and add scrolling capability to your view controller
- Handles keyboard management out of the box so that you can easily add text fields to your scroll view

Usage:

- Create a subclass of `ScrollingContainer`
- Add the scrollable content to the `contentView`

Example:

    import ScrollingContainer
    
    class ScrollViewController: ScrollingContainer {
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .darkGray
            
            let labels1 = ["Bitcoin", "Litecoin", "EOS", "Tron", "0x", "NEM", "BSV"]
                .map { coin -> UIButton in
                let button = UIButton(type: .system)
                button.setTitleColor(.white, for: .normal)
                button.setTitle(coin, for: .normal)
                return button
            }
            
            let labels2 = ["Nano", "Bitcoin Gold"].map { coin -> UIButton in
                let button = UIButton(type: .system)
                button.setTitleColor(.white, for: .normal)
                button.setTitle(coin, for: .normal)
                return button
            }
            let vStack = UIStackView(arrangedSubviews: [
                textField()] + labels1 + [textField()] + labels2 + [textField()]
            )
            vStack.axis = .vertical
            vStack.spacing = 8
            
            contentView.addSubview(vStack)
            vStack.translatesAutoresizingMaskIntoConstraints = false
            
            [vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
                ].forEach { $0.isActive = true
            }
        }
        
        private func textField() -> UITextField {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textColor = .darkGray
            textField.placeholder = "Your text here"
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            textField.backgroundColor = .lightGray
            return textField
        }
    }
