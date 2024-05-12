//
//  NetworkModelWithoutAlamofire.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 12.05.2024.
//

import Foundation

enum ApiUrlChooser {
    case defaultUrl, deteilFilm, imagesDownload, searchFilm, premiere, topTVshows, releases
}

class NetworkModelWithoutAlamofire {
    
    let session = URLSession.shared
    
    func getCurrentYearAndMonth() -> (year: String, month: String) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        let year = df.string(from: date)
        df.dateFormat = "LLLL"
        df.locale = Locale(identifier: "en")
        let month = df.string(from: date).uppercased()
        
        return (year, month)
    }

    // MARK: - Method for MainViewController
    func downloader<Model: Codable>(apiToUse: ApiUrlChooser, kinopoiskID: Int = 0, keyword: String = "", completion: @escaping (Model)->()) {
        var apiUrl = ""
        let currentYearAndMonth = getCurrentYearAndMonth()
    
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
        case .premiere:
            apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/premieres?year=\(currentYearAndMonth.year)&month=\(currentYearAndMonth.month)"
        case .topTVshows:
            apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/collections?type=TOP_250_TV_SHOWS"
        case .releases:
            apiUrl = "https://kinopoiskapiunofficial.tech/api/v2.1/films/releases?year=\(currentYearAndMonth.year)&month=\(currentYearAndMonth.month)"
        }
        
        guard let unwrApiUrl = URL(string: apiUrl) else { return }
        
        var request = URLRequest(url: unwrApiUrl)
            request.httpMethod = "GET"
            request.setValue("b27890d4-28ce-4e20-8b65-c542733f350c", forHTTPHeaderField: "X-API-KEY")
            
        let task = session.dataTask(with: request) { data, response, error in
            guard let unwrData = data, error == nil else { return }
            
            guard let unwrResult = try? JSONDecoder().decode(Model.self, from: unwrData) else { return }
            
            completion(unwrResult)
        }
        task.resume()
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
