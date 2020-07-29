
import UIKit

// MARK: -

@objc
public protocol BACaptchaInputDelegate: class {
    func onCaptchaInputComplete(captchaInput: BACaptchaInput, didFinishInput captchaCode: String)
}

// MARK: -

@IBDesignable
open class BACaptchaInput: UIControl {
    
    /// Different display type for text fields.
    public enum DisplayType {
        case box
        case underlined
        case round
    }
    
    /// Different input type for OTP fields.
    public enum KeyboardType: Int {
        case numeric
        case alphabet
        case alphaNumeric
    }
    
    // 图片文件
    public enum SecureEntryDisplayType: String {
        case dot = "ic_dot"
        case star = "ic_star"
        case none = ""
    }
    
    // MARK: = Configurations
    
    /// Define the display type for OTP fields.
    open var fieldDisplayType: DisplayType = .underlined
    
    ///
    open var fieldInputType: KeyboardType = .numeric
    
    /// Define the font to be used to OTP field.
    @IBInspectable
    open var fieldFont: UIFont = UIFont.systemFont(ofSize: 20)
    
    /// For secure OTP entry set it to `true`.
    @IBInspectable
    open var isSecureEntry: Bool = false
    
    /// If set to `false`, the blinking cursor for OTP field will not be visible. Defaults to `true`.
    @IBInspectable
    open var requireCursor: Bool = true
    
    /// For setting cursor color, if `requireCursor` is set to true.
    @IBInspectable
    open var cursorColor: UIColor = .white
    
    /// 输入框间距
    @IBInspectable
    open var separatorSpace: CGFloat = 10
    
    /// 边框宽度
    @IBInspectable
    open var borderWidth: CGFloat = 2
    
    /// Set this value if a border color is needed when a text is not enetered in the OTP field.
    @IBInspectable
    open var emptyFieldBorderColor: UIColor = .lightGray
    
    /// Set this value if a border color is needed when a text is enetered in the OTP field.
    @IBInspectable
    open var enteredFieldBorderColor: UIColor = UIColor(red: 225/255, green: 73/255, blue: 73/255, alpha: 1)
    
    /// 安全输入的替代显示图标
    open var secureEntrySymbol: SecureEntryDisplayType = .none
    
    /// 安全输入的替代显示图标颜色
    @IBInspectable
    open var secureEntrySymbolColor: UIColor = UIColor(red: 236/255, green: 43/255, blue: 78/255, alpha: 1.0)
    
    /// Text Color for text field
    @IBInspectable
    open var textColor: UIColor = UIColor(red: 225/255, green: 73/255, blue: 73/255, alpha: 1)
    
    /// 加载则获取第一响应者
    @IBInspectable
    open var isTextfieldBecomFirstResponder = true
    
	@IBInspectable open var fieldsCount: Int = 4 {
		didSet {
			setupUI()
		}
	}

    // MARK: =
    
	@IBOutlet open weak var delegate: BACaptchaInputDelegate?

	var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
        stackView.alignment = .fill
		return stackView
	}()

	fileprivate var items: [BACaptchaInputTextField] = []
	open var code: String {
		get {
			let items = stackView.arrangedSubviews.map({$0 as! BACaptchaInputTextField})
			let values = items.map({$0.text ?? ""})
			return values.joined()
		}
		set {
			let array = newValue.map(String.init)
			for i in 0..<fieldsCount {
				let item = stackView.arrangedSubviews[i] as! BACaptchaInputTextField
				item.text = i < array.count ? array[i] : ""
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

    // 初始化UI
	fileprivate func setupUI() {
        // stackView 设置
        stackView.spacing = separatorSpace
        
        //
		stackView.frame = self.bounds
		if stackView.superview == nil {
			addSubview(stackView)
		}
		stackView.arrangedSubviews.forEach{($0.removeFromSuperview())}

		for index in 0..<fieldsCount {
			let itemView = createInputTextField(forIndex: index)
			itemView.delegate = self

			stackView.addArrangedSubview(itemView)
		}
	}
    
    fileprivate func indexForTag(forIndex index: Int) -> Int {
        return index + 1
    }

	// 获取单个
    fileprivate func createInputTextField(forIndex index: Int) -> BACaptchaInputTextField {
        
        let hasOddNumberOfFields = (fieldsCount % 2 == 1)
        let txtWidth = (self.frame.width / CGFloat(fieldsCount)) - separatorSpace
        
        var fieldSize: CGFloat = 100
        
        if fieldSize > self.frame.height {
            fieldSize = self.frame.height
        }
        if txtWidth < fieldSize {
            fieldSize = txtWidth
        }
        var fieldFrame = CGRect(x: 0, y: 0, width: fieldSize, height: fieldSize)
        
//         If odd, then center of self will be center of middle field. If false, then center of self will be center of space between 2 middle fields.
        if hasOddNumberOfFields {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) * (fieldSize + separatorSpace) + fieldSize / 2)
        } else {
            // Calculate from middle each fields x and y values so as to align the entire view in center
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) * fieldSize + CGFloat(fieldsCount / 2 - index - 1) * separatorSpace + separatorSpace / 2)
        }
        
        fieldFrame.origin.y = (bounds.size.height - fieldSize) / 2
        
        let textField = BACaptchaInputTextField(frame: fieldFrame)
        textField.delegate = self
        textField.tag = indexForTag(forIndex: index)
        textField.font = fieldFont
        
        switch fieldInputType {
        case .numeric:
            textField.keyboardType = .numberPad
        case .alphabet:
            textField.keyboardType = .alphabet
        case .alphaNumeric:
            textField.keyboardType = .namePhonePad
        }
        
        if requireCursor {
            textField.tintColor = cursorColor
        } else {
            textField.tintColor = UIColor.clear
        }
        
        textField.initalizeUI(forFieldType: fieldDisplayType, normalBorderColor: emptyFieldBorderColor, highlightBorderColor: enteredFieldBorderColor)
        
        return textField
    }

	@discardableResult
	override open func becomeFirstResponder() -> Bool {
		let items = stackView.arrangedSubviews
			.map({$0 as! BACaptchaInputTextField})
		return (items.filter({($0.text ?? "").isEmpty}).first ?? items.last)!.becomeFirstResponder()
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
    
    private func deleteText(in textField: UITextField) {
        if let lbl = self.viewWithTag(textField.tag + fieldsCount) as? UILabel {
            lbl.text = ""
        }
        
        textField.layer.borderColor = emptyFieldBorderColor.cgColor
        
        textField.becomeFirstResponder()
    }
    
    // For clear all entered OTP
    public func clear() {
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            
            let textField = viewWithTag(index + 1) as? BACaptchaInputTextField
            
            self.deleteText(in: textField!)
        }
    }
    
    fileprivate func check() {
        let captchaCode = code
        if (captchaCode.count == fieldsCount) {
            delegate?.onCaptchaInputComplete(captchaInput: self, didFinishInput: captchaCode)
        }
    }
}

