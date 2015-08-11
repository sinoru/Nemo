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
    
    weak private var checkMark: UILabel!
    
    override init(frame: CGRect) {
        let checkMark = UILabel()
        
        self.checkMark = checkMark
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.checkMark.translatesAutoresizingMaskIntoConstraints = false
        self.checkMark.text = "✓"
        self.checkMark.font = UIFont.systemFontOfSize(20)
        self.checkMark.textColor = UIColor.whiteColor()
        self.checkMark.textAlignment = .Center
        
        self.addSubview(checkMark)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: self.checkMark, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: self.checkMark, attribute: .CenterY, multiplier: 1.0, constant: -1.0))
    }

    required init?(coder aDecoder: NSCoder) {
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
    
    weak private var imageView: UIImageView!
    weak var checkIndicatorView: CheckIndicatorView!
    
    override init(frame: CGRect) {
        let imageView = UIImageView(frame: CGRectZero)
        let checkIndicatorView = CheckIndicatorView(frame: CGRectZero)
        
        self.imageView = imageView
        self.checkIndicatorView = checkIndicatorView
        
        super.init(frame: frame)
        
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.checkIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(checkIndicatorView)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView]-0-|", options: [], metrics: nil, views: ["imageView": imageView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageView]-0-|", options: [], metrics: nil, views: ["imageView": imageView]))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: checkIndicatorView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30.0))
        self.contentView.addConstraint(NSLayoutConstraint(item: checkIndicatorView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30.0))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Leading, relatedBy: .LessThanOrEqual, toItem: checkIndicatorView, attribute: .Leading, multiplier: 1.0, constant: -4.0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: checkIndicatorView, attribute: .Trailing, multiplier: 1.0, constant: 4.0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Bottom, relatedBy: .Equal, toItem: checkIndicatorView, attribute: .Bottom, multiplier: 1.0, constant: 4.0))
        
        let trailingEqualConstraint = NSLayoutConstraint(item: self.contentView, attribute: .Trailing, relatedBy: .Equal, toItem: checkIndicatorView, attribute: .Trailing, multiplier: 1.0, constant: 4.0)
        trailingEqualConstraint.priority = 500
        self.contentView.addConstraint(trailingEqualConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var selected: Bool {
        didSet {
            self.checkIndicatorView.selected = selected
        }
    }
}

