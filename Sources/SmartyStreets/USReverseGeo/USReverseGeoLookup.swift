import Foundation

@objcMembers public class USReverseGeoLookup: NSObject, Codable {
    //    In addition to holding all of the input data for this lookup, this class also will contain the
    //    result of the lookup after it comes back from the API.
    //
    //    See "https://smartystreets.com/docs/cloud/us-reverse-geo-api"
    
    private var customParamArray: [String: String] = [:]
    public var latitude:String
    public var longitude:String
    public var source:String
    public var response:USReverseGeoResponse?
    
    public init(latitude:Double, longitude:Double, source:String) {
        self.latitude = String(format: "%.8f", latitude)
        self.longitude = String(format: "%.8f", longitude)
        self.source = source
    }
    
    public func getCustomParamArray() -> [String: String] {
        return self.customParamArray
    }
    
    public func addCustomParameter(parameter: String, value: String) {
        self.customParamArray.updateValue(value, forKey: parameter)
    }
}
