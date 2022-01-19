//
//  GifSearchResponse.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import Foundation

// MARK: - GifSearchResponse
struct GifSearchResponse: Codable {
    let data: [GifImageInfo]
    let pagination: GifPagination
    let meta: GifMeta
}

// MARK: - GifImageInfo
struct GifImageInfo: Codable {
    let id: String
    let title: String
    let createAt: String?
    let images: GifImages
}

// MARK: - GifImages
struct GifImages: Codable {
    let original: GifImageProperty
    let fixedHeightDownsampled: GifImageProperty
    
    enum CodingKeys: String, CodingKey {
        case original
        case fixedHeightDownsampled = "fixed_height_downsampled"
    }
}

// MARK: - GifImageProperty
struct GifImageProperty: Codable {
    let height, width, size: String
    let url: String
    let frames, hash: String?
}

// MARK: - GifPagination
struct GifPagination: Codable {
    let totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}

// MARK: - GifMeta
struct GifMeta: Codable {
    let status: Int
    let msg, responseID: String

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