// MARK: - UITextFieldDelegate & BACaptchaTextFieldDelegate

extension BACaptchaInput: UITextFieldDelegate {
    
    

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.hasSuffix("\n") {
            return false;
        }

		if string == "" { //is backspace
			return true
		}
        
        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Check since only alphabet keyboard is not available in iOS
        if !replacedText.isEmpty && fieldInputType == .alphabet && replacedText.rangeOfCharacter(from: .letters) == nil {
            return false
        }
        
        if replacedText.count >= 1 {
   
            if isSecureEntry {
                
                let fullString = NSMutableAttributedString(string: "")
                let imageAttachment = NSTextAttachment()
                if secureEntrySymbol != .none {
                    textField.text = "M"
                    textField.textColor = textColor
                } else {
                    textField.text = string
                    textField.textColor = textColor
                }
                let origImage = UIImage(named: secureEntrySymbol.rawValue)
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                if #available(iOS 13.0, *) {
                    imageAttachment.image = tintedImage
                } else {
                    imageAttachment.image = tintedImage?.imageWithColor(color: .red)
                }
                imageAttachment.bounds = CGRect(x: 0, y: 0, width: (textField.text?.widthOfString(usingFont: fieldFont) ?? 0), height: (textField.text?.widthOfString(usingFont: fieldFont) ?? 0))
                let imageString = NSAttributedString(attachment: imageAttachment)
                fullString.append(imageString)
                if let lbl = self.viewWithTag(textField.tag + fieldsCount) as? UILabel, secureEntrySymbol != .none {
                    
                    lbl.textAlignment = .center
                    if secureEntrySymbol != .none {
                        lbl.attributedText = fullString
                    }
                    if #available(iOS 13.0, *) {
                        lbl.textColor = secureEntrySymbolColor
                    }
                }
            } else {
                textField.text = string
                textField.textColor = textColor
            }
            
            if let txt = viewWithTag(textField.tag) as? BACaptchaInputTextField, fieldDisplayType == .underlined {
                
//                usingSpringWithDamping：弹簧动画的阻尼值，也就是相当于摩擦力的大小，该属性的值从0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大道一定程度，会出现弹不动的情况。
//                initialSpringVelocity：弹簧动画的速率，或者说是动力。值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里需要注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果
                UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                    txt.borderView?.backgroundColor = self.enteredFieldBorderColor
                }, completion: nil)
                
            }
            
            let nextOTPField = viewWithTag(textField.tag + 1)
            
            if let nextOTPField = nextOTPField {
                nextOTPField.becomeFirstResponder()
            } else {
//                textField.resignFirstResponder()
                
                // 检查是否已填充满
                check()
            }
        } else {
            
            let currentText = textField.text ?? ""
            
            if textField.tag > 1 && currentText.isEmpty {
                
                if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                    deleteText(in: prevOTPField)
                }
            } else {
                deleteText(in: textField)
                
                if textField.tag > 1 {
                    if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                        prevOTPField.becomeFirstResponder()
                    }
                }
            }
        }
        
        return false
	}
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension UIImage {
    
    func imageWithColor(color:UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: rect, mask: self.cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let imageFromCurrentContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: imageFromCurrentContext!.cgImage!, scale: 1.0, orientation:.downMirrored)
    }
}
