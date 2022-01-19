//
//  GifsDomain.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//



import Foundation
import RxSwift

class GifsDomain: BaseDomain {
    
    func fetchGIFs(
        query: String,
        offset: Int,
        limit: Int
    ) -> Observable<GifSearchResponse> {
        
        typealias Response = GifSearchResponse
        
        return GifsApi
            .fetchGIFs(
                query: query,
                offset: offset,
                limit: limit
            )
            .map { data in
                do {
                    return try JSONDecoder().decode(Response.self, from: data)
                } catch {
                    throw self.decodeError(data: data, error: error)
                }
            }
    }
    
    func fetchTrendingGIFs(
        offset: Int,
        limit: Int
    ) -> Observable<GifSearchResponse> {
        
        typealias Response = GifSearchResponse
        
        return GifsApi
            .fetchTrendingGIFs(
                offset: offset,
                limit: limit
            )
            .map { data in
                do {
                    return try JSONDecoder().decode(Response.self, from: data)
                } catch {
                    throw self.decodeError(data: data, error: error)
                }
            }
    }
    
    
}
