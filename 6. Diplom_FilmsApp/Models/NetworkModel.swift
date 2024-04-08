//
//  NetworkModel.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 01.04.2024.
//

import Foundation
import Alamofire

class NetworkModel {
    var filmsArray = [FilmItem]()
    
    private let headers: HTTPHeaders = [
        "X-API-KEY": "b27890d4-28ce-4e20-8b65-c542733f350c"
    ]
    
    // MARK: - Method for MainViewController
    func loadData(completion: @escaping ()->()) {
        let apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/collections?type=TOP_250_MOVIES"

        AF.request(apiUrl, headers: headers).responseDecodable(of: KinopoiskFilmsArrayModel.self) { apiResponce in
            guard let unwrResponce = apiResponce.value else {
                print("error")
                return }
            for filmItem in unwrResponce.items {
                self.filmsArray.append(filmItem)
            }
            completion()
        }
    }
    
    // MARK: - Method for DeteilFilmViewController
    func loadFilmDeteilData(enter kinopoiskID: Int, completion: @escaping (KinopoiskFilmDeteilModel)->()) {
        let apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(kinopoiskID)"

//        AF.request(apiUrl, headers: headers).responseDecodable(of: KinopoiskFilmDeteilModel.self, queue: .main)
        AF.request(apiUrl, headers: headers).responseDecodable(of: KinopoiskFilmDeteilModel.self) { apiResponce in
            guard let unwrResponce = apiResponce.value else {
                print("error")
                return }
            
            print(unwrResponce.kinopoiskId)
            
            completion(unwrResponce)
        }
    }
    
    // MARK: - Method for FilmPicsViewController
    func loadFilmPictures(enter kinopoiskID: Int, completion: @escaping (KinopoiskFilmImagesModel)->()) {
        let apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(kinopoiskID)/images"

//        AF.request(apiUrl, headers: headers).responseDecodable(of: KinopoiskFilmDeteilModel.self, queue: .main)
        AF.request(apiUrl, headers: headers).responseDecodable(of: KinopoiskFilmImagesModel.self) { apiResponce in
            guard let unwrResponce = apiResponce.value else {
                print("error")
                return }
            
            print(unwrResponce.total)

            completion(unwrResponce)
        }
    }
    
}
