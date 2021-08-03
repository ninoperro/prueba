import UIKit
import SwiftyJSON

private let itemsPerRow: CGFloat = 2

private let sectionInsets = UIEdgeInsets(
  top: 50.0,
  left: 20.0,
  bottom: 50.0,
  right: 20.0)

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard

    
    var json: JSON = JSON.null

    var favoritos = [Favorito]()
    var productos = [Producto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(white: 250.0 / 255.0, alpha: 1.0)

        
        parseFavoritos()
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // 1
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
      // 2
      let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // 3
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
      return sectionInsets
    }
    
    // 4
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
      return sectionInsets.left
    }
    
    //---------------------------------------------------------------
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.items.count
        return productos.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let producto = productos[indexPath.row]
        cell.myLabel.isHidden = true
        
        //cell.myLabel.textColor = UIColor.black
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let imageUrlString = producto.image
        let imageUrl:URL = URL(string: imageUrlString as! String)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        cell.myImage.image = UIImage(data: imageData as Data)
        
        //cell.imgPlus.image = UIImage(named: "ndIc30PlusSquare")
                
        let conditionType = producto.conditionType
        if(conditionType == "refurbished"){
            cell.imgRefur.image = UIImage(named: "ndIc30RefurbishedSquare")
        }
        
            
        let level = producto.linioPlusLevel
        if(level == 0){
            cell.imgPlus.isHidden = true
        }
                
        if(level == 1){
            cell.imgPlus.image = UIImage(named: "ndIc30PlusSquare")
        }
        
        if(level == 2){
            cell.imgPlus.image = UIImage(named: "ndIc30Plus48Square")
        }
        
        cell.imgInter.image = UIImage(named: "ndIc30InternationalSquare")
        let internacional = producto.imported
        if (internacional == 1) {
            cell.imgInter.isHidden = true
        }else{
            cell.imgInter.isHidden = false
        }
        
        cell.imgFreeShip.image = UIImage(named: "ndIc30FreeShippingSquare")
        let freeship = producto.freeShipping
        if (freeship == 1) {
            cell.imgFreeShip.isHidden = true
        }else{
            cell.imgFreeShip.isHidden = false
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    //----------------------------------------------
    
    func parseFavoritos() {
           
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

                           let iid = productoArray[index]["id"].intValue
                           let name = productoArray[index]["name"].stringValue
                           let wishListPrice = productoArray[index]["wishListPrice"].intValue
                           let slug = productoArray[index]["slug"].stringValue
                           let url = productoArray[index]["url"].stringValue
                           let imageURL = productoArray[index]["image"].stringValue
                           let linioPlusLevel = productoArray[index]["linioPlusLevel"].intValue
                           let conditionType = productoArray[index]["conditionType"].stringValue
                           
                           let freeShipping = productoArray[index]["freeShipping"].boolValue
                           let imported = productoArray[index]["imported"].boolValue
                           let active = productoArray[index]["active"].boolValue
                        
                           let _freeShipping = freeShipping ? 1 : 0
                           let _imported = imported ? 1 : 0
                           let _active = active ? 1 : 0
                        
                           let producto = Producto(active: _active, conditionType: conditionType, freeShipping: _freeShipping, id: iid, image: imageURL, imported: _imported, linioPlusLevel: linioPlusLevel, name: name, slug: slug, url: url, wishListPrice: wishListPrice)
                           productos.append(producto)
                                                   
                       }
                       
                   }

               } catch {
                   self.json = JSON.null
               }
           } else {
               self.json = JSON.null
           }
                           
           //self.tableView.reloadData()
        
       }
       
    
    
}

