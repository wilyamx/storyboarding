//
//  UIImageView+WSR.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//
// https://www.advancedswift.com/download-and-cache-images-in-swift/

import UIKit

extension UIImageView {
    
    func download(
        url: URL,
        toFile file: URL,
        completion: @escaping (Error?) -> Void) {
            
        // Download the remote URL to a file
        let task = URLSession.shared.downloadTask(with: url) {
            (tempURL, response, error) in
            // Early exit on error
            guard let tempURL = tempURL else {
                completion(error)
                return
            }

            do {
                // Remove any existing document at file
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }

                // Copy the tempURL to file
                try FileManager.default.copyItem(
                    at: tempURL,
                    to: file
                )

                completion(nil)
            }

            // Handle potential file system errors
            catch(let error) {
                completion(error)
            }
        }

        // Start the download
        task.resume()
    }
    
    func loadDataFromTemporaryDirectory(
        urlText: String,
        placeholder: UIImage? = nil,
        completion: @escaping (Data?, Error?) -> Void) {
        
        if let placeholderImage = placeholder {
            self.image = placeholderImage
        }
        
        guard let url = URL(string: urlText) else {
            completion(nil, WSRFileURLLoaderError.url)
            logger.error(message: "Invalid url error! \(urlText)")
            return
        }
        
        // Compute a path to the URL in the cache
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                url.lastPathComponent,
                isDirectory: false
            )
        
        print("")
            
//        if let image = UIImage(data: data) {
//            completion(image, nil)
//            WSRImageCache.shared.set(image, forKey: urlText)
//
//            logger.log(category: .cache, message: urlText)
//            logger.cache(message: "Cache image \(urlText)")
//        }
//        else {
//            completion(nil, WSRFileURLLoaderError.data)
//            logger.error(message: "Corrupt data for \(urlText)")
//        }
            
        
        // If the image exists in the cache,
        // load the image from the cache and exit
//        if let data = Data(contentsOf: url) {
//            completion(data, nil)
//            return
//        }
//
//        // If the image does not exist in the cache,
//        // download the image to the cache
//        download(url: url, toFile: cachedFile) { (error) in
//            let data = Data(contentsOfFile: cachedFile.path)
//            completion(data, error)
//        }
    }
    
    //----
    
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
