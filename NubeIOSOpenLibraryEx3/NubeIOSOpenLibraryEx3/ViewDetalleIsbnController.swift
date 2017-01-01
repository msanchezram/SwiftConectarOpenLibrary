//
//  ViewDetalleIsbnController.swift
//  NubeIOSOpenLibraryEx3
//
//  Created by Marcos on 31/12/16.
//  Copyright © 2016 MSR. All rights reserved.
//

import UIKit

class ViewDetalleIsbnController: UIViewController {

    var isbnSearch = ""
    
    @IBOutlet weak var textTitulo: UILabel!
    
    @IBOutlet weak var textAutores: UITextView!
    
    @IBOutlet weak var imgURL: UIImageView!
    
    @IBOutlet weak var msgError: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print(isbnSearch)
        msgError.text=""
        procesarLibro()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func procesarLibro() {
        
        do {
            
            let info = sincrono()
            
            if (info == nil){
                msgError.text = "Error conexión Open Library"
                let alertController = UIAlertController(title: "Error", message:
                    "Ha habido un error con la conexión a Open Library, por favor vuélvalo a intentar más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }else {
                
                let texto =  NSString(data: info! as Data, encoding: String.Encoding.utf8.rawValue)
                
                
                
                if ((texto?.length)!>2){
                    //mapear resultado
                    
                    let json = try JSONSerialization.jsonObject(with: info! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    
                    let dic1 = json as! NSDictionary
                    let label = "ISBN:\(self.isbnSearch)"
                    
                    let dic2 = dic1[label] as! NSDictionary
                    
                    let titulo = dic2["title"] as! NSString as String
                    
                    self.textTitulo.text = titulo
                    
                    
                    let autores = dic2["authors"] as! NSArray as Array?
                    
                    if (autores != nil){
                        
                        //print(autores)
                        var autorObj : NSDictionary
                        var autor=""
                        
                        for index in 1...autores!.count {
                            autorObj = autores![index-1] as! NSDictionary
                            autor = autorObj["name"] as! NSString as String
                            //print(autor)
                            autor += "\n"
                            
                        }
                        if (autor != ""){
                            self.textAutores.text = autor
                        }
                    }else{
                        self.textAutores.text = "No hay autores"
                    }
                    
                    
                    
                    let dic3 = dic2["cover"] as! NSDictionary?
                    if (dic3 != nil) {
                        let tapaURL = dic3?["medium"] as! NSString? as String?
                        
                        if (tapaURL != nil){
                            print(tapaURL!)
                            cargaImage(urlString: tapaURL!)
                        }
                        
                    }else{
                        self.imgURL.image = nil
                    }
                }else{
                    //no existe
                    self.textTitulo.text = ""
                    self.textAutores.text = ""
                    self.imgURL.image = nil
                    self.msgError.text = "ISBN \(isbnSearch) no existe"
                }
            }
            
        }catch _ {
            print("Errores")
        }
        
        
    }
    
    func sincrono() -> NSData? {
        
        /*
         let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7"
         */
        
        let dirURL = isbnSearch
        
        print(dirURL)
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(dirURL)"
        print(urls)
        
        let url = NSURL(string: urls)
        
        let datos = NSData(contentsOf: url! as URL)
        
        
        return datos
        
        
    }
    
    func cargaImage(urlString:String)
    {
        let url = NSURL(string: urlString)
        let data = NSData(contentsOf:url! as URL)
        
        if (data?.length)! > 0 {
            imgURL.image = UIImage(data:data! as Data)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
