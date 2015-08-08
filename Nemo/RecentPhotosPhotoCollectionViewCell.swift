//
//  RecentPhotosPhotoCollectionViewCell.swift
//  
//
//  Created by Sinoru on 2015. 8. 9..
//
//

import UIKit

class CheckIndicatorView: UIView {
    var selected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBOutlet dynamic weak private var checkMark: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        
        CGContextSetShadow(context, CGSize(width: 0.0, height: 0.0), 5.0)
        
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextAddEllipseInRect(context, self.bounds.rectByInsetting(dx: 4.0, dy: 4.0))
        CGContextStrokePath(context)
        
        CGContextRestoreGState(context)
        if (selected) {
            CGContextSaveGState(context)
            CGContextSetFillColorWithColor(context, self.tintColor.CGColor)
            CGContextFillEllipseInRect(context, self.bounds.rectByInsetting(dx: 4.32, dy: 4.32))
            CGContextRestoreGState(context)
            checkMark.hidden = false
        }
        else {
            checkMark.hidden = true
        }
    }
}

class RecentPhotosPhotoCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    dynamic weak private var imageView: UIImageView!
    weak var checkIndicatorView: CheckIndicatorView!
    
    override init(frame: CGRect) {
        let imageView = UIImageView(frame: CGRectZero)
        let checkIndicatorView = CheckIndicatorView(frame: CGRectZero)
        
        self.imageView = imageView
        self.checkIndicatorView = checkIndicatorView
        
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(checkIndicatorView)
        
        self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: nil, metrics: nil, views: ["imageView": imageView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[imageView]-|", options: nil, metrics: nil, views: ["imageView": imageView]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var selected: Bool {
        didSet {
            self.checkIndicatorView.selected = selected
        }
    }
}

