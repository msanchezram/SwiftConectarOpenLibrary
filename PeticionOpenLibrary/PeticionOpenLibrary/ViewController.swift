//
//  ViewController.swift
//  PeticionOpenLibrary
//
//  Created by Marcos on 18/12/16.
//  Copyright © 2016 MSR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tIsbn: UITextField!
/*
    @IBOutlet weak var tvResultado: UITextView!
  */
    @IBOutlet weak var tv2Resultado: UITextView!
/*
    @IBOutlet weak var indCarga: UIActivityIndicatorView!
  */
    
    @IBOutlet weak var ind2Carga: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushEnterTIsbn(_ sender: Any) {
        //indCarga.startAnimating()
        //print("Has pulsado Enter")
        //ind2Carga.startAnimating()
        sincrono()
        //indCarga.stopAnimating()
    }
    

    @IBAction func pushBuscar(_ sender: Any) {
        
        sincrono()
        //ind2Carga.stopAnimating()
    }
    
    func sincrono() {
        
        /*
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7"
        */
      
        let dirURL = tIsbn.text
        
        //print(dirURL!)
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(dirURL!)"
        print(urls)
        let url = NSURL(string: urls)
        
        let datos:NSData? = NSData(contentsOf: url! as URL)
        
        let texto = NSString(data:datos! as Data, encoding: String.Encoding.utf8.rawValue)
        //print(texto!)

        if ((texto?.length)!>2){
            tv2Resultado.text = texto as String!
        }else{
            tv2Resultado.text="No hay datos de este libro"
        }
        
    }

}

