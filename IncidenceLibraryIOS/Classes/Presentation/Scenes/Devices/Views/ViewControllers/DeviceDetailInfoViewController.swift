//
//  DeviceDetailInfoViewController.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 26/10/22.
//

import UIKit
import AVFoundation

class DeviceDetailInfoViewController: IABaseViewController, StoryboardInstantiable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var timeLabel: TextLabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var findView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var fechaTextFieldView: FieldView!
    @IBOutlet weak var batteryExpirationView: BatteryExpirationView!
    @IBOutlet weak var tableView: UITableView!
    
    var secondsRemainingConfig = 90
    var secondsRemaining = -1
    var timer:Timer?
    var timerVibrate:Timer?
    var incidences: [IncidenceDGT] = []
    var battery: Float = 0
    var expirationDate: String = ""
    var dgt: Int = 0
    var hasVibrate: Bool = false
    
    var closedAlertStopDevice: Bool = false
    var closedAlertNewIncidence: Bool = false
    
    private var device: Beacon?
    
    static var storyboardFileName = "DevicesScene"
    private var viewModel: DeviceDetailSdkViewModel! { get { return baseViewModel as? DeviceDetailSdkViewModel }}
    
    lazy var alertStopDeviceView: UIView = {
        let customTitleText = "stop_device".localized()
        let customSubtitleText = "stop_device_desc".localized()
        
        let x = 30.0;
        let y = view.frame.y;
        let width = UIScreen.main.bounds.width - x - x
        let widthMargin = 16.0
        let widthCross = 24.0
        let paddingLabel = 16.0
        let widthTitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel - widthCross - paddingLabel
        let widthSubtitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
        //let text = customTitleText
        let fontTitle = UIFont.app(.primarySemiBold, size: 14)!
        let fontSubTitle = UIFont.app(.primaryRegular, size: 14)!
        
        let titleHeight = widthCross;
        let subtitleHeight = customSubtitleText.height(withConstrainedWidth: widthSubtitleLabel, font: fontSubTitle);
        let yImage = titleHeight + paddingLabel
        let height = yImage + subtitleHeight + paddingLabel
        
        let alertView = UIView(frame: CGRect(x:30,y:y,width:width,height:height))
        alertView.translatesAutoresizingMaskIntoConstraints = false
        //alertView.isHidden = true
        //alertView.backgroundColor = .red
        //alertView.layer.opacity = 0.2
        alertView.backgroundColor = UIColor.app(.white)
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        alertView.layer.zPosition = 2
        alertView.isHidden = true
        
        let infoImageView = UIImageView(frame: CGRect(x: widthMargin, y: widthMargin, width: widthCross, height: widthCross))
        //infoImageView.backgroundColor = UIColor.app(.black)
        infoImageView.image = UIImage.app( "conection")?.withRenderingMode(.alwaysTemplate)
        infoImageView.tintColor = UIColor.app(.incidencePrimary)
        infoImageView.isUserInteractionEnabled = true
        //let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
        //crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(infoImageView)
        
        let tooltipLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: paddingLabel, width:widthTitleLabel, height:titleHeight))
        //tooltipLabel.backgroundColor = UIColor.app(.black300)
        //tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipLabel.font = fontTitle
        tooltipLabel.numberOfLines = 1
        tooltipLabel.textColor = UIColor.app(.black)
        tooltipLabel.text = customTitleText
        alertView.addSubview(tooltipLabel)
        
        let crossImageView = UIImageView(frame: CGRect(x: width - widthMargin - widthCross, y: widthMargin, width: widthCross, height: widthCross))
        //crossImageView.backgroundColor = UIColor.app(.black)
        crossImageView.image = UIImage.app( "Close")
        crossImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAlertStopDeviceView))
        crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(crossImageView)
        
        let tooltipDescLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: yImage, width:widthSubtitleLabel, height:subtitleHeight))
        //tooltipDescLabel.backgroundColor = UIColor.app(.black300)
        tooltipDescLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipDescLabel.font = fontSubTitle
        tooltipDescLabel.numberOfLines = 0
        tooltipDescLabel.textColor = UIColor.app(.black)
        tooltipDescLabel.text = customSubtitleText
        alertView.addSubview(tooltipDescLabel)
        
        return alertView
    }()
    
    lazy var alertNewIncidenceView: UIView = {
        let customTitleText = "alert_new_incidence_title".localized()
        let customSubtitleText = "alert_new_incidence_subtitle".localized()
        let customAlertText = "report_incidence".localized()
        
        let x = 30.0;
        let y = view.frame.y;
        let width = UIScreen.main.bounds.width - x - x
        let widthMargin = 16.0
        let widthCross = 24.0
        let paddingLabel = 16.0
        let widthTitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel - widthCross - paddingLabel
        let widthSubtitleLabel = width - widthMargin - widthMargin - widthCross - paddingLabel
        let widthButton = width - widthMargin - widthMargin
        //let text = customTitleText
        let fontTitle = UIFont.app(.primarySemiBold, size: 14)!
        let fontSubTitle = UIFont.app(.primaryRegular, size: 14)!
        
        let titleHeight = widthCross;
        let subtitleHeight = customSubtitleText.height(withConstrainedWidth: widthSubtitleLabel, font: fontSubTitle);
        //let alertHeight = customAlertText.height(withConstrainedWidth: widthSubtitleLabel, font: fontTitle);
        let alertHeight: Double = 30;
        let yText1 = titleHeight + paddingLabel
        let yText2 = yText1 + 8 + subtitleHeight
        let height = yText2 + alertHeight + paddingLabel
        
        let alertView = UIView(frame: CGRect(x:30,y:y,width:width,height:height))
        alertView.translatesAutoresizingMaskIntoConstraints = false
        //alertView.isHidden = true
        //alertView.backgroundColor = .red
        //alertView.layer.opacity = 0.2
        alertView.backgroundColor = UIColor.app(.white)
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
        alertView.layer.borderWidth = 1
        alertView.layer.borderColor = UIColor.app(.incidence200)?.cgColor
        alertView.layer.zPosition = 2
        alertView.isHidden = true
        
        let infoImageView = UIImageView(frame: CGRect(x: widthMargin, y: widthMargin, width: widthCross, height: widthCross))
        //infoImageView.backgroundColor = UIColor.app(.black)
        infoImageView.image = UIImage.app( "conection")?.withRenderingMode(.alwaysTemplate)
        infoImageView.tintColor = UIColor.app(.incidencePrimary)
        infoImageView.isUserInteractionEnabled = true
        //let tap = UITapGestureRecognizer(target: self, action: #selector(closeTooltip))
        //crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(infoImageView)
        
        let tooltipLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: paddingLabel, width:widthTitleLabel, height:titleHeight))
        //tooltipLabel.backgroundColor = UIColor.app(.black300)
        //tooltipLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipLabel.font = fontTitle
        tooltipLabel.numberOfLines = 1
        tooltipLabel.textColor = UIColor.app(.black)
        tooltipLabel.text = customTitleText
        alertView.addSubview(tooltipLabel)
        
        let crossImageView = UIImageView(frame: CGRect(x: width - widthMargin - widthCross, y: widthMargin, width: widthCross, height: widthCross))
        //crossImageView.backgroundColor = UIColor.app(.black)
        crossImageView.image = UIImage.app( "Close")
        crossImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAlertNewIncidenceView))
        crossImageView.addGestureRecognizer(tap)
        alertView.addSubview(crossImageView)
        
        let tooltipDescLabel = UILabel(frame: CGRect(x: widthMargin + widthCross + paddingLabel, y: yText1, width:widthSubtitleLabel, height:subtitleHeight))
        //tooltipDescLabel.backgroundColor = UIColor.app(.black300)
        tooltipDescLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .left)
        //tooltipLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        tooltipDescLabel.font = fontSubTitle
        tooltipDescLabel.numberOfLines = 0
        tooltipDescLabel.textColor = UIColor.app(.black)
        tooltipDescLabel.text = customSubtitleText
        alertView.addSubview(tooltipDescLabel)
        
        let alertTimeButton = UIButton(frame: CGRect(x: widthMargin, y: yText2, width:widthButton, height:alertHeight))
        alertTimeButton.titleLabel?.numberOfLines = 1
        alertTimeButton.titleLabel?.lineBreakMode = .byClipping
        alertTimeButton.titleLabel?.minimumScaleFactor = 0.1
        alertTimeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        alertTimeButton.setTitle(customAlertText, for: .normal)
        alertTimeButton.backgroundColor = UIColor.app(.incidencePrimary)
        alertTimeButton.tintColor = .white
        alertTimeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        alertTimeButton.addTarget(self, action: #selector(createInc), for: .touchUpInside)
        //alertTimeButton.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addSubview(alertTimeButton)
        
        return alertView
    }()
    
    // MARK: - Lifecycle
    static func create(with viewModel: DeviceDetailSdkViewModel) -> DeviceDetailInfoViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = DeviceDetailInfoViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //EventNotification.addObserver(self, code: .BEACON_UPDATED, selector: #selector(beaconUpdated))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopTimer();
        stopTimerVibrate();
        secondsRemaining = 0;
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        titleLabel.text = "start_device".localized()
        titleLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        timeLabel.text = "01:30"
        timeLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        //let image = UIImage.app( "device_start")?.withRenderingMode(.alwaysTemplate)
        let image = UIImage.app( "device_start")
        deviceImage.image = image
        deviceImage.contentMode = .scaleAspectFit
        //deviceImage.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.setTitle("return_back".localized(), for: .normal)
        backButton.addTarget(self, action: #selector(onClickReturn), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = IncidenceDGTCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(IncidenceDGTCell.self, forCellReuseIdentifier: IncidenceDGTCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
        
        view.addSubview(alertStopDeviceView)
        view.addSubview(alertNewIncidenceView)
        
        startCountDownTimer()
        
        setUpNavigation()
    }
    
    override func loadData() {
        refreshData();
    }
    
    private func setUpNavigation() {
        
    }
    
    func startCountDownTimer() {
        stopTimer()
        secondsRemaining = secondsRemainingConfig;
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            self.timer = Timer
            print("self.secondsRemaining2", secondsRemaining)
            if secondsRemaining > 0 {
                let seconds: Int = secondsRemaining  % 60
                let minutes: Int = (secondsRemaining  / 60) % 60
                timeLabel.text = String(format:"%02d:%02d", minutes, seconds)
                
                secondsRemaining -= 1
                
                if (seconds % 5 == 0) {
                    //refreshData();
                }
            } else {
                Timer.invalidate()
                self.timer = nil
                
                showAlertFinishTimer()
            }
        }
    }
    
    func startCountDownTimerVibrate() {
        if (!closedAlertNewIncidence) {
            stopTimerVibrate()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
                self.timerVibrate = Timer
                print("self.vibrate")
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    func stopTimer() {
        if let tm = timer {
            tm.invalidate()
            timer = nil
        }
    }
    
    func stopTimerVibrate() {
        if let tm = timerVibrate {
            tm.invalidate()
            timerVibrate = nil
        }
    }
    
    func refreshData() {
        let user = viewModel.user
        let vehicle = viewModel.vehicle
        
        Api.shared.getBeaconDetailSdk(vehicle: vehicle, user: user, completion: { result in
            
            if (result.isSuccess())
            {
                //let dataSTR = "{\"dgt\":0,\"incidences\": [{\"hour\":\"17:23\"}],\"expirationDate\":\"2037-12-31 23:59:59\",\"battery\":27.999999999999972,\"imei\":\"869154040054509\"}";
                //let data = "{\"dgt\":0,\"incidences\":[{\"hour\":\"17:23\",\"id\":1,\"lat\":41.38879,\"lon\":2.1589900000000002,\"date\":\"27/10/2022\"},{\"hour\":\"22:10\",\"id\":2,\"lat\":41.38879,\"lon\":2.1589900000000002,\"date\":\"21/10/2022\"},{\"hour\":\"11:20\",\"id\":3,\"lat\":41.38879,\"lon\":2.1589900000000002,\"date\":\"16/10/2022\"},{\"hour\":\"09:33\",\"id\":4,\"lat\":41.38879,\"lon\":2.1589900000000002,\"date\":\"08/10/2022\"},{\"hour\":\"10:00\",\"id\":5,\"lat\":41.38879,\"lon\":2.1589900000000002,\"date\":\"01/10/2022\"}],\"expirationDate\":\"2037-12-31 23:59:59\",\"battery\":27.999999999999972,\"imei\":\"869154040054509\"}";
                if let data = result.getJSONString(key: "data") {
                //if data != "" {
                    print(data)
                    if let dataDic = StringUtils.convertToDictionary(text: data) {
                        print("TENEMOS DATA")
                        self.battery = Float(dataDic["battery"] as! Double)
                        self.expirationDate = dataDic["expirationDate"] as! String
                        self.dgt = dataDic["dgt"] as! Int
                        let incidencesVal: [NSDictionary]? = dataDic["incidences"] as? [NSDictionary]
                        
                        
                        // print(incidencesVal)
                        //if let incidencesValT = incidencesVal {
                        //    print(incidencesValT)
                        //}
                        
                        if let incidencesVal = incidencesVal {
                            self.incidences.removeAll()
                            
                            for incidence in incidencesVal {
                                //print("\(incidence.hour) is from \(incidence.id)")
                                print (incidence)
                                
                                let lat: Double = incidence["lat"] as! Double
                                let lon: Double = incidence["lon"] as! Double
                                let date: String = incidence["date"] as! String
                                let hour: String = incidence["hour"] as! String

                                let incidenceDGT: IncidenceDGT = IncidenceDGT()
                                incidenceDGT.lat = lat;
                                incidenceDGT.lon = lon;
                                incidenceDGT.date = date;
                                incidenceDGT.hour = hour;

                                //ListItem li = new ListItem("20-05-2021, 16:45h", "");
                                self.incidences.append(incidenceDGT);
                            }
                        }
                        
                        self.changeView()
                        if (self.dgt == 0) {
                            self.openAlertStopDeviceView()
                        } else if (self.dgt == 1) {
                            /*
                            if (!self.hasVibrate) {
                                self.hasVibrate = true;
                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                            }
                            */
                            self.startCountDownTimerVibrate()
                            
                            self.closeAlertStopDeviceView()
                            self.openAlertNewIncidenceView()
                        }
                        self.callRetry()
                    } else {
                        print("NOOOOO TENEMOS DATA ")
                        if (self.expirationDate != "") {
                            self.closeAlertStopDeviceView()
                            self.closeAlertNewIncidenceView()
                            self.stopTimerVibrate()
                        }
                        
                        self.callRetry()
                    }
                } else {
                    self.callRetry()
                }
            } else {
                self.stopTimer()
                self.stopTimerVibrate()
                self.onBadResponse(result: result, handler: { UIAlertAction in
                    self.backPressed()
                })
            }
            //self.changeView()
       })
    }
    
    func callRetry() {
        if (self.secondsRemaining > 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if (self.secondsRemaining > 0) {
                    self.refreshData()
                }
            }
        }
    }
    
    func showAlertFinishTimer() {
        let alertController: UIAlertController = UIAlertController(title: "start_device_without_network".localized(), message: "start_device_without_network_desc".localized(), preferredStyle: .alert)
        let firstAction: UIAlertAction = UIAlertAction(title: "accept".localized(), style: .default) { action -> Void in
            self.startCountDownTimer();
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel".localized(), style: .default) { action -> Void in
            self.onClickReturn();
            
        }
        alertController.addAction(firstAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onClickReturn() {
        stopTimer();
        stopTimerVibrate()
        backPressed()
    }
    
    func changeView() {
        stopTimer();
        stopTimerVibrate();

        infoView.isHidden = false
        findView.isHidden = true
        /*
            progressBar.setProgress(battery);
            if (battery <= 100) {
                progressBar.getProgressDrawable().setColorFilter(Color.RED, android.graphics.PorterDuff.Mode.SRC_IN);
                DrawableCompat.setTint(imgInfo.getDrawable(), Color.RED);
            }

            txtSubTitleBattery.setText(battery + " %");
         */
        
        fechaTextFieldView.configure(titleText: "device_expiration".localized(), valueText: expirationDate);
        batteryExpirationView.configure(titleText: "device_battery_status".localized(), progress: battery , completion: {
            if let device = self.device {
                
                let deviceModel: DeviceDetailViewModel = DeviceDetailViewModel(device: device)
                
                let vc = DeviceInfoViewController.create(with: deviceModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        self.tableView.reloadData()
    }
    
    @objc func openAlertStopDeviceView() {
        if (!closedAlertStopDevice) {
            alertStopDeviceView.isHidden = false;
        }
    }
    
    @objc func closeAlertStopDeviceView() {
        closedAlertStopDevice = true
        alertStopDeviceView.isHidden = true;
    }
    
    @objc func openAlertNewIncidenceView() {
        if (!closedAlertNewIncidence) {
            alertNewIncidenceView.isHidden = false;
        }
    }
    
    @objc func closeAlertNewIncidenceView() {
        closedAlertNewIncidence = true
        alertNewIncidenceView.isHidden = true;
        
        stopTimerVibrate()
    }
    
    @objc func createInc() {
        //let vm = ReportTypeViewModel(vehicle: viewModel.device.vehicle, vehicleTmp: viewModel.device.vehicle, openFromNotification: false)
        //let viewController = ReportTypeViewController.create(with: vm)
        //navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DeviceDetailInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IncidenceDGTCell.reuseIdentifier, for: indexPath) as? IncidenceDGTCell else {
            assertionFailure("Cannot dequeue reusable cell \(IncidenceDGTCell.self) with reuseIdentifier: \(IncidenceDGTCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
     
        cell.configure(with: incidences[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let vm = ReportTypeViewModel(vehicle: viewModel.vehicles[indexPath.row])
        let vc = ReportTypeViewController.create(with: vm)
        navigationController?.pushViewController(vc, animated: true)
        */
        
        //carSelected(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IncidenceDGTCell.height
    }
}
