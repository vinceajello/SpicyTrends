//
//  Types+Classes.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 20/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit



struct Trend:Codable
{
    let title:String
    let state:String
    let link:String!
    let wiki:String!
    let news:NewsList!
}

struct GetTrendsDataResponse:Codable
{
    let status:Int
    let updatedAt:String
    let data:[Trend]
}

//
// NEWS
//

struct NewsList:Codable
{
    let news:[News]
}

struct News:Codable
{
    let image:String!
    let title:String
    let short_story:String!
    let news_source:String!
}

//
// TWITTER
//

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
    let screen_name:String
}

struct TwitterEntity:Codable
{
    let hashtags:[TwitterHashtag]
}

struct TwitterHashtag:Codable
{
    let text:String
}

//
// WIKI AND GOOGLE IMAGE 
//

struct WikiImageResponse:Codable
{
    let status:Int
    let data:String
}
