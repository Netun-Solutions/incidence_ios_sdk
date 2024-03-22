//
//  Constants.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 04/06/2021.
//

import UIKit

struct Constants {

#if PRO
    static let APP_URL_SCHEME = "incidenceprefspro"
#elseif PRE
    static let APP_URL_SCHEME = "incidenceprefspre"
#else
    static let APP_URL_SCHEME = "incidenceprefstest"
#endif
    
    static let KEY_PUSH_ID = "KEY_PUSH_ID"
    static let KEY_DEVICE_ID = "KEY_DEVICE_ID"
    static let KEY_USER_TOKEN = "KEY_USER_TOKEN"
    static let KEY_USER = "KEY_USER"
    static let KEY_USER_DEFAULT_VEHICLE_ID = "KEY_USER_DEFAULT_VEHICLE_ID"
    static let KEY_USER_DEVICE_NOTIFICATIONS = "KEY_USER_DEVICE_NOTIFICATIONS"
    static let KEY_USER_VEHICLES = "KEY_USER_VEHICLES"
    static let KEY_USER_SIGNOUT = "KEY_USER_SIGNOUT"
    static let KEY_GENERAL_DATA = "KEY_GENERAL_DATA"
    static let KEY_USER_LANG = "KEY_USER_LANG"
    static let KEY_LITERALS_LANG = "KEY_LITERALS_LANG"
    static let KEY_LITERALS_VERSION = "KEY_LITERALS_VERSION_1"
    static let KEY_LITERALS_VALUES = "KEY_LITERALS_VALUES"
    static let KEY_LITERALS_VOICE_VALUES = "KEY_LITERALS_VOICE_VALUES"
    static let KEY_LAST_INCIDENCE_REPORTED_DATE = "KEY_LAST_INCIDENCE_REPORTED_DATE"
    static let KEY_CONFIG_EXPIRE_POLICY_TIME = "KEY_CONFIG_EXPIRE_POLICY_TIME"
    static let KEY_CONFIG_RETRY_SECON_DRIVER_REQUEST = "KEY_CONFIG_RETRY_SECON_DRIVER_REQUEST"
    static let KEY_CONFIG_MAP_REFRESH_TIME = "KEY_CONFIG_MAP_REFRESH_TIME"
    static let KEY_CONFIG_EXPIRE_SMS_TIME = "KEY_CONFIG_EXPIRE_SMS_TIME"
    static let KEY_CONFIG_EXPIRE_CANCEL_TIME = "KEY_CONFIG_EXPIRE_CANCEL_TIME"
    static let KEY_CONFIG_HOME_VIDEO = "KEY_CONFIG_HOME_VIDEO"
    static let KEY_CONFIG_SHOW_IOT = "KEY_CONFIG_SHOW_IOT"
    static let KEY_CONFIG_REPEAT_VOICE = "KEY_CONFIG_REPEAT_VOICE"
    static let KEY_CONFIG_TEST_META_KEY = "KEY_CONFIG_TEST_META_KEY"
    
    static let PHONE_CONTACT = "+34910608864"
    static let PHONE_EMERGENCY = "+34913536306"
    static let EMAIL_CONTACT = "infoapp@incidence.eu"
    static let URL_FAQS = "https://incidence.eu/#preguntas-frecuentes-anchor"
    
    static let SEGMENT_KEY = "kLKYNJXbXBUGDkZ5fm12yc"
    static let SENTRY_KEY = "https://86cb38de73c444ac8e1fe67c50f4f69b@o617119.ingest.sentry.io/5750681"
    
    static let NOTIFICATION_ACTION_ADD_VEHICLE = "openAddVehicle"
    static let NOTIFICATION_ACTION_ADD_BEACON = "openAddBeacon"
    static let NOTIFICATION_ACTION_OPEN_VEHICLE_ID = "openVehicleId"
    static let NOTIFICATION_ACTION_OPEN_POLICY_ID = "openPolicyId"
    static let NOTIFICATION_ACTION_OPEN_RATE_INCIDENCE = "openRateIncidence"
    static let NOTIFICATION_ACTION_OPEN_USER = "openUser"
    static let NOTIFICATION_ACTION_OPEN_VEHICLE_DRIVERS = "openVehicleDrivers"
    static let NOTIFICATION_ACTION_RESEND_DRIVER_REQUEST = "resendDriverRequest"
    
    static let NOTIFICATION_PUSH_ACTION_OPEN_INCIDENCE = "openIncidence"
    
    static let NOTIFICATION_STATUS_READ = 1
    static let NOTIFICATION_STATUS_DELETE = 2
    
    static let VALIDATE_USER_DNI_EXISTS = "user_dni_exists"
    static let VALIDATE_USER_NIE_EXISTS = "user_nie_exists"
    static let VALIDATE_USER_EMAIL_EXISTS = "user_email_exists"
    static let VALIDATE_USER_PHONE_EXISTS = "user_phone_exists"
    
    static let WS_RESPONSE_ACTION_INVALID_SESSION = "invalid_session"
    
    //static let SCREEN_DEVICE_LIST = "SCREEN_DEVICE_LIST"
    static let SCREEN_DEVICE_CREATE = "SCREEN_DEVICE_CREATE"
    static let FUNC_DEVICE_GET = "FUNC_DEVICE_GET"
    static let FUNC_DEVICE_DELETE = "FUNC_DEVICE_DELETE"
    static let FUNC_COORDINATES_GET = "FUNC_COORDINATES_GET"
    static let SCREEN_DEVICE_REVIEW = "SCREEN_DEVICE_REVIEW"
    static let SCREEN_ECOMMERCE = "SCREEN_ECOMMERCE"
    static let FUNC_REPOR_INC = "FUNC_REPOR_INC"
    static let FUNC_CLOSE_INC = "FUNC_CLOSE_INC"
    static let SCREEN_REPOR_INC = "SCREEN_REPOR_INC"
    static let SCREEN_REPOR_INC_SIMPLE = "SCREEN_REPOR_INC_SIMPLE"
    static let SCREEN_REPOR_INC_SIMPLE_OP1 = "SCREEN_REPOR_INC_SIMPLE_OP1"
    static let SCREEN_ERROR = "ERROR"
    static let SCREEN_LINK_RESULT = "SCREEN_LINK_RESULT"
}
