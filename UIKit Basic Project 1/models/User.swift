
import Foundation



struct User: Codable {
    
    var id: Int
    var username: String
    var name: String
    var email: String
    var website: String
    var phone: String
    var company: Company
    var address: Address
    
}

 struct Company: Codable {
    var name: String
}

 struct Address: Codable {
    var geo: Geo
    var city: String
}

 struct Geo: Codable {
    var lat: String
    var lng: String
}
