
import UIKit

class BACaptchaInputTextField : UITextField {

    var borderView: UIView?
    var borderWidth: CGFloat = 2
    
    var shadowSize: CGFloat = 1
    var shadowRadius: CGFloat = 4
    
    var cornerRadius: CGFloat = 0
    
    var shapeLayer: CAShapeLayer!
    
    var displayType: BACaptchaInput.DisplayType?
    
    var normalBorderColor: UIColor?
    var highlightBorderColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initalizeUI(forFieldType type: BACaptchaInput.DisplayType, normalBorderColor: UIColor, highlightBorderColor: UIColor) {
        // MARK: = 参数录入
        self.displayType = type
        
        self.normalBorderColor = normalBorderColor
        self.highlightBorderColor = highlightBorderColor
        
        // MARK: =
        
        if #available(iOS 12.0, *) {
            self.textContentType = .oneTimeCode
        }
        
        switch type {
            
        case .round:
            layer.cornerRadius = bounds.size.width / 2
        case .box:
            layer.cornerRadius = 0
        default:
            if borderView == nil {
                let borderViews: [UIView] = addBorders(edges: [.bottom], color: normalBorderColor, thickness: borderWidth)
                
                borderView = borderViews.first
            } else {
                borderView?.backgroundColor = normalBorderColor
            }
        }
        
        autocorrectionType = .no
        textAlignment = .center
    }
    
    override func deleteBackward() {
        self.borderView?.backgroundColor = self.normalBorderColor
        
        if self.text?.count == 0 {
            findPrevious()
        } else {
            // 当前输入框非零，则清空当前输入框，且将光标保持在当前
            self.text = ""
        }
    }
    
    /// 找到上一个响应者，默认规则是：连续view tag
    func findPrevious() {
        if let nextField = self.superview?.viewWithTag(self.tag - 1) as? UITextField {
            nextField.text = ""
            nextField.becomeFirstResponder()
        } else {
            // 什么都不做，保持光标在当前 输入框
        }
    }
}

public extension UIView {
    
    /**
     
     // Usage:
     view.addBorder(edges: [.all]) // All with default arguments
     view.addBorder(edges: [.top], color: .green) // Just Top, green, default thickness
     view.addBorder(edges: [.left, .right, .bottom], color: .red, thickness: 3) // All except Top, red, thickness 3
     
     */
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }

}
