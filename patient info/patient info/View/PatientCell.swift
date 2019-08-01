//
//  PatientCell.swift
//  patient info
//
//  Created by Yeswanth Kanumuri on 7/31/19.
//  Copyright © 2019 BeTorchBearer. All rights reserved.
//

import UIKit

class PatientCell: UITableViewCell {

 
    var patient : Patient? {
      
        didSet {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            PatientNameLabel.text = "\(patient?.lname ?? ""), \(patient?.fname ?? "")"
            PatientLocation.text = patient?.location
            PatientDob.text = dateformatter.string(from: patient?.dob as! Date)
        }
    }
    
    
    private let PatientNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let PatientDob: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.textAlignment = .right
        return lbl
    }()
    
    
    private let PatientLocation : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
   
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(PatientNameLabel)
        addSubview(PatientLocation)
        addSubview(PatientDob)
        
        PatientNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 200, height: 0, enableInsets: false)
        PatientLocation.anchor(top: PatientNameLabel.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 200, height: 0, enableInsets: false)
        PatientDob.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 100, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}
