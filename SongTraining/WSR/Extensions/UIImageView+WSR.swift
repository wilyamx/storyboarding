//
//  UIImageView+WSR.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//
// https://www.advancedswift.com/download-and-cache-images-in-swift/

import UIKit

extension UIImageView {
    
    func loadData(urlText: String,
                  placeholder: UIImage? = nil,
                  completion: @escaping (UIImage?, Error?) -> Void) {
        
        if let placeholderImage = placeholder {
            self.image = placeholderImage
        }
        
        if let cachedImage = WSRImageCache.shared.get(forKey: urlText) {
            completion(cachedImage, nil)
            logger.cache(message: "Retrieve cached image \(urlText)")
            return
        }
        
        guard let url = URL(string: urlText) else {
            completion(nil, WSRFileURLLoaderError.url)
            logger.error(message: "Invalid url error! \(urlText)")
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil, WSRFileURLLoaderError.url)
                logger.error(message: "Request error! \(urlText)")
                return
            }

            if let image = UIImage(data: data) {
                completion(image, nil)
                WSRImageCache.shared.set(image, forKey: urlText)
                
                logger.log(category: .cache, message: urlText)
                logger.cache(message: "Cache image \(urlText)")
            }
            else {
                completion(nil, WSRFileURLLoaderError.data)
                logger.error(message: "Corrupt data for \(urlText)")
            }
        }
        
        task.resume()
    
    }
    
    func unloadData(urlText: String) {
        if let _ = WSRImageCache.shared.get(forKey: urlText) {
            WSRImageCache.shared.remove(forKey: urlText)
            logger.info(message: "Image remove from cache \(urlText)")
        }
    }
}
