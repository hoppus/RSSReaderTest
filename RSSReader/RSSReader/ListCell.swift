//
//  ListCell.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 09.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descr: UITextView!
    @IBOutlet weak var sourceTitle: UILabel!
    
    @IBOutlet weak var pictureHeightConstraint: NSLayoutConstraint!
    
    
    var model : Item! {
        
        didSet {
            
            let df = NSDateFormatter()
            df.timeStyle = .ShortStyle
            df.dateStyle = .ShortStyle
            df.locale = NSLocale(localeIdentifier: "ru")
            df.timeZone = NSTimeZone(abbreviation: "GMT")
            
            timeLabel.text = df.stringFromDate(model.createdate)
            titleText.text = model.title
            descr.text = model.descr
            sourceTitle.text = model.sourcetitle
            
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        descr.textContainerInset = UIEdgeInsetsZero
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        cellChangeState(.close)
        updateTextContainerFrame()
        
    }
    
    func updateTextContainerFrame() {
        
        var rect = descr.convertRect(picture.frame, fromView: picture.superview!)
        rect.size.width += 5
        let bezier = UIBezierPath(rect: rect)
        
        // print("rect \(rect)")
        //print("picture \(picture)")
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
            delta = GC.partOfImageToScreenStateClose
        case  .close :
            delta = GC.partOfImageToScreenStateOpen
        }
        
        pictureHeightConstraint.constant = ScreenAspect.partOfScreen(delta, type: .width)
        
        
        
        self.updateConstraints()
        self.layoutIfNeeded()
    }
}
