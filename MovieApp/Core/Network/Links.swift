//
//  Links.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

struct Links {
    private static let token = "bbe87649-1adb-4ad9-a173-ccb11918e65f"
    fileprivate static let baseURL = "https://kinopoiskapiunofficial.tech/api"
    
    struct Films {
        fileprivate static let version = "v2.2"
        
        // Топы и коллекции
        static let top              = baseURL + "/\(version)/films/top"
        // Кинопремьеры
        static let premieres        = baseURL + "/\(version)/films/premieres"
        // ID стран и жанров (для фильтрации)
        static let filters          = baseURL + "/\(version)/films/filters"
        // Фильмы по фильтрам
        static let films            = baseURL + "/\(version)/films"
        // Поиск по ключевым словам
        static let searchByKeyword  = baseURL + "/\(version)/films/searchByKeyword"
        // Список цифровых релизов
        static let releases         = baseURL + "/\(version)/films/releases"
        
        // Фильм по ID
        static func film(by id: Int) -> String {
            return Links.baseURL + "/\(version)/films/\(id)"
        }
    }
    
    struct Film {
        private let id: Int
        private let base: String
        
        init(by id: Int) {
            self.id = id
            self.base = Links.baseURL + "/\(Links.Films.version)/films/\(id)/"
        }
        
        // Сезоны сериала
        var seasons: String         { base + "seasons" }
        // Факты и ошибки в фильме
        var facts: String           { base + "facts" }
        // Данные о прокате фильма
        var distributions: String   { base + "distributions" }
        // Данные о бюджете и сборах фильма
        var boxOffice: String       { base + "box_office" }
        // Награды фильма
        var awards: String          { base + "awards" }
        // Трейлеры, тизеры, видео для фильма
        var videos: String          { base + "videos" }
        // Список похожих фильмов
        var similars: String        { base + "similars" }
        // Кадры, постеры, фан-арты, обои, связанные с фильмом
        var images: String          { base + "images" }
        // Рецензии зрителей
        var reviews: String         { base + "reviews" }
        // Список сайтов, где можно посмотреть фильм
        var externalSources: String { base + "external_sources" }
        // Сиквелы и приквелы фильма
        var sequelsAndPrequels: String { base + "sequels_and_prequels" }
        
    }
    
    struct Staff {
        fileprivate static let version = "v1"
        
        // Данные об актёрах, режиссёрах и т.д.
        static let staff = baseURL + "/\(version)/staff"
        // Данные о конкретном человеке
        static func staff(by id: Int) -> String {
            return staff + "/\(id)"
        }
    }
    
    struct Persons {
        fileprivate static let version = "v1"
        
        // Поиск актёров, режиссёров
        static let persons = baseURL + "/\(version)/persons"
    }
    
}
