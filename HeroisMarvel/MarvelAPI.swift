//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Jessica Bigal on 19/06/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

//API foi feita com metodos de classe para nao precisar instanciar

class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?" //URL da API
    static private let privateKey = "4033afab90ce900efea9c38e1fb2aa9b646d29ab" //pegar no site da API
    static private let publicKey = "b3ffdb1b19153628d58b7d6d41232823" //pegar no site da API
    static private let limit = 50 //quanto que cada chamada pode devolver, neste caso sera 50por vez
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?)->Void) {
        let offset = page * limit //esta propriedade faz com que em cada pagina tenha o limite setado, que no caso sao 50 personagens
        let startsWith: String //a API permite procurar com o comeco do nome do personagem
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url) //url montada
        
        AF.request(url).response { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                  let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error)
                onComplete(nil)
            }
            
 
        }//requisicao da URL
    }
    
    
    
    //Metodo abaixo trata os dados da credencial conforme solicitado pela Marvel:
    private class func getCredentials() -> String {
        
        // No site estava solicitando uma propriedade que trara o "time-stamp", utilizando o "timeIntervalSince1970", semp[re retorna o tempo decorrido de 1970 ate a chamada, e sempre sera diferente
        let ts = String(Date().timeIntervalSince1970)
        
        // hash eh quando encriptamos alguma informacao utilizando uma tecnica, neste caso utilizaremos o MD5 que foi incorporado no cocoapod POdfile, importe o "swiftHash"
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)" //chave solicitada pela Marvel na autorizacao substituindo com as propriedades criadas
    }
}
