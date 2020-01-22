//
//  Extentions.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 21/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//

import Foundation

import UIKit

class Extensions: NSObject {}

typealias EmptyCallBackClosure = () -> Void
typealias ButtonCallBackClosure = (_ sender : UIButton) -> Void
typealias GestureCallBackClosure = (_ sender : UITapGestureRecognizer) -> Void


struct Keys {
    static fileprivate var closure: UInt8 = 0
    static fileprivate var control: UInt8 = 0
    static fileprivate var footer: UInt8 = 0
    static fileprivate var buttonClosure : UInt8 = 0
    static fileprivate var buttonNodeClosure : UInt8 = 0
    static fileprivate var AssociatedObjectKey : UInt8 = 0
    static fileprivate var LabelRxValueKey : UInt8 = 0
    static fileprivate var LabelValueKey : UInt8 = 0
    
    static fileprivate var ButtonValueKey : UInt8 = 0
    static fileprivate var TextSelectedDateKey : UInt8 = 0
    static fileprivate var TextValueChangeKey : UInt8 = 0
    static fileprivate var TapOnTextKey : UInt8 = 0
    
}

enum PopUpAnimation {
    case left
    case right
    case top
    case bottom
    case fade
    case none
}

// MARK: Extension
extension String{
    
    // retun localised string
    var localisedString : String{
        return NSLocalizedString(self, comment: "")
    }
    
