//
//  ViewController.swift
//  PeticionOLibraryEx2
//
//  Created by Marcos on 22/12/16.
//  Copyright © 2016 MSR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textISBN: UITextField!
    
    @IBOutlet weak var textAutores: UITextView!
    
    
    @IBOutlet weak var textTitulo: UILabel!
    
    
    @IBOutlet weak var imgURL: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textTitulo.text=""
        self.textAutores.text=""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textISBNPrimaryActionTriggered(_ sender: UITextField) {
        
        self.procesarLibro()
        
    }
    func procesarLibro() {
        
        do {
            
        let info = sincrono()
        
            if (info == nil){
                //tv2Resultado.text = "Ha habido un error con la conexión a Open Library, por favor vuélvalo a intentar más tarde."
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
                    let label = "ISBN:\(self.textISBN.text!)"
                    
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
        
        let dirURL = textISBN.text
        
        print(dirURL!)
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(dirURL!)"
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

}

