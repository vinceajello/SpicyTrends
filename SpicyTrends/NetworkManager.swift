//
//  NetworkManager.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 27/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit





struct GetTrendsResponse:Codable
{
    let status:Int
    let data:[Trend]
}





struct GetDescriptionsResponse:Codable
{
    let status:Int
    let data:DescriptionData
}

struct DescriptionData:Codable
{
    let wiki:String
    let news:NewsObject
}

struct NewsObject:Codable
{
    let message:String
    let news:[News]
}

struct News:Codable
{
    let image:String?
    let news_source:String
    let short_story:String
    let title:String
}



struct GetTweetsResponse:Codable
{
    let status:Int
    let data:TwitterResponse
}

struct TwitterResponse:Codable
{
    let statuses:[TweetData]
}

struct TweetData:Codable
{
    let created_at:String
    let entities:TwitterEntity
    let favorite_count:Int
    let text:String
    let user:TwitterUserData
}
struct TwitterUserData:Codable
{
    let name:String
}

struct TwitterEntity:Codable
{
    let hashtags:[TwitterHashtag]
}

struct TwitterHashtag:Codable
{
    let text:String
}



struct WikiImageResponse:Codable
{
    let status:Int
    let data:String
}



struct SuggestedKeywordsResponse:Codable
{
    let status:Int
    let data:[String]
}






class NetworkManager: NSObject
{
    private let base_endpoint = "https://api.spicytrends.app/api/"
    private let requests_timeout = 10.0
    
    func getGTrends(region:String, completionHandler: @escaping (Bool, [Trend]) -> Void)
    {
        print("Get G Trends by Region : \(region)")
        
        // create and assign parameters
        var parameters:[String:String] = [:]
        parameters["region"] = "\(region)"
        
        // build URL from parameters
        let query = createURL(endpoint: "topTrendsByCountry", parameters: parameters)
        
        // init the request
        let request = URLRequest(url: query.url!)
        
        // init the session
        let session = createSession()
 
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) in
            
            guard error == nil else
            {
                print("NetworkError: \(error!)")
                completionHandler(false,[])
                return
            }
            
            guard let responseData = data else
            {
                print("NetworkError: NO responseData!")
                completionHandler(false,[])
                return
            }
            
