
import UIKit

@objc
public protocol BACaptchaInputDelegate: class {
	func codeView(sender: BACaptchaInput, didFinishInput code: String) -> Bool
}

@IBDesignable
open class BACaptchaInput: UIControl {
	@IBInspectable open var length: Int = 4 {
		didSet {
			setupUI()
		}
	}

	@IBOutlet open weak var delegate: BACaptchaInputDelegate?

	var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return stackView
	}()

	fileprivate var items: [BACaptchaInputItem] = []
	open var code: String {
		get {
			let items = stackView.arrangedSubviews.map({$0 as! BACaptchaInputItem})
			let values = items.map({$0.textField.text ?? ""})
			return values.joined()
		}
		set {
			let array = newValue.map(String.init)
			for i in 0..<length {
				let item = stackView.arrangedSubviews[i] as! BACaptchaInputItem
				item.textField.text = i < array.count ? array[i] : ""
			}
			if !stackView.arrangedSubviews.compactMap({$0 as? UITextField}).filter({$0.isFirstResponder}).isEmpty {
				self.becomeFirstResponder()
			}
		}
	}

	override open func awakeFromNib() {
		super.awakeFromNib()
		setupUI()

		let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
		addGestureRecognizer(tap)
	}

	fileprivate func setupUI() {
		stackView.frame = self.bounds
		if stackView.superview == nil {
			addSubview(stackView)
		}
		stackView.arrangedSubviews.forEach{($0.removeFromSuperview())}

		for i in 0..<length {
			let itemView = generateItem()
			itemView.textField.deleteDelegate = self
			itemView.textField.delegate = self
			itemView.tag = i
			itemView.textField.tag = i
			stackView.addArrangedSubview(itemView)
		}
	}

	open func generateItem() -> BACaptchaInputItem {
		let type = BACaptchaInputItem.self
		let typeStr = type.description().components(separatedBy: ".").last ?? ""
		let bundle = Bundle(for: type)
		return bundle
			.loadNibNamed(typeStr,
						  owner: nil,
						  options: nil)?
			.last as! BACaptchaInputItem
	}

	@discardableResult
	override open func becomeFirstResponder() -> Bool {
		let items = stackView.arrangedSubviews
			.map({$0 as! BACaptchaInputItem})
		return (items.filter({($0.textField.text ?? "").isEmpty}).first ?? items.last)!.becomeFirstResponder()
	}

	@discardableResult
	override open func resignFirstResponder() -> Bool {
		stackView.arrangedSubviews.forEach({$0.resignFirstResponder()})
		return true
	}

	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupUI()
	}
}

extension BACaptchaInput: UITextFieldDelegate, BACaptchaTextFieldDelegate {

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		if string == "" { //is backspace
			return true
		}

		if !textField.hasText {
			let index = textField.tag
			let item = stackView.arrangedSubviews[index] as! BACaptchaInputItem
			item.textField.text = string
			sendActions(for: .valueChanged)
			if index == length - 1 { //is last textfield
				if (delegate?.codeView(sender: self, didFinishInput: self.code) ?? false) {
					textField.resignFirstResponder()
				}
				return false
			}

			_ = stackView.arrangedSubviews[index + 1].becomeFirstResponder()
		}

		return false
	}

	public func deleteBackward(sender: BACaptchaTextField, prevValue: String?) {
		for i in 1..<length {
			let itemView = stackView.arrangedSubviews[i] as! BACaptchaInputItem

			guard itemView.textField.isFirstResponder, (prevValue?.isEmpty ?? true) else {
				continue
			}

			let prevItem = stackView.arrangedSubviews[i-1] as! BACaptchaInputItem
			if itemView.textField.text?.isEmpty ?? true {
				prevItem.textField.text = ""
				_ = prevItem.becomeFirstResponder()
			}
		}
		sendActions(for: .valueChanged)
	}
}
