//
//  ListCell.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import UIKit
import AlamofireImage

class ListCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var descr: UITextView!
    @IBOutlet weak var sourceTitle: UILabel!
    @IBOutlet weak var pictureView: UIView!
    
    @IBOutlet weak var pictureHeightConstrain: NSLayoutConstraint!
    
    let placeholderImage = UIImage(named: "RSS")
    
    var model : Item! {
        
        didSet {
            
            let colorBlack = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            let colorGray = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
            
            let df = NSDateFormatter()
            df.timeStyle = .ShortStyle
            df.dateStyle = .ShortStyle
            df.locale = NSLocale(localeIdentifier: "ru")
            df.timeZone = NSTimeZone.localTimeZone()
            
            timeLabel.text = df.stringFromDate(model.createdate)
            timeLabel.textColor = colorGray
            
            sourceTitle.text = model.sourcetitle
            sourceTitle.textColor = colorGray
            
            // description
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Left
            
            let attributeTitle = [NSForegroundColorAttributeName : colorBlack, NSFontAttributeName : UIFont.boldSystemFontOfSize(13), NSParagraphStyleAttributeName : paragraphStyle]
            
            let attrStringTitle =  NSMutableAttributedString(string: model.title + "\n", attributes: attributeTitle)
            
            let attributeDescription = [NSForegroundColorAttributeName : colorGray, NSFontAttributeName : UIFont.systemFontOfSize(10), NSParagraphStyleAttributeName : paragraphStyle]
            
            let attrStringDescription = NSAttributedString(string: model.descr, attributes: attributeDescription)
            
            attrStringTitle.appendAttributedString(attrStringDescription)
            
            descr.attributedText = attrStringTitle

            //image

            if let imageString = model.image {
                
                picture.af_setImageWithURL(
                    NSURL(string: imageString)!,
                    placeholderImage: placeholderImage,
                    filter: nil,
                    imageTransition: .CrossDissolve(0.1)
                )
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        picture.image = placeholderImage
        cellChangeState(.close)
        updateTextContainerFrame()
        
    }
    
    func updateTextContainerFrame() {
        
        var rect = descr.convertRect(picture.bounds, fromView: pictureView)
        rect.size.width += 3
        let bezier = UIBezierPath(rect: rect)
        descr.textContainer.exclusionPaths = [bezier]
        
        self.layoutIfNeeded()
    }
    
    enum state {
        case open
        case close
    }
    
    func cellChangeState(newState : state) {
        
        var delta : Int!
        switch newState {
        case .open :
            delta = GC.partOfImageToScreenStateOpen
        case  .close :
            delta = GC.partOfImageToScreenStateClose
        }
        
        pictureHeightConstrain.constant = ScreenAspect.partOfScreen(delta, type: .width)
        
        self.updateConstraints()
        self.layoutIfNeeded()
    }
}
