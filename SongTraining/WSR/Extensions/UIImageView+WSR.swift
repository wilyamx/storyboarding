//
//  UIImageView+WSR.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//
// https://www.advancedswift.com/download-and-cache-images-in-swift/

import UIKit
import WSRUtils
import WSRMedia

extension UIImageView {
    
    func download(
        url: URL,
        toFile file: URL,
        completion: @escaping (Data?, Error?) -> Void) {
            
        wsrLogger.cache(message: "Downloading \(url)")
        wsrLogger.cache(message: "Target Directory: \(file)")
            
//        if FileManager.default.fileExists(atPath: file.path) {
//            logger.cache(message: "File exist in directory: \(file.path)")
//
//            let fileUrl = URL(filePath: "\(file.path)/CFNetworkDownload_W8AaIr.tmp")
//            let data = try! Data(contentsOf: fileUrl)
//            let image = UIImage(data: da)
//            completion(data, nil)
//            return
//        }
            
        // Download the remote URL to a file
        let task = URLSession.shared.downloadTask(with: url) {
            (tempURL, response, error) in
        
            // Early exit on error
            guard let tempURL = tempURL else {
                completion(nil, error)
                return
            }
            wsrLogger.cache(message: "tempURL: \(tempURL)")
            
            do {
                // Remove any existing document at file
            
                // Copy the tempURL to file
//                try FileManager.default.copyItem(
//                    at: tempURL,
//                    to: file
//                )

                let data = try Data(contentsOf: tempURL)
                completion(data, nil)
            }

            // Handle potential file system errors
            catch(let error) {
                completion(nil, error)
                wsrLogger.error(message: "\(error)")
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
            wsrLogger.error(message: "Invalid url error! \(urlText)")
            return
        }
        
        // Compute a path to the URL in the cache
        let fileManager = FileManager.default
        let temporaryDirectory = fileManager.temporaryDirectory
        let imagePath = temporaryDirectory.appendingPathComponent(
            url.lastPathComponent,
            isDirectory: false
        )
        let fileExist = fileManager.fileExists( atPath: urlText)
            
        wsrLogger.info(message: "fileCachePath: \(imagePath), isExist: \(fileExist)")
            
        if fileExist {
            
        }
        else {
            download(url: url, toFile: temporaryDirectory) { data, error in
                completion(data, error)
            }
        }
        
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
            wsrLogger.cache(message: "Retrieve cached image \(urlText)")
            return
        }
        
        guard let url = URL(string: urlText) else {
            completion(nil, WSRFileURLLoaderError.url)
            wsrLogger.error(message: "Invalid url error! \(urlText)")
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil, WSRFileURLLoaderError.url)
                wsrLogger.error(message: "Request error! \(urlText)")
                return
            }

            if let image = UIImage(data: data) {
                completion(image, nil)
                WSRImageCache.shared.set(image, forKey: urlText)
                
                wsrLogger.log(category: .cache, message: urlText)
                wsrLogger.cache(message: "Cache image \(urlText)")
            }
            else {
                completion(nil, WSRFileURLLoaderError.data)
                wsrLogger.error(message: "Corrupt data for \(urlText)")
            }
        }
        
        task.resume()
    
    }
    
    func unloadData(urlText: String) {
        if let _ = WSRImageCache.shared.get(forKey: urlText) {
            WSRImageCache.shared.remove(forKey: urlText)
            wsrLogger.info(message: "Image remove from cache \(urlText)")
        }
    }
}
