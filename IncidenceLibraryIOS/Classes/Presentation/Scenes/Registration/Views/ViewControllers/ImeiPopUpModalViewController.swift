//
//  ImeiPopUpModalViewController.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 27/3/23.
//

import UIKit

public protocol ImeiPopUpModalDelegate: AnyObject {
    func didTapCancel()
    func didTapAccept(imei: String)
}

public final class ImeiPopUpModalViewController: UIViewController, TextFieldViewDelegate, KeyboardDismiss {
    
    private static func create(
        delegate: ImeiPopUpModalDelegate
    ) -> ImeiPopUpModalViewController {
        let view = ImeiPopUpModalViewController(delegate: delegate)
        return view
    }
    
    @discardableResult
    static public func present(
        initialView: UIViewController,
        delegate: ImeiPopUpModalDelegate
    ) -> ImeiPopUpModalViewController {
        let view = ImeiPopUpModalViewController.create(delegate: delegate)
        view.modalPresentationStyle = .overFullScreen
        //view.modalTransitionStyle = .coverVertical
        initialView.present(view, animated: true)
        return view
    }
    
    public init(delegate: ImeiPopUpModalDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public weak var delegate: ImeiPopUpModalDelegate?
    
    lazy var imeiTextFieldView: TextFieldView = {
        return TextFieldView()
    }()
    
    private lazy var canvas: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        //let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(didDis))
        //view.addGestureRecognizer(tapDismissKeyboard)
        
        let x = self.view.bounds.width * 0.1;
        let y = view.frame.y;
        let width = UIScreen.main.bounds.width - x - x
        let widthMargin = 20.0
        let widthCross = 24.0
        let paddingLabel = 16.0
        let widthTitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
        let widthSubtitleLabel = width - widthMargin - widthMargin
        //let text = customTitleText
        let fontTitle = UIFont.app(.primarySemiBold, size: 16)!
        let fontSubTitle = UIFont.app(.primaryRegular, size: 14)!
        
        let customTitleText = "imei_code_title".localized()
        let customSubtitleText = "imei_code_subtitle".localized()
        
        let titleHeight = widthCross;
        let subtitleHeight = customSubtitleText.height(withConstrainedWidth: widthSubtitleLabel, font: fontSubTitle);
        let yImage = titleHeight + paddingLabel
        let height = yImage + subtitleHeight + paddingLabel
        
        let tooltipLabel = UILabel(frame: CGRect(x: widthMargin, y: paddingLabel, width:widthTitleLabel, height:titleHeight))
        //tooltipLabel.backgroundColor = UIColor.app(.black300)
        //tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipLabel.font = fontTitle
        tooltipLabel.numberOfLines = 1
        tooltipLabel.textColor = UIColor.app(.black)
        tooltipLabel.text = customTitleText
        view.addSubview(tooltipLabel)
        
        let crossImageView = UIImageView(frame: CGRect(x: width - widthMargin - widthCross, y: paddingLabel, width: widthCross, height: widthCross))
        //crossImageView.backgroundColor = UIColor.app(.black)
        crossImageView.image = UIImage.app( "Close")
        crossImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCancel))
        crossImageView.addGestureRecognizer(tap)
        view.addSubview(crossImageView)
        
        let tooltipDescLabel = UILabel(frame: CGRect(x: widthMargin, y: yImage, width:widthSubtitleLabel, height:subtitleHeight))
        //tooltipDescLabel.backgroundColor = UIColor.app(.black300)
        tooltipDescLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipDescLabel.font = fontSubTitle
        tooltipDescLabel.numberOfLines = 0
        tooltipDescLabel.textColor = UIColor.app(.black500)
        tooltipDescLabel.text = customSubtitleText
        view.addSubview(tooltipDescLabel)
        
        //let textView = TextFieldView(frame: CGRect(x: widthMargin, y: height, width:widthSubtitleLabel, height:64))
        imeiTextFieldView.frame = CGRect(x: widthMargin, y: height, width:widthSubtitleLabel, height:64);
        imeiTextFieldView.title = "IMEI"
        imeiTextFieldView.placeholder = "IMEI"
        imeiTextFieldView.value = ""
        imeiTextFieldView.value = "869154040415403"
        imeiTextFieldView.isUserInteractionEnabled = true
        imeiTextFieldView.isMultipleTouchEnabled = false
        imeiTextFieldView.disablePadding()
        //textView.showDelete = true
        //textView.setDeleteImage(image: UIImage.init(named: "Direction=Down-2"), tintColor: UIColor.app(.black600) ?? .black)
        imeiTextFieldView.setContainerBackgroundColor(color: .white)
        imeiTextFieldView.status = .active;
        imeiTextFieldView.setTextFieldColor(color: UIColor.app(.black600) ?? .black)
        imeiTextFieldView.showEditable = true
        imeiTextFieldView.showSuccess = false
        imeiTextFieldView.delegate = self
        view.addSubview(imeiTextFieldView)
        
        let continueButton = PrimaryButton(frame: CGRect(x: widthMargin, y: height + imeiTextFieldView.frame.height + paddingLabel, width: widthSubtitleLabel, height: 64))
        continueButton.setTitle("accept".localized(), for: .normal)
        let tapContinue = UITapGestureRecognizer(target: self, action: #selector(didTapAccept))
        continueButton.addGestureRecognizer(tapContinue)
        view.addSubview(continueButton)
        
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let b: UIButton = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemRed
        b.setTitle("Cancel", for: .normal)
        b.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        return b
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapCancel()
    }
    
    @objc func didTapAccept(_ btn: UIButton) {
        self.delegate?.didTapAccept(imei: imeiTextFieldView.value ?? "")
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.addSubview(canvas)
        NSLayoutConstraint.activate([
            self.canvas.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.canvas.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.canvas.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.8),
            self.canvas.heightAnchor.constraint(equalToConstant: 300),
            //self.cancelButton.heightAnchor.constraint(equalToConstant: 20),
            //self.cancelButton.widthAnchor.constraint(equalToConstant: 60),
            //self.cancelButton.centerXAnchor.constraint(equalTo: self.canvas.centerXAnchor),
            //self.cancelButton.centerYAnchor.constraint(equalTo: self.canvas.centerYAnchor)
        ])
        
        setUpHideKeyboardOnTap()
    }
}
