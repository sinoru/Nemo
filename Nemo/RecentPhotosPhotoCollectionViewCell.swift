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

    weak fileprivate var checkMark: UILabel!

    override init(frame: CGRect) {
        let checkMark = UILabel()

        self.checkMark = checkMark

        super.init(frame: frame)

        self.backgroundColor = UIColor.clear

        self.checkMark.translatesAutoresizingMaskIntoConstraints = false
        self.checkMark.text = "✓"
        self.checkMark.font = UIFont.systemFont(ofSize: 20)
        self.checkMark.textColor = UIColor.white
        self.checkMark.textAlignment = .center

        self.addSubview(checkMark)

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.checkMark, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.checkMark, attribute: .centerY, multiplier: 1.0, constant: -1.0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        context?.saveGState()

        context?.setShadow(offset: CGSize(width: 0.0, height: 0.0), blur: 5.0)

        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.addEllipse(in: self.bounds.insetBy(dx: 4.0, dy: 4.0))
        context?.strokePath()

        context?.restoreGState()
        if (selected) {
            context?.saveGState()
            context?.setFillColor(self.tintColor.cgColor)
            context?.fillEllipse(in: self.bounds.insetBy(dx: 4.32, dy: 4.32))
            context?.restoreGState()
            checkMark.isHidden = false
        } else {
            checkMark.isHidden = true
        }
    }
}

class RecentPhotosPhotoCollectionViewCell: UICollectionViewCell {

    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }

    weak fileprivate var imageView: UIImageView!
    weak var checkIndicatorView: CheckIndicatorView!

    override init(frame: CGRect) {
        let imageView = UIImageView(frame: CGRect.zero)
        let checkIndicatorView = CheckIndicatorView(frame: CGRect.zero)

        self.imageView = imageView
        self.checkIndicatorView = checkIndicatorView

        super.init(frame: frame)

        self.imageView.contentMode = .scaleAspectFill
        self.imageView.translatesAutoresizingMaskIntoConstraints = false

        self.checkIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(checkIndicatorView)

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: [], metrics: nil, views: ["imageView": imageView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: [], metrics: nil, views: ["imageView": imageView]))

        self.contentView.addConstraint(NSLayoutConstraint(item: checkIndicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0))
        self.contentView.addConstraint(NSLayoutConstraint(item: checkIndicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0))

        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .leading, relatedBy: .lessThanOrEqual, toItem: checkIndicatorView, attribute: .leading, multiplier: 1.0, constant: -4.0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: checkIndicatorView, attribute: .trailing, multiplier: 1.0, constant: 4.0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: checkIndicatorView, attribute: .bottom, multiplier: 1.0, constant: 4.0))

        let trailingEqualConstraint = NSLayoutConstraint(item: self.contentView, attribute: .trailing, relatedBy: .equal, toItem: checkIndicatorView, attribute: .trailing, multiplier: 1.0, constant: 4.0)
        trailingEqualConstraint.priority = 500
        self.contentView.addConstraint(trailingEqualConstraint)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            self.checkIndicatorView.selected = isSelected
        }
    }
}
