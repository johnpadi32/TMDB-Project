//
//  HomeSections.swift
//  TMDB Project
//
//  Created by John Padilla on 3/2/22.
//

enum HomeSections: Int, CaseIterable, CustomStringConvertible {
    
    case TrendingMovies
    case TrendingTv
    case Popular
    case Upcoming
    case topRated
    
    var description: String {
        switch self {
        case .TrendingMovies: return "Trending Movie"
        case .TrendingTv: return "Trending Tv"
        case .Popular: return "Popular"
        case . Upcoming: return "Upcoming Movies"
        case .topRated: return "Top rated" 
        }
    }
}
