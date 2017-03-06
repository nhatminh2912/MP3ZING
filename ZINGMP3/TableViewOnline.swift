//
//  TableViewOnline.swift
//  ZINGMP3
//
//  Created by Nhật Minh on 2/28/17.
//  Copyright © 2017 Nhật Minh. All rights reserved.
//

import UIKit

class TableViewOnline: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listSongs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
        
    }
    
    @IBOutlet weak var myTableView: UITableView!

    func getData()
    {
        let data = NSData(contentsOf: NSURL(string: "http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html") as! URL)
        let doc = TFHpple(htmlData: data as Data!)
        if let elements = doc?.search(withXPathQuery: "//h3[@class='title-item']/a") as? [TFHppleElement]
        {
            
            for element in elements
            {
                __dispatch_async(DispatchQueue.global() , {
                    let id  = self.getID(path: element.object(forKey: "href") as NSString)
                    let url = NSURL(string: "http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={\"id\":\"\(id)\"}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    var stringData = ""
                    do
                    {
                        stringData = try String(contentsOf: url! as URL)
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
                    let json = self.convertStringToDictionay(string: stringData)
                    if json != nil
                    {
                        self.addSongToList(json: json!)
                    }
                })
                
            }
        }
    }
    
    func getID(path: NSString) -> String
    {
        let id = (path.lastPathComponent as NSString).deletingPathExtension
        return id
    }
    
    func convertStringToDictionay(string: String) -> [String: AnyObject]?
    {
        if let data = string.data(using: String.Encoding.utf8)
        {
            do
            {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers ) as? [String: AnyObject]
                return json
            }
            catch
            {
                print("Ahaha")
            }
        }
        return nil
    }
    
    
    func addSongToList(json: [String: AnyObject])
    {
        let title = json["title"] as! String
        let artistName = json["artist"] as! String
        let thumbnail = json["thumbnail"] as! String
        let source = json["source"]!["320"] as! String
        
        let currentSong = Song(title: title, artistName: artistName, thumbnail: thumbnail, source: source)
        listSongs.append(currentSong)
        __dispatch_async(DispatchQueue.main, {
            self.myTableView.reloadData()
        })
    }
    
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = listSongs[indexPath.row].thumbnail
        cell.textLabel?.text = listSongs[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
