//
//  IncidenceDGTCell.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 27/10/22.
//

import UIKit
// import MapboxStatic

class IncidenceDGTCell: UITableViewCell {

    static let reuseIdentifier = String(describing: IncidenceDGTCell.self)
    static let height = CGFloat(99)
    
    let mapView = UIImageView()
    let titleLabel = TextLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    private func setUpUI() {
        backgroundColor = .clear
        
        self.addSubview(mapView)
        mapView.anchor(top: self.topAnchor, left: self.leftAnchor, topConstant: 12, leftConstant: 36, widthConstant: 79, heightConstant: 69)
        //mapView.backgroundColor = .red;
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: mapView.rightAnchor, right: self.rightAnchor, topConstant: 12, leftConstant: 12, rightConstant: 48)
        titleLabel.font = UIFont.app(.primaryRegular, size: 14)
        titleLabel.textColor = UIColor.app(.black500)
        //titleLabel.backgroundColor = .blue;
        
        self.addSubview(titleLabel)
    }
    
    public func configure(with model: IncidenceDGT) {
        /*
        if let city = model.city {
            titleLabel.text = model.getTitle() + " " + "incidence_in".localized() + " " + city
        } else {
            titleLabel.text = model.getTitle()
        }
        
        dateLabel.text = model.dateCreated
        addressLabel.text = model.street
        
        let otherStr = model.isCanceled() ? "incidence_status_canceled".localized() : "incidence_status_active".localized()
        let otherColor = model.isCanceled() ? UIColor.app(.errorPrimary) : UIColor.app(.incidencePrimary)
        badgeView.configure(titleText: model.isClosed() ? "incidence_status_closed".localized() : otherStr, badgeColor: model.isClosed() ? UIColor.app(.success) : otherColor)
         */
        titleLabel.text = model.date! + ", " + model.hour! + "h";
        
        let accessToken = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken")  as! String
        /*
        let camera = SnapshotCamera(
            lookingAtCenter: CLLocationCoordinate2D(latitude: model.lat ?? 0, longitude: model.lon ?? 0),
            zoomLevel: 13)
        let options = SnapshotOptions(
            styleURL: URL(string: "mapbox://styles/mapbox/streets-v11")!,
            camera: camera,
            size: CGSize(width: 320, height: 320))
        let snapshot = Snapshot(
            options: options,
            accessToken: accessToken)
        
        mapView.image = snapshot.image
        */
        
        //let imgURL = URL(string: snapshot.url ?? "")
        //imageView.kf.setImage(with: imgURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = .clear
    }
    
}
