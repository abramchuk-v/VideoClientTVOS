//
// HCVimeoVideoExtractor.swift
// HCVimeoVideoExtractor
//
// Created by Mo Cariaga on 13/02/2018.
// Copyright (c) 2018 Mo Cariaga <hermoso.cariaga@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

public class HCVimeoVideoExtractor: NSObject {
    fileprivate let domain = "ph.hercsoft.HCVimeoVideoExtractor"
    fileprivate let configURL = "https://player.vimeo.com/video/{id}/config"
    fileprivate var completion: ((Swift.Result<[VimeoVideoQuality: URL], AppError>) -> Void)?
    fileprivate var videoId: String = ""
    
    
    static func fetchVideoURLFrom(url: URL, completion: @escaping (Swift.Result<[VimeoVideoQuality: URL], AppError>) -> Void) -> Void {
        let videoId = url.lastPathComponent
        if videoId != "" {
            let videoExtractor = HCVimeoVideoExtractor(id: videoId)
            videoExtractor.completion = completion
            videoExtractor.start()
        }
        else {
            completion(.failure(.parsing(message: "Invalid video ID: \(videoId)")))
        }
    }
    
    static func fetchVideoURLFrom(id: String, completion: @escaping (Swift.Result<[VimeoVideoQuality: URL], AppError>) -> Void) -> Void {
        if id != "" {
            let videoExtractor = HCVimeoVideoExtractor(id: id)
            videoExtractor.completion = completion
            videoExtractor.start()
        }
        else {
            completion(.failure(.parsing(message: "Invalid video ID: \(id)")))
        }
    }
    
    private init(id: String) {
        self.videoId = id
        self.completion = nil
        super.init()
    }
    
    private func start() -> Void {
        
        guard let completion = self.completion else {
            print("ERROR: Invalid completion handler")
            return
        }
        
        if self.videoId == "" {
            completion(.failure(.parsing(message: "Invalid video ID: \(videoId)")))
            return
        }
        
        let dataURL = self.configURL.replacingOccurrences(of: "{id}", with: self.videoId)
        if let url = URL(string: dataURL) {
            let urlRequest = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                if let err = error {
                    completion(.failure(.request(err: err)))
                    return
                }
                
                guard let responseData = data else {
                    completion(.failure(.response(message: "Invalid response from Vimeo")))
                    return
                }
                
                do {
                    guard let data = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                        completion(.failure(.parsing(message: "Failed to parse Vimeo response")))
                        return
                    }
                    
                    if let files = (data as NSDictionary).value(forKeyPath: "request.files.progressive") as? Array<Dictionary<String,Any>> {
                        
                        var videoURL = [VimeoVideoQuality: URL]()
                        
                        for file in files {
                            if let quality = file["quality"] as? String {
                                if let url = file["url"] as? String {
                                    videoURL[self.videoQualityWith(string: quality)] = URL(string: url)
                                }
                            }
                        }
                        
                        if videoURL.count > 0 {
                            completion(.success(videoURL))
                        }
                        else {
                            completion(.failure(.parsing(message: "Failed to parse Vimeo response")))
                        }
                    }
                    else {
                        completion(.failure(.mp4))
                    }
                } catch  {
                    completion(.failure(.parsing(message: "Failed to parse Vimeo response")))
                    return
                }
            })
            task.resume()
        }
        else {
            completion(.failure(.parsing(message: "Failed to retrieve video URL")))
        }
    }
 
    private func videoQualityWith(string: String) -> VimeoVideoQuality {
        if string == "360p" {
            return .Quality360p
        }
        else if string == "540p" {
            return .Quality540p
        }
        else if string == "640p" {
            return .Quality640p
        }
        else if string == "720p" {
            return .Quality720p
        }
        else if string == "960p" {
            return .Quality960p
        }
        else if string == "1080p" {
            return .Quality1080p
        }
        
        return .QualityUnknown
    }
}
