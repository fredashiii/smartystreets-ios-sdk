import XCTest
@testable import SmartyStreets

class InternationalStreetClientTests: XCTestCase {
    
    var error:NSError!
    
    override func setUp() {
        super.setUp()
        self.error = nil
    }
    
    override func tearDown() {
        super.tearDown()
        self.error = nil
    }
    
    func testSendingFreeformLookup() {
        let capturingSender = RequestCapturingSender()
        let sender = URLPrefixSender(urlPrefix: "http://localhost/", inner: capturingSender)
        let serializer = InternationalStreetSerializer()
        let client = InternationalStreetClient(sender: sender, serializer: serializer)
        var lookup = InternationalStreetLookup(freeform:"freeform", country:"USA", inputId: nil)
        
        _ = client.sendLookup(lookup:&lookup, error:&self.error)
        
        let url = capturingSender.request.getUrl()
        
        XCTAssertNil(self.error)
        XCTAssertTrue(url.contains("http://localhost/?"))
        XCTAssertTrue(url.contains("country=USA"))
        XCTAssertTrue(url.contains("freeform=freeform"))
    }
    
    func testSendingSingleFullyPopulatedLookup() {
        let capturingSender = RequestCapturingSender()
        let sender = URLPrefixSender(urlPrefix: "http://localhost/", inner: capturingSender)
        let serializer = InternationalStreetSerializer()
        let client = InternationalStreetClient(sender: sender, serializer: serializer)
        var lookup = InternationalStreetLookup(freeform: "freeform", country: "USA", inputId: nil)
        
        lookup.country = "0"
        lookup.enableGeocode(geocode: true)
        lookup.language = LanguageMode(name: "native")
        lookup.freeform = "1"
        lookup.address1 = "2"
        lookup.address2 = "3"
        lookup.address3 = "4"
        lookup.address4 = "5"
        lookup.organization = "6"
        lookup.locality = "7"
        lookup.administrativeArea = "8"
        lookup.postalCode = "9"
        lookup.addCustomParameter(parameter: "custom", value: "10")
        
        _ = client.sendLookup(lookup: &lookup, error: &self.error)
        
        XCTAssertNil(self.error)
        XCTAssertNotNil(capturingSender.request.getUrl())
        XCTAssertEqual("0" , capturingSender.request.parameters["country"])
        XCTAssertEqual("1" , capturingSender.request.parameters["freeform"])
        XCTAssertEqual("2" , capturingSender.request.parameters["address1"])
        XCTAssertEqual("3" , capturingSender.request.parameters["address2"])
        XCTAssertEqual("4" , capturingSender.request.parameters["address3"])
        XCTAssertEqual("5" , capturingSender.request.parameters["address4"])
        XCTAssertEqual("6" , capturingSender.request.parameters["organization"])
        XCTAssertEqual("7" , capturingSender.request.parameters["locality"])
        XCTAssertEqual("8" , capturingSender.request.parameters["administrative_area"])
        XCTAssertEqual("9" , capturingSender.request.parameters["postal_code"])
        XCTAssertEqual("10" , capturingSender.request.parameters["custom"])
    }
    
    func testEmptyLookupRejected() {
        var lookup = InternationalStreetLookup()
        assertLookupRejected(lookup: &lookup)
    }
    
    func testRejectsLookupWithOnlyCountry() {
        var lookup = InternationalStreetLookup()
        lookup.country = "0"
        assertLookupRejected(lookup: &lookup)
    }
    
    func testRejectsLookupsWithOnlyCountryAndAddress1() {
        var lookup = InternationalStreetLookup()
        lookup.country = "0"
        lookup.address1 = "1"
        assertLookupRejected(lookup: &lookup)
    }
    
    func testRejectsLookupsWithOnlycountryAndAddress1AndLocality() {
        var lookup = InternationalStreetLookup()
        lookup.country = "0"
        lookup.address1 = "1"
        lookup.locality = "2"
        assertLookupRejected(lookup: &lookup)
    }
    
    func testRejectsLookupsWithOnlyCountryAndAddress1AndAdministrativeArea() {
        var lookup = InternationalStreetLookup()
        lookup.country = "0"
        lookup.address1 = "1"
        lookup.administrativeArea = "2"
        assertLookupRejected(lookup: &lookup)
    }
    
    func testAcceptsLookupsWithEnoughInfo() {
        let sender = RequestCapturingSender()
        let serializer = InternationalStreetSerializer()
        let client = InternationalStreetClient(sender: sender, serializer: serializer)
        var lookup = InternationalStreetLookup()
        
        lookup.country = "0"
        lookup.freeform = "1"
        _ = client.sendLookup(lookup: &lookup, error: &self.error)
        
        lookup.freeform = nil
        lookup.address1 = "1"
        lookup.postalCode = "2"
        _ = client.sendLookup(lookup: &lookup, error: &self.error)
        
        lookup.postalCode = nil
        lookup.locality = "3"
        lookup.administrativeArea = "4"
        _ = client.sendLookup(lookup: &lookup, error: &self.error)
        
        XCTAssertNil(error)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    func assertLookupRejected(lookup: inout InternationalStreetLookup) {
        let sender = MockSender()
        let client = InternationalStreetClient(sender: sender, serializer: InternationalStreetSerializer())
        
        _ = client.sendLookup(lookup: &lookup, error: &self.error)
        XCTAssertNotNil(self.error)
    }
}
