//
//  YoutubeSearchResponse.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

import Foundation

struct YoutubeSearchResponse: Codable  {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
