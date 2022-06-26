//
//  MarvelClasses.swift
//  HeroisMarvel
//
//  Created by Jessica Bigal on 19/06/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation

//Neste arquivo temos todas as classes que faremos uso a partir da API da Marve, utilizando as estruturas  do codigo JSON

struct MarvelInfo: Codable {
    let code: Int
    let status: String
    let data: MarvelData
    
    
}

struct MarvelData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Hero]?
    
}

struct Hero: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    let urls: [HeroURL]
    
}

struct Thumbnail: Codable {
    let path: String
    let ext: String
    
    var url: String {
        return path + "." + ext
    }
    
    //Quando tiver alguma palavra reservada a ser procurada no JSON, como o "extension", utilize o "CodingKey", que funciona como um "De:Para", para solucionar este problema:
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }

}

struct HeroURL:Codable {
    let type: String
    let url: String
}
