//
//  APICaller.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 14.12.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    
    private struct Constants {
        static let apiKey = "cltdekpr01qhnjgrifi0cltdekpr01qhnjgrifig"
        static let sandBoxApiKey = ""
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day : TimeInterval = 3600 * 24
    }
    
    private init (){
        
    }
    
    
    //Comment public
    public func search (
        query: String,
        completion : @escaping (Result<SearchRespons, Error>) -> Void ){
            guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else {return} //Comment safe query from spacing and other chatrcters
            request(url: url(for: .search, queryParams: ["q":safeQuery]),
                    expecting: SearchRespons.self,
                    completion: completion)
            
        }
    
    public func news(for type : NewsViewController.`Type`,completion : @escaping (Result<[NewsStory], Error>)->Void) {
        
        switch type {
        case .topStories:
            request(url: url(for: .topStories,
                             queryParams: ["category":"general"]),
                    expecting: [NewsStory].self,
                    completion: completion )
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            request(url: url(for: .companyNews,
                             queryParams: ["symbol": symbol,
                                           "from": DateFormatter.newDateFormatter.string(from: oneMonthBack),
                                           "to": DateFormatter.newDateFormatter.string(from: today)
                                          ]),
                    expecting: [NewsStory].self,
                    completion: completion )
            
        }
    }
    
    
    public func merketData(for symbol : String,
                           numberofDays : TimeInterval = 7,
                           completion : @escaping(Result<MarketDataResponse , Error>) -> Void
    ){
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberofDays))
        
        request(url:  url(for: .marketData,
                          queryParams: [
                            "symbol" : symbol,
                            "resolution" : "1",
                            "from": "\(Int(prior.timeIntervalSince1970))",
                            "to": "\(Int(today.timeIntervalSince1970))"
                                                        
                ]
            ),
                expecting: MarketDataResponse.self,
                completion: completion)
    }
    //Comment private
    
    
    private enum Endpoint : String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        
    }
    
    private enum APIError : Error {
        case NoDataReturn
        case invalidURL
    }
    private func url ( for endpoint : Endpoint , queryParams : [String : String] = [:])
    -> URL? {
        
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        
        for(key, value) in queryParams {
            queryItems.append(.init(name: key, value: value))
        }
        
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        let queryString = queryItems.map{"\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        urlString += "?" + queryString
        print("\n\(urlString)\n")
        return URL(string: urlString)
    }
    
    private func request<T : Codable> (url : URL?,
                                       expecting : T.Type,
                                       completion: @escaping (Result <T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,error == nil else {
                
                if let error = error {
                    completion(.failure(error))
                }else {
                    completion(.failure(APIError.NoDataReturn))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    } //Comment genetic request function
}
