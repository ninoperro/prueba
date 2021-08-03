import Foundation

struct Favorito: Codable {
    
    var id: Int
    var name: String
    var description: String
    var createdAt: String
    var visibility: String
}

struct Owner: Decodable {
    var name: String
    var email: String
    var linioId: String
}

struct Producto: Codable {
   var active: Int
   var conditionType: String
   var freeShipping: Int
   var id: Int
   var image: String
   var imported: Int
   var linioPlusLevel: Int
   var name: String
   var slug: String
   var url: String
   var wishListPrice: Int   
}
