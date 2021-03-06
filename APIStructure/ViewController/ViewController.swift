//
//  ViewController.swift
//  APIStructure
//
//  Created by Adi Patel on 28/02/21.
//

import UIKit
import SQLite.Swift
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    var persons:[Person] = []
    
    var db:DBHelper = DBHelper()
 
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitialViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK:- IBActions
    @IBAction func btnMenuTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let vc = AddDocumentVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    //MARK:- Functions
    func setupInitialViews() {
        
        let imgLogo = #imageLiteral(resourceName: "Logo")

        
        let imageData = imgLogo.pngData()
        //Use image name from bundle to create NSData
        let image : UIImage = imgLogo
        //Now use image to create into NSData format
        let imageData1:NSData = image.pngData()! as NSData
        let strBase64 = imageData1.base64EncodedString(options: .lineLength64Characters)
        print(strBase64)
//        guard let data2 = imgLogo.toData(options: options, type: .png) else { return }
       // printSize(of: data2)
        
      //  db.insert(title: "Aditya", category: "Shark1", Price: "50", inStock: 0, imageCategory: strBase64)
        persons = db.read()
        print(persons)
        self.GetCategory()
    }


}

extension ViewController{
    
   
    
    func GetCategory() {
        
        WebServices().CallGlobalAPIForm(url: Constant.GetCategoriesList, headers: [:], parameters: "", httpMethod: "GET", progressView: true, uiView: self.view, networkAlert: true) { (responseJSON, errorMessage) in
            
            print(responseJSON)
                        
            print(errorMessage)

            do {
                SVProgressHUD.dismiss()
                
        
               // let dict_data = responseJSON.value as? NSDictionary ?? [:]
                let dataArray = try JSONDecoder().decode(Welcome.self,from: responseJSON as! Data)
               //let dataArray  = responseJSON.value(forKey: "categories") as? NSArray ?? []
                           
            print(dataArray)
                       
                
            } catch {
                
                SVProgressHUD.dismiss()

                Utils.Toast(message: error.localizedDescription, controller: self)
            }
            
        }
        
    }
}
extension UIImage {

    // UIImage to Data (PNG Representation)
    var PNGData: Data? {
        return self.pngData()
    }
}
