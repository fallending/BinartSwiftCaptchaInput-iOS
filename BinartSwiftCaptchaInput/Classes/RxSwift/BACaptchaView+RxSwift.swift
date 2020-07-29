import UIKit

#if canImport(RxCocoa)
import RxSwift
import RxCocoa

public extension Reactive where Base: BACaptchaInput {
    
    /// Reactive wrapper for `code` property.
    var code: ControlProperty<String> {
        return controlProperty(editingEvents: [.allEditingEvents, .valueChanged],
                               getter: { codeView in
                                codeView.code
        }, setter: { codeView, value in
            codeView.code = value
        })
    }
}
#endif
