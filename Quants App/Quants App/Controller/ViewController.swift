//
//  ViewController.swift
//  Quants App
//
//  Created by Mihir Solanki on 01/09/21.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    
    var dataArray: Data?
    
    @IBOutlet weak var cv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/gainer_loser.json"
        getData(from: url)
        
    }
    
   // MARK:- Call API
    
    private func getData(from url: String){
        
        guard let url = URL(string: "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/gainer_loser.json") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Data.self, from: data) {
                    
                    print(decodedResponse)
                    self.dataArray = decodedResponse
                    
                    DispatchQueue.main.async {
                        self.cv.reloadData()
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}

// MARK:- Delegeate & Datatsource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray == nil {
            return 0
        }else{
            return dataArray?.price_change.count ?? 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom", for: indexPath) as!
            custom
        cell.symbolLabel.text = (dataArray?.symbol[indexPath.row] )
        cell.priceLabel.text = (dataArray?.price[indexPath.row] )
        cell.changeLabel.text = (dataArray?.price_change[indexPath.row] )
        
        return cell
    }
}

// MARK:- Flowlayout

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  Int(((cv.frame.width - (2*10) ) / 3 ) )
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

// MARK:- Custom Collection View Cell

class custom: UICollectionViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
}
