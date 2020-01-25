import UIKit

public class Constants {
    
    /* Dating App App Configuration */
    
    static let arEnableLog = true
    
    static let bEnableMockupGPS: Bool = true
    static let test_latitude: Double = 46.372178
    static let test_longitude: Double = -104.739706
}

struct AnnotationViewType {
    static let CUSTOMER             = "EMAnnotationViewCustomer"
    static let DRIVER               = "EMAnnotationViewDriver"
    static let PESG                 = "EMAnnotationPESG"
}

struct CompanyInfoKey {
    static let id                   = "id"
    static let username             = "username"
    static let password             = "password"
    static let email                = "email"
    static let businessName         = "business_name"
    static let businessAddress      = "business_address"
    static let businessLogo         = "business_logo"
    static let businessDescription  = "business_description"
    static let serviceType          = "service_type"
    static let gisPosition          = "gis_position"
}

struct DriverInfoKey {
    static let id                   = "id"
    static let fullName             = "fullname"
    static let phoneNumber          = "phonenumber"
    static let avatar               = "avatar"
    static let userName             = "username"
    static let badgeNumber          = "badgenumber"
    static let pinCode              = "pincode"
    static let latitude             = "latitude"
    static let longitude            = "longitude"
}

struct RouterInfoKey {
    static let id                   = "id"
    static let address              = "address"
    static let phonenumber          = "phonenumber"
    static let routeID              = "routeid"
    static let driverID             = "driverid"
    static let state                = "state"
    static let estimateTime         = "estimated_time"
    static let time                 = "time"
    static let assignedTime         = "assigned_time"
    static let arrivedTime          = "arrived_time"
    static let userName             = "username"
}

struct API {
    static let getCompanyInfo       = "get_company_info.php"
    static let getDriverInfo        = "get_driver_info.php"
    static let saveDriverInfo       = "save_driver_info.php"
    static let getRoutesForDriver   = "get_routes_for_driver.php"
    static let saveDriverLocation   = "save_driver_latlng.php"
    static let sendLeftToRoute      = "send_left_to_route.php"
    static let sendCompleteDriver   = "send_completed_driver.php"
    static let sendFeedBack         = "send_feedback.php"
}

let DRIVERSPEED                     = 50.3

let BASE_URL                        = "https://app.expectmenow.com/assets/php/restapi"
let IMAGE_URL                       = "https://app.expectmenow.com/images/"

let GOOLEMAPAPIKEY                  = "AIzaSyD44CNasEYY0UGuWfEZ1e14v3LIb6buDxQ"
