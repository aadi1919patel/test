
import Foundation

class Person
{
    var title: String = ""
    var category: String = ""
    var Price: String = ""
    var inStock: Int = 0
    var imageCategory: String = ""
    
    init( title:String, category:String, Price:String, inStock:Int,imageCategory:String)
    {
        self.title = title
        self.category = category
        self.Price = Price
        self.inStock = inStock
        self.imageCategory = imageCategory
    }
    
}