    var decodeEmoji: String
    {
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr
        {
            return str as String
        }
        return self
    }
    // message to the server
    var encodeEmoji: String
    {
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        {
            return encodeStr as String
        }
        return self
    }
    
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func lines(font : UIFont, width : CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude);
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil);
        return Int(boundingBox.height/font.lineHeight);
    }
    
    func stringByStrippingHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func isEmpty() -> Bool {
        let trimmed = self.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    func boolValue() -> Bool {
        if self.isEmpty(){
            return false
        }
        switch self {
        case "True", "true", "yes", "1", "Y", "y":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    func integerValue() -> Int{
        if let doubleValue = Double(self) {
            return doubleValue.isInt ? Int(ceil(doubleValue)) : 0
        }
        return 0
    }
    
    func doubleValue() -> Double{
        if let doubleValue = Double(self) {
            return doubleValue
        }
        return 0.0
    }
    
    func floatValues() -> Float{
        let stringValue = self
        
        if let doubleValue = Float(stringValue.replacingOccurrences(of: ",", with: "")) {
            let divisor = pow(10.0, Float(2))
            return (doubleValue * divisor).rounded() / divisor
        }
        return 0.0
    }
    
    func poundValues() -> Float{
        if let doubleValue = Float(self) {
            return doubleValue
        }
        return 0.0
    }
    
    public func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]
        
        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }
        
        return false
    }
    
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        if ext.isEmpty {
            return nil
        }
        
        return ext
    }
    
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }
    
    //    var htmlAttributedString: NSAttributedString? {
    //        do {
    //            return try NSAttributedString(data: (self.data(using: String.Encoding.unicode))!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    //        } catch {
    //            print(error)
    //            return nil
    //        }
    //    }
    //    var htmlPlainString: String {
    //        return htmlAttributedString?.string ?? ""
    //    }
    
    func rightJustified(width: Int, truncate: Bool = false) -> String {
        guard width > count else {
            return truncate ? String(suffix(width)) : self
        }
        return String(repeating: " ", count: width - count) + self
    }
    
    func leftJustified(width: Int, truncate: Bool = false) -> String {
        guard width > count else {
            return truncate ? String(prefix(width)) : self
        }
        return self + String(repeating: " ", count: width - count)
    }
    
    func isNumberOnly() -> Bool{
        if self.isEmpty
        {
            return !self.isEmpty
        }
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return self == numberFiltered
    }
    
    func isStringOnly(spaceAllow:Bool) -> Bool
    {
        if self.isEmpty
        {
            return !self.isEmpty
        }
        do
        {
            let space = (spaceAllow == true) ? " " : ""
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z\(space)].*", options: [])
            if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
            {
                return false
            }
            else
            {
                return true
            }
        }
        catch
        {
            return false
        }
    }
    
    func isStrongPassword() -> Bool
    {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false
        
        if self.count  >= 8
        {
            for char in self.unicodeScalars
            {
                if !lowerCaseLetter
                {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter
                {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit
                {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter
                {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if specialCharacter || (digit && lowerCaseLetter && upperCaseLetter)
            {
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
    
    func date(format: String, timeZone : TimeZone = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func UTCdate(format: String, timeZone : TimeZone = TimeZone(abbreviation: "UTC") ?? .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func convertDateString(currentFormat : String, currentTimeZone : TimeZone  = .current ,extepectedFormat : String, expectedTimeZone : TimeZone = .current) -> String{
        return self.date(format: currentFormat, timeZone:  currentTimeZone)?.dateString(format: extepectedFormat,  timeZone :expectedTimeZone) ?? self
    }
    
    func currentTimeFromUTC(currentFormat : String,extepectedFormat : String) -> String{
        return self.convertDateString(currentFormat: currentFormat, currentTimeZone: TimeZone(abbreviation: "UTC") ?? .current, extepectedFormat: extepectedFormat) // expected default
    }
    
    func getAttributedTextWithLineOfHeight(_ height : CGFloat) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** Set Alignment Center ***
        paragraphStyle.alignment = .center
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Final Attributed String ***
        
        return attributedString
    }
    
    func isValidDecimal() -> Bool {
        let regex1 : String = "^\\d+(\\.\\d{1,2})?$"
        let test1 : NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex1)
        return test1.evaluate(with: self)
    }
    
    func findDateDiff(secondDate: String, currentForamt : String = "hh:mm a", expectedFormat : String = "hh:mm a") -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = currentForamt
        
        guard let time1 = timeformatter.date(from: self),
            let time2 = timeformatter.date(from: secondDate) else { return "" }
        
        //You can directly use from here if you have two dates
        
        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return time2.dateString(format: expectedFormat) ?? ""
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
}

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}



extension UINavigationController{
    
}

extension UITextView{
    //    static var localizedTexts:String? = nil;
    
    open override func awakeFromNib() {
        DynamicFontSize = true
    }
    
    var DynamicFontSize : Bool {
        set {
            if newValue{
                if let fonts = font{
                    font = fonts.scaleFont()
                    
                    // font = UIFont(name: (font!.fontName), size: (font?.pointSize)! * (UIScreen.main.bounds.size.width/320))
                }
            }
        }
        get {
            return false
        }
    }
    
    func removeExtraPedding(){
        self.textContainerInset = UIEdgeInsets.zero
        self.textContainer.lineFragmentPadding = 0
    }
    
}


extension UIButton{
    
    @IBInspectable var actualValue : String{
        get{
            return (objc_getAssociatedObject(self, &Keys.ButtonValueKey) as? String)!
        }
        set{
            objc_setAssociatedObject(self, &Keys.ButtonValueKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func awakeFromNib() {
        DynamicFontSize = true
        super.awakeFromNib()
    }
    
    var DynamicFontSize : Bool {
        set {
            if newValue{
                if newValue{
                    if let fonts = titleLabel?.font{
                        titleLabel?.font = fonts.scaleFont()
                    }
                }
            }
        }
        get {
            return false
        }
    }
    
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    @IBInspectable var isFloatingButton : Bool {
        set {
            if newValue{
                self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                self.layer.shadowOffset = CGSize(width : 0.0 , height : 2.0)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 0.0
                self.layer.masksToBounds = false
            }
        }
        get {
            return false
        }
    }
    
    @IBInspectable var normalBackground : UIColor { // for blended layer test
        set {
            self.setBackgroundColor(color: newValue, forState: .normal)
        }
        get {
            return self.backgroundColor!
        }
    }
    
    
    @IBInspectable var selectedBackground : UIColor { // for blended layer test
        set {
            self.setBackgroundColor(color: newValue, forState: .selected)
        }
        get {
            return self.backgroundColor!
        }
    }
    
    @IBInspectable var isSetWhiteBackground : Bool { // for blended layer test
        set {
            if newValue{
                titleLabel?.backgroundColor = UIColor.white
            }
        }
        get {
            return false
        }
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let attributes = [
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func callBackTargetForCollections(alongWith otherButtons : [UIButton?] , closure: @escaping ButtonCallBackClosure) {
        callBackTargetClosure = closure
        for (_,btn) in otherButtons.enumerated(){
            if let btn = btn{
                btn.addTarget(self, action: #selector(clickOnClosureButton(_:)), for: .touchUpInside)
            }
        }
    }
    
    func callBackTarget(closure: @escaping ButtonCallBackClosure) {
        callBackTargetClosure = closure
    }
    
    private var callBackTargetClosure: ButtonCallBackClosure? {
        get{
            return objc_getAssociatedObject(self, &Keys.buttonClosure) as? ButtonCallBackClosure
        }
        set{
            if let newValue = newValue{
                objc_setAssociatedObject(self, &Keys.buttonClosure, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                addTarget(self, action: #selector(clickOnClosureButton(_:)), for: .touchUpInside)
            }
        }
    }
    
    func invokeCallBackClosure(){
        if let callBack = callBackTargetClosure{
            callBack(self)
        }
    }
    
    @objc private func clickOnClosureButton(_ sender: UIButton) {
        if let callBack = callBackTargetClosure{
            callBack(sender)
        }
    }
}


extension UITapGestureRecognizer{
    func callBackTarget(closure: @escaping GestureCallBackClosure) {
        callBackTargetClosure = closure
    }
    
    func invokeCallBackClosure(){
        if let callBack = callBackTargetClosure{
            callBack(self)
        }
    }
    
    private var callBackTargetClosure: GestureCallBackClosure? {
        get{
            return objc_getAssociatedObject(self, &Keys.buttonClosure) as? GestureCallBackClosure
        }
        set{
            if let newValue = newValue{
                objc_setAssociatedObject(self, &Keys.buttonClosure, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                addTarget(self, action: #selector(clickOnClosureButton(_:)))
            }
        }
    }
    
    @objc private func clickOnClosureButton(_ sender: UITapGestureRecognizer) {
        if let callBack = callBackTargetClosure{
            callBack(sender)
        }
    }
}

extension UIStackView {
    
    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}

extension UIBarButtonItem {
    
}


extension UIImage{
    //    class func imageResize(_ img: UIImage, andResizeTo newSize: CGSize) -> UIImage {
    //        return img.imageScaled(toFit: newSize)
    //    }
    
    func makeCircularImage(size: CGSize, borderWidth width: CGFloat) -> UIImage {
        // make a CGRect with the image's size
        let circleRect = CGRect(origin: .zero, size: size)
        
        // begin the image context since we're not in a drawRect:
        // UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, UIScreen.main.scale)
        
        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width * 0.5)
        
        // clip to the circle
        circle.addClip()
        
        UIColor.white.set()
        circle.fill()
        
        // draw the image in the circleRect *AFTER* the context is clipped
        self.draw(in: circleRect)
        
        // create a border (for white background pictures)
        if width > 0 {
            circle.lineWidth = width
            UIColor.white.set()
            circle.stroke()
        }
        
        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext()
        
        return roundedImage ?? self
    }
    
    func imageResizeProportionally(withWidth expectedWidth: CGFloat) -> UIImage {
        let image = self
        //        let targetWidth: CGFloat = expectedWidth
        //        let scaleFactor: CGFloat = targetWidth / image.size.width
        //        let targetHeight: CGFloat = image.size.height * scaleFactor
        //        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        //        image.imageScaled(toFit: targetSize)
        return image
    }
    
    
    
    func imageResizeProportionally(withHeight expectedHeight: CGFloat) -> UIImage {
        //let targetHeight: CGFloat = expectedHeight
        let image = self
        //        let scaleFactor: CGFloat = expectedHeight / image.size.height
        //        let targetWidth: CGFloat = image.size.width * scaleFactor
        //        let targetSize = CGSize(width: targetWidth, height: expectedHeight)
        //        image =  image.imageScaled(toFit: targetSize)
        return image
    }
    
    func resizeImage(expectedHeight: CGFloat) -> UIImage {
        var image = self
        let scale = expectedHeight / image.size.height
        let newWidth = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width :newWidth, height : expectedHeight))
        
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: expectedHeight))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func resizeImageWithWidth(expectedWidth: CGFloat) -> UIImage {
        var image = self
        if image.size.width > expectedWidth
        {
            let scale = expectedWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: expectedWidth, height : newHeight))
            
            image.draw(in: CGRect(x: 0, y: 0, width: expectedWidth, height: newHeight))
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return image
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func resizeImageWithWidth(expectedWidth: CGFloat, expectedHeight: CGFloat) -> UIImage {
        var image = self
        
        UIGraphicsBeginImageContext(CGSize(width: expectedWidth, height : expectedHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: expectedWidth, height: expectedHeight))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func imageColorChange(With expecetedColor: UIColor) -> UIImage {
        var newImage: UIImage? = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, (newImage?.scale)!)
        expecetedColor.set()
        newImage?.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.size.width), height: CGFloat((newImage?.size.height)!)))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func image(from layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    func grayscaleImage() -> UIImage {
        let image = self
        // Create image rectangle with current image width/height
        let imageRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.width), height: CGFloat(image.size.height))
        // Grayscale color space
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceGray()
        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        
        let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        context?.draw(image.cgImage!, in: imageRect)
        
        // context.draw(in: image.cgImage, image: imageRect)
        // Create bitmap image info from pixel data in current context
        let imageRef: CGImage = context!.makeImage()!
        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef)
        // Release colorspace, context and bitmap information
        
        
        
        //  CGContextRelease(context!)
        // Return the new grayscale image
        return newImage
    }
    
}


extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
    
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float{
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}



extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension Array {
    
    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [G: [Element]] {
        var dictionary = [G: [Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var array: [Element]? = dictionary[key]
            
            if (array == nil) {
                array = [Element]()
            }
            
            array!.append(element)
            dictionary[key] = array!
        }
        
        return dictionary
    }
}

extension UIViewController
{
    
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: self.view)
    }
    
    @objc func topMostViewController() -> UIViewController
    {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController
        {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else
        {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next
                {
                    if subViewController is UIViewController
                    {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
}

extension UITabBarController
{
    override func topMostViewController() -> UIViewController
    {
        return self.selectedViewController!.topMostViewController()
    }
}

extension UINavigationController
{
    override func topMostViewController() -> UIViewController
    {
        return self.visibleViewController!.topMostViewController()
    }
}

extension NSMutableAttributedString {
    
    public func trimCharactersInSet(charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet )
        
        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }
        
        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
}

extension NSAttributedString {
    public func attributedStringByTrimmingCharacterSet(charSet: CharacterSet) -> NSAttributedString {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharactersInSet(charSet: charSet)
        return NSAttributedString(attributedString: modifiedString)
    }
}



extension UIResponder {
    var parentViewController: UIViewController? {
        return (self.next as? UIViewController) ?? self.next?.parentViewController
    }
}

//MARK: ---------------------------------------

extension FloatingPoint {
    var isInt: Bool {
        return floor(self) == self
    }
}

extension Int {
    var scaledFontSize : CGFloat {
        var width = UIScreen.main.bounds.width // portrait
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            width = UIScreen.main.bounds.size.height // landscap
        }
        return CGFloat(self) * (width / (iPAD ? 750 : 320)) // 750 and 320 is 1x value respective ipad and iphone
    }
}

extension CGFloat {
    var scaledFontSize : CGFloat {
        var width = UIScreen.main.bounds.width // portrait
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            width = UIScreen.main.bounds.size.height // landscap
        }
        return CGFloat(self) * (width / (iPAD ? 750 : 320))
    }
    
    var intergerValue : Int{
        return Int(self)
    }
}

extension UIFont {
    func scaleFont() -> UIFont {
        return UIFont.init(name: self.fontName, size: self.pointSize.scaledFontSize)!
    }
}


extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    func string(forKey key: Key) -> String{
        guard let value = self [key] else {
            return ""
        }
        var str = ""
        // var str = String.init(format: "%ld", value as! CVarArg)
        if let v = value as? NSString{
            str = v as String
        }else if let v = value as? NSNumber{
            str = v.stringValue
        }else if let v = value as? Double{
            str = String.init(format: "%ld", v);
        }else if let v = value as? Int{
            str = String.init(format: "%i", v);
        }
        else if value is NSNull{
            str = "";
        }
        else{
            str = ""
        }
        return str;
    }
    
    func bool(forKey key: Key) -> Bool{
        return self.string(forKey: key).boolValue()
    }
    
    func integer(forkey key : Key) -> Int{
        return self.string(forKey: key).integerValue()
    }
    
    func double(forkey key : Key) -> Double{
        return self.string(forKey: key).doubleValue()
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func jsonString() -> String {
        return json
    }
}

extension Array{
    var jsonString: String {
        let invalidJson = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            PRINT(error)
        }
    }
}

extension Date {
    func dateString(format: String, timeZone : TimeZone = .current) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.string(from: self)
        return date
    }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
}

extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
}

extension Notification.Name {
    static let newPostAdded = "AddPostObserver"
    static let appTimeout = Notification.Name("appTimeout")
    static let touchOnViewEvent = Notification.Name("UITouchEvent")
    public static let newNotificationArrived = Notification.Name(rawValue: "NewNotificationArrived")
    public static let changeUser = Notification.Name(rawValue: "NewNotificationArrived")
    public static let disableSelectedIndex = Notification.Name(rawValue: "ResetSelectedOrderIndex")
    static let appTillTimeOut = Notification.Name("TillTimeOut")
    public static let printerConnectDisconnectNotification = Notification.Name(rawValue: "printerConnectDisconnectNotifi")
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension Array where Element:UIButton{
    func callBackTargetForCollections(closure: @escaping ButtonCallBackClosure) {
        if self.count > 0{
            self[0].callBackTargetForCollections(alongWith: self, closure: closure)
        }
    }
}


extension UICollectionView{
    
    
    var refreshControlLower : UIRefreshControl?{
        get{
            return objc_getAssociatedObject(self, &Keys.control) as? UIRefreshControl
            
        }
        set{
            objc_setAssociatedObject(self, &Keys.control, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func enableRefreshControl(closure: @escaping EmptyCallBackClosure) {
        callBackOfRefreshControl = closure
    }
    
    private var callBackOfRefreshControl: EmptyCallBackClosure? {
        get{
            return objc_getAssociatedObject(self, &Keys.closure) as? EmptyCallBackClosure
        }
        set{
            objc_setAssociatedObject(self, &Keys.closure, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue != nil{
                if #available(iOS 10.0, *) {
                    refreshControlLower = UIRefreshControl()
                    addSubview(self.refreshControlLower!)
                }
                else{
                    refreshControlLower = UIRefreshControl()
                    addSubview(self.refreshControlLower!)
                }
                refreshControlLower?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
            }
        }
    }
    @objc private func refreshData(_ sender: UIRefreshControl) {
        if let callBack = callBackOfRefreshControl{
            callBack()
        }
    }
    
}


extension UIResponder {
    
    private static weak var _currentFirstResponder: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        
        return _currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}



extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension Sequence
{
    func group<U : Hashable>(by: (Element) -> U) -> [(U,[Element])]
    {
        var groupCategorized: [(U,[Element])] = []
        for item in self {
            let groupKey = by(item)
            guard let index = groupCategorized.index(where: { $0.0 == groupKey }) else { groupCategorized.append((groupKey, [item])); continue }
            groupCategorized[index].1.append(item)
        }
        return groupCategorized
    }
}

