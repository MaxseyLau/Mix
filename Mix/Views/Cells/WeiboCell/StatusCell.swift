//
//  WeiboTableViewCell.swift
//  Mix
//
//  Created by Maxwell on 13/09/2017.
//  Copyright © 2017 Maxsey Inc. All rights reserved.
//

import UIKit
import Kingfisher
import YYText

class StatusCell: UICollectionViewCell {
    
    static let CellInset = UIEdgeInsetsMake(8, 8, 8, 8)
    
    var profileImage: UIButton = {
        let proImage = UIButton(type: .custom)
        proImage.backgroundColor = .white
        proImage.layer.cornerRadius = 18
        proImage.layer.borderWidth = 1 / UIScreen.main.scale
        proImage.frame.size = CGSize(width: 36, height: 36)
        proImage.layer.borderColor = UIColor.lightGray.cgColor
        proImage.layer.shouldRasterize = true
        proImage.layer.masksToBounds = true
        return proImage
    }()
    
    var name = UILabel()
    
    var textView = StatusTextLabel()
    
    var retweetedTextView = StatusTextLabel()
    
    var dateView: UILabel = {
        let dateView = UILabel()
        dateView.textColor = UIColor.gray
        dateView.font = UIFont.systemFont(ofSize: 12)
        return dateView
    }()
    
    var photosView = StatusPhotoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() -> () {
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1 / UIScreen.main.scale, height: 1)
        self.layer.shadowRadius = contentView.layer.cornerRadius
        self.layer.shadowOpacity = 0.2
        
        contentView.addSubview(name)
        contentView.addSubview(dateView)
        contentView.addSubview(profileImage)
        contentView.addSubview(textView)
        contentView.addSubview(retweetedTextView)
        contentView.addSubview(photosView)
        
        textView.highlightTapAction = self.highlightTapAction
        textView.highlightLongPressAction = self.highlightLongPressAction
        
        retweetedTextView.highlightTapAction = self.highlightTapAction
        retweetedTextView.highlightLongPressAction = self.highlightLongPressAction
        
        profileImage.frame = CGRect(x: 10, y: 10, width: 36, height: 36)
        name.frame = CGRect(x: profileImage.frame.maxX + 10, y: 10, width: UIScreen.main.bounds.width - 80, height: 18)
        dateView.frame = CGRect(x: name.frame.minX, y: profileImage.frame.maxY - 16, width: name.frame.width, height: 16)
        textView.frame.origin.y = profileImage.frame.maxY + 10
        textView.frame.size.width = UIScreen.main.bounds.width - StatusCell.CellInset.left - StatusCell.CellInset.right
        retweetedTextView.frame.size.width = textView.frame.width
        photosView.frame.size.width = textView.frame.width - StatusCell.CellInset.left - StatusCell.CellInset.right
        photosView.frame.origin.x = StatusCell.CellInset.left
    }
    
    func bind(for viewModel: WeiboStatus) -> () {
        name.text = viewModel.user?.screen_name
        
        profileImage.kf.setImage(with: URL(string: viewModel.user.profile_image_url!)!, for: .normal)
        textView.text = viewModel.text
        retweetedTextView.text = viewModel.retweetedStatus?.text
        
        photosView.frame.origin.y = textView.frame.maxY
        photosView.photos = viewModel.picUrls
        retweetedTextView.frame.origin.y = photosView.frame.maxY
        
        dateView.text = "\(createdDate(viewModel.createdAt as Date) ?? "") \(viewModel.sourceName)"
    }
    
    func createdDate(_ createdAt: Date) -> String? {
        let createdAt = createdAt
        if createdAt.isToday {
            let minute = Int(Date().timeIntervalSince(createdAt) / 60)
            if minute / 60 >= 1 {
                return "\(minute / 60)小时前"
            } else if minute >= 1 {
                return "\(minute)分钟前"
            } else {
                return "刚刚"
            }
        } else if createdAt.isYesterday {
            return createdAt.string(from: "昨天 HH:mm")
        } else if createdAt.isThisYear {
            return createdAt.string(from: "MM-dd HH:mm")
        } else {
            return createdAt.string(from: "yyyy-MM-dd HH:mm")
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            UIView.animate(withDuration: 0.2) {
                if newValue {
                    let scaleLine = max(self.frame.width, self.frame.height)
                    let scale = (scaleLine - 6) / scaleLine
                    self.transform = CGAffineTransform(scaleX: scale, y: scale)
                } else {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.frame.size.height = retweetedTextView.frame.maxY + StatusCell.CellInset.bottom
        self.frame.size.height = layoutAttributes.frame.height
        return layoutAttributes
    }
}

extension StatusCell {
    
    ///=============================================================================
    /// @name Interacting with Text Data
    ///=============================================================================
    
    /// When user tap the label, this action will be called (similar to tap gesture).
    func textTapAction(containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) -> Void {
        
    }
    
    /// When user long press the label, this action will be called (similar to long press gesture).
    func textLongPressAction(containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) -> Void {
        
    }
    
    /// When user tap the highlight range of text, this action will be called.
    func highlightTapAction(containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) -> Void {
        let highLight = (text.attributes(at: NSMaxRange(range) - 1, effectiveRange: nil)["YYTextHighlight"] as! YYTextHighlight)
        print("\(highLight.userInfo?[NSLinkAttributeName]! ?? "")")
    }
    
    /// When user long press the highlight range of text, this action will be called.
    func highlightLongPressAction(containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) -> Void {
        let highLight = (text.attributes(at: NSMaxRange(range) - 1, effectiveRange: nil)["YYTextHighlight"] as! YYTextHighlight)
        print("\(highLight.userInfo?[NSLinkAttributeName]! ?? "")")
    }
}