            // used to print json data
            //self.debugPrint(data: responseData)
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async
            {
                do
                {
                    let response = try decoder.decode(GetTrendsResponse.self, from: responseData)
                    if response.status == 200
                    {
                        completionHandler(true, response.data)
                        return;
                    }
                    print("Error: Status code Wrong!")
                    completionHandler(false, [])
                    return
                }
                catch
                {
                    print("Error: Unable to convert data to JSON")
                    completionHandler(false,[])
                    return
                }
            }
        })
        task.resume()
    }
    
    
    
    
    
    
    
    func getDescriptionByKeyword(word:String, completionHandler: @escaping (Bool,DescriptionData?) -> Void)
    {
        print("Getting Description from by Keyword : \(word)")
        
        // create and assign parameters
        var parameters:[String:String] = [:]
        parameters["word"] = "\(word)"
        
        // build URL from parameters
        let query = createURL(endpoint: "getDescriptionByKeyword", parameters: parameters)
        
        // init the request
        let request = URLRequest(url: query.url!)
        
        // init the session
        let session = createSession()
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) in
            
            guard error == nil else
            {
                print("NetworkError: \(error!)")
                completionHandler(false,nil)
                return
            }
            guard let responseData = data else
            {
                print("NetworkError: NO responseData!")
                completionHandler(false, nil)
                return
            }
            
            // used to print json data
            //self.debugPrint(data: responseData)
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async
            {
                do
                {
                    let response = try decoder.decode(GetDescriptionsResponse.self, from: responseData)
                    if response.status == 200
                    {
                        completionHandler(true,response.data)
                        return;
                    }
                    print("Error: Status code Wrong!")
                    completionHandler(false,nil)
                    return
                }
                catch
                {
                    print("Error: Unable to convert data to JSON")
                    completionHandler(false, nil)
                }
            }
        })
        task.resume()
    }
    
    func getTweets(word:String, region:String, completionHandler: @escaping ([TweetData]?, Error?) -> Void)
    {
        // create and assign parameters
        var parameters:[String:String] = [:]
        parameters["word"] = "\(word)"
        parameters["region"] = "\(region)"

        // set the endpoint
        var components = URLComponents(string: base_endpoint+"searchTweets")!
        
        // urlencode the perameters
        components.queryItems = parameters.map {(key, value) in URLQueryItem(name: key, value: value)}
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        // init the request
        let request = URLRequest(url: components.url!)
        
        // init the session
        let session = createSession()
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) in
            
            guard error == nil else
            {
                completionHandler(nil, error)
                return
            }
            guard let responseData = data else
            {
                completionHandler(nil, error)
                return
            }
            
            // used to print json data
            //self.debugPrint(data: responseData)
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async
                {
                    do
                    {
                        let response = try decoder.decode(GetTweetsResponse.self, from: responseData)
                        if response.status == 200
                        {
                            completionHandler(response.data.statuses, nil)
                            return;
                        }
                        completionHandler(nil, nil)
                        return
                    }
                    catch
                    {
                        print("error converting data to JSON")
                        completionHandler(nil, error)
                    }
            }
            
        })
        task.resume()
    }
    
    func getImage(word:String, completionHandler: @escaping (Bool, String) -> Void)
    {
        // create and assign parameters
        var parameters:[String:String] = [:]
        parameters["word"] = "\(word)"
        
        // build URL from parameters
        let query = createURL(endpoint: "getImageByKeyword", parameters: parameters)
        
        // init the request
        let request = URLRequest(url: query.url!)
        
        // init the session
        let session = createSession()
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) in
            
            guard error == nil else
            {
                completionHandler(false, error.debugDescription)
                return
            }
            guard let responseData = data else
            {
                completionHandler(false, "NetworkError: NO responseData!")
                return
            }
            
            // used to print json data
            self.debugPrint(data: responseData)
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async
            {
                do
                {
                    let response = try decoder.decode(WikiImageResponse.self, from: responseData)
                    if response.status == 200
                    {
                        completionHandler(true, response.data)
                        return;
                    }
                    completionHandler(false, "Error: Status code Wrong!")
                    return
                }
                catch
                {
                    print("error converting data to JSON")
                    completionHandler(false, "Error: Unable to convert data to JSON")
                }
            }
        })
        task.resume()
    }
    
    
    
    
    
    func getSuggestionsByKeyword(word:String, completionHandler: @escaping (Bool, String) -> Void)
    {
        // create and assign parameters
        var parameters:[String:String] = [:]
        parameters["word"] = "\(word)"
        
        // build URL from parameters
        let query = createURL(endpoint: "getSuggetionsByWord", parameters: parameters)
        
        // init the request
        let request = URLRequest(url: query.url!)
        
        // init the session
        let session = createSession()
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) in
            
            guard error == nil ,let responseData = data else
            {completionHandler(false, "no response data");return}
            
            // used to print json data
            // self.debugPrint(data: responseData)
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async
            {
                do
                {
                    let response = try decoder.decode(SuggestedKeywordsResponse.self, from: responseData)
                    if response.status == 200
                    {
                        completionHandler(true, response.data.joined(separator: ", "))
                        return;
                    }
                    completionHandler(false, "Status != 200")
                    return
                }
                catch
                {completionHandler(false, "error converting data to JSON")}
            }
        })
        task.resume()
    }
    
    
    
    
    

    func getNewsByKeyword(word:String, completionHandler: @escaping (Bool, String?) -> Void)
    {
        // create and assign parameters
        var parameters:[String:String] = [:]
        parameters["word"] = "\(word)"
        
        // build URL from parameters
        let query = createURL(endpoint: "getNewsByWord", parameters: parameters)
        
        // init the request
        let request = URLRequest(url: query.url!)
        
        // init the session
        let session = createSession()
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) in
            
            guard error == nil ,let responseData = data else
            {completionHandler(false, nil);return}
            
            // used to print json data
            // self.debugPrint(data: responseData)
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async
                {
                    do
                    {
                        let response = try decoder.decode(SuggestedKeywordsResponse.self, from: responseData)
                        if response.status == 200
                        {
                            completionHandler(true,"news")
                            return;
                        }
                        completionHandler(false, nil)
                        return
                    }
                    catch
                    {completionHandler(false, nil)}
            }
        })
        task.resume()
    }
    
    
    
    
    
    
    
    
}

//
// MARK: Utility
//

extension NetworkManager
{
    public func createSession()->URLSession
    {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = requests_timeout
        sessionConfig.timeoutIntervalForResource = requests_timeout
        return URLSession.init(configuration: sessionConfig)
    }
    
    public func createURL(endpoint:String,parameters:[String:String])->URLComponents
    {
        var url = URLComponents.init(string: base_endpoint+endpoint)!
        url.queryItems = parameters.map {(key, value) in URLQueryItem(name: key, value: value)}
        url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return url
    }
}

//
// MARK: Debug
//

extension NetworkManager
{
    func debugPrint(data:Data)
    {do{if let todoJSON = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
    {print(todoJSON)}} catch{print("couldn't create object from the JSON");return}}
}


