
import UIKit

public protocol BACaptchaTextFieldDelegate: class {
	func deleteBackward(sender: BACaptchaTextField, prevValue: String?)
}

open class BACaptchaTextField: UITextField {
    
    weak open var deleteDelegate: BACaptchaTextFieldDelegate?

    override open func deleteBackward() {
		let prevValue = text
		super.deleteBackward()
        deleteDelegate?.deleteBackward(sender: self, prevValue: prevValue)
    }
}
