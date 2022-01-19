//
//  GifsApi.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//


import Foundation
import RxAlamofire
import RxSwift

class GifsApi: BaseApi {
    
    private static let apiUrl = "/gifs"
    
    static func fetchGIFs(
        query: String,
        offset: Int,
        limit: Int
    ) -> Observable<Data> {
        let requestUrl = getBaseURL() + apiUrl + "/search"
        
        let params = [
            "api_key" : "pqn33ek8y47re7L2D7iOKezhOgf5Ghkl",
            "limit" : limit,
            "offset" : offset,
            "q" : query
        ] as [String : Any]
        
        return RxAlamofire.data(.get, requestUrl, parameters: params)
    }
    
    static func fetchTrendingGIFs(
        offset: Int,
        limit: Int
    ) -> Observable<Data> {
        let requestUrl = getBaseURL() + apiUrl + "/trending"
        
        let params = [
            "api_key" : "pqn33ek8y47re7L2D7iOKezhOgf5Ghkl",
            "limit" : limit,
            "offset" : offset
        ] as [String : Any]
        
        return RxAlamofire.data(.get, requestUrl, parameters: params)
    }
}
