import UIKit
import SwiftyJSON


class FavoritesTableViewController: UITableViewController {

    var json: JSON = JSON.null

    var favoritos = [Favorito]()
    var productos = [Producto]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parseFavoritos()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return countries.count
        return productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        
        let producto = productos[indexPath.row]
        cell.textLabel?.text = producto.name
        cell.detailTextLabel?.text = producto.conditionType
        //cell.imageView?.image = UIImage(named: producto.image)
        
        let imageUrlString = producto.image
        let imageUrl:URL = URL(string: imageUrlString as! String)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        cell.imageView?.image = UIImage(data: imageData as Data)
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }

    //----------------------------------------------------------------------------------
    
    func parseFavoritos() {
        let url = Bundle.main.url(forResource:"favorites", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        self.favoritos = try! JSONDecoder().decode([Favorito].self, from: jsonData)
        /*------------------------------------------------------------------------*/
        
        if let file = Bundle.main.path(forResource: "favorites", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: file))
                let json = try JSON(data: data)
                self.json = json
                
                
                let favoritoArray = self.json[].arrayValue
                for aFavorito in favoritoArray {
                    //print(aFavorito["description"].stringValue)
                    
                    let productoArray = aFavorito["products"]
                    for (index,subJson):(String, JSON) in productoArray {
                        // Do something you want
                        //print( productoArray[index]["name"] )
                        //print( productoArray[index]["image"] )
                        
                        let iid = productoArray[index]["id"].intValue
                        let name = productoArray[index]["name"].stringValue
                        let imageURL = productoArray[index]["image"].stringValue
                        let conditionType = productoArray[index]["conditionType"].stringValue
                        
                        let producto = Producto(active: 1, conditionType: conditionType, freeShipping: 1, id: iid, image: imageURL, imported: 1, linioPlusLevel: 1, name: name, slug: "xxx", url: "yyy", wishListPrice: 1)
                        productos.append(producto)
                        
                        
                    }
                    
//                    let productoArray = aFavorito["products"].arrayValue
//                    for aProducto in productoArray {
//
//
//                      let iid = aProducto["id"].intValue
//                       let name = aProducto["name"].stringValue
//                       let imageURL = aProducto["image"].stringValue
//                       let conditionType = aProducto["conditionType"].stringValue
//
//                        let producto = Producto(active: 1, conditionType: conditionType, freeShipping: 1, id: iid, image: imageURL, imported: 1, linioPlusLevel: 1, name: name, slug: "xxx", url: "yyy", wishListPrice: 1)
//                        productos.append(producto)
//                    }
                }
                
                

                
                
                
            } catch {
                self.json = JSON.null
            }
        } else {
            self.json = JSON.null
        }
        
        
        
        
        self.tableView.reloadData()
    }
    
    
}
