//
//  NetworkModel.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 01.04.2024.
//

import Foundation
import Alamofire

enum ApiUrlChooser {
    case defaultUrl, deteilFilm, imagesDownload, searchFilm
}

class NetworkModel {
    
    private let headers: HTTPHeaders = [
        "X-API-KEY": "b27890d4-28ce-4e20-8b65-c542733f350c"
    ]
    
    // MARK: - Method for MainViewController
    func downloader<Model: Codable>(apiToUse: ApiUrlChooser, kinopoiskID: Int = 0, keyword: String = "", completion: @escaping (Model)->()) {
        var apiUrl = ""
        
        switch apiToUse {
        case .defaultUrl:
            apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/collections?type=TOP_250_MOVIES"
        case .deteilFilm:
            apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(kinopoiskID)"
        case .imagesDownload:
            apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(kinopoiskID)/images"
        case .searchFilm:
            let url = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(keyword)"
            let apiUrlToAllowCyrillic = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            guard let unwrApiUrl = apiUrlToAllowCyrillic else { return }
            apiUrl = unwrApiUrl
        }

        AF.request(apiUrl, headers: headers).responseDecodable(of: Model.self) { apiResponce in
            guard let unwrResponce = apiResponce.value else {
                print("error")
                return }

            completion(unwrResponce)
        }
    }
    
    // MARK: - Method for DeteilFilmViewController
    func loadFilmDeteilDataAndImages(kinopoiskID: Int, completion: @escaping (KinopoiskFilmDeteilModel, [ImageItem])->()) {
        var deteilFilmItem: KinopoiskFilmDeteilModel!
        var filmPicsArray: [ImageItem] = []
        
        let group = DispatchGroup()
   
        group.enter()
        
        downloader(apiToUse: .deteilFilm, kinopoiskID: kinopoiskID) { (downloadedDeteilFilmItem: KinopoiskFilmDeteilModel) in
            deteilFilmItem = downloadedDeteilFilmItem
            group.leave()
        }
        
        group.enter()
        
        downloader(apiToUse: .imagesDownload, kinopoiskID: kinopoiskID) { (downloadedPics: KinopoiskFilmImagesModel) in
            for pic in downloadedPics.items {
                filmPicsArray.append(pic)
            }
            group.leave()
        }
        
        group.notify(queue: .main, execute:  {
            print("Ids are fetched")
            completion(deteilFilmItem, filmPicsArray)
        })
    }
}
