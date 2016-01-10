//
//  NetManager.swift
//  RSSReader
//
//  Created by Eugeniy Popov on 10.01.16.
//  Copyright © 2016 Eugeniy Popov. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class NetManager {
    
    static let sharedManager = NetManager()
    let lentaURL = "http://lenta.ru/rss"
    let gazetaURL = "http://www.gazeta.ru/export/rss/lenta.xml"
    
    func getDataFromNet() {
        
        for url in [lentaURL, gazetaURL] {
            print("getDataFromNet with \(url)")
            
            Alamofire.request(.GET, url)
                .response { (request, response, data, error) in
                    
                    if error == nil {
                        let xml = SWXMLHash.parse(data!)
                        
                        self.parseXmlToCoreData(xml)
                        
                        //print(xml)
                    } else {
                        print(error.debugDescription)
                    }
                    
                    CoreDataManager.sharedManager.contextSave()

            }
            
            
        }
        
        
    }
    
    func parseXmlToCoreData(xmlData:XMLIndexer) {
        
        do {
            let itemsList = try xmlData["rss"]["channel"].byKey(GC.xmlItemName)
            
            for element in itemsList {
                
                /*
                <guid>http://lenta.ru/news/2016/01/10/lyashko/</guid>
                <title>Ляшко рассказал о ностальгии по Крыму</title>
                <link>http://lenta.ru/news/2016/01/10/lyashko/</link>
                <description>
                Депутат Верховной Рады Олег Ляшко рассказал, что раньше был завсегдатаем грузинского ресторана в Ялте, где любил «по десять раз за вечер» заказывать песню «Тбилиси». По словам лидера Радикальной партии, он хотел бы вновь посетить Ялту в случае возвращения полуострова в состав Украины.
                </description>
                <pubDate>Sun, 10 Jan 2016 03:07:11 +0300</pubDate>
                <enclosure length="36584" url="http://icdn.lenta.ru/images/2016/01/10/03/20160110030529181/pic_05797d3f5318873a09a54feb92312ebf.jpg" type="image/jpeg"/>
                <category>Бывший СССР</category>
                
                
                <item>
                <title>Ким Чен Ын назвал ядерное испытание самозащитой против США</title>
                <link>http://www.gazeta.ru/politics/news/2016/01/10/n_8099891.shtml</link>
                <author>Газета.Ru</author>
                <pubDate>Sun, 10 Jan 2016 03:18:18 +0300</pubDate>
                <description>Лидер КНДР Ким Чен Ын назвал испытание водородной бомбы актом самозащиты против угрозы США, передает Reuters со ссылкой на северокорейское государственное информагентство ЦТАК.
                
                "Испытание водородной бомбы КНДР - это акт самозащиты, ...</description>
                <guid>http://www.gazeta.ru/politics/news/2016/01/10/n_8099891.shtml</guid>
                </item>
                */
                /*
                let link = item["link"].text
                let title = item.attributes["title"]
                let description = item.attributes["description"]
                let date = item.attributes["pubDate"]
                //  let link = item.attributes["link"]
                // let link = item.attributes["link"]
                
                */
                
                
                let link = try element.byKey("link").element?.text
                let title = try element.byKey("title").element?.text
                let description = try element.byKey("description").element?.text
                var imageUrl : String?
                do {
                    imageUrl = try element.byKey("enclosure").element?.attributes["url"]
                } catch {
                    
                }
                let source = xmlData["rss"]["channel"]["title"].element?.text
                
                let dateString = try element.byKey("pubDate").element?.text
                var pubDate = NSDate()
                
                if dateString != nil {
                    let dateFormatter = NSDateFormatter()
                    /* Sun, 10 Jan 2016 03:07:11 +0300*/
                    dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
                    
                    if let date = dateFormatter.dateFromString(dateString!) {
                        pubDate = date
                    }
                    
                    
                }
                
                
                CoreDataManager.sharedManager.addItemWith(title!, description: description!, imageUrl: imageUrl, date: pubDate, sourceTitle: source!, link: link!)
            }
            
            
        } catch {
            
        }
        
        
    }
    
    
    
}