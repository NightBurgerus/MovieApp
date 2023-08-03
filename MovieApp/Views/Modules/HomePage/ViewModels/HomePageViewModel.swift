//
//  HomePageViewModel.swift
//  MovieApp
//
//  Created by Чебупелина on 02.08.2023.
//

import Foundation
import UIKit

class HomePageViewModel: HomePageViewOutput {
    weak var view: HomePageViewInput!
    var repository: HomePageRepositoryProtocol!
    
    func getTopFilms() {
        repository.getTopFilms { [weak self] response in
            switch response {
            case .success(let films):
                let topFilms = self?.film2TopFilmCell(films) ?? []
                self?.view.showTopFilms(topFilms)
            case .failure(let error): print("~ error: ", error)
            }
        }
    }
    
    func getRandom() {
        repository.getRandom { [weak self] response in
            switch response {
            case .success(let films):
                let randomFilms = self?.film2TopFilmCell(films) ?? []
                self?.view.showRandomFilms(randomFilms)
            case .failure(let error): break
            }
        }
    }
    
    func getLastReleases() {
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        let year = "\(components.year ?? 2023)"
        let month = Calendar.current.standaloneMonthSymbols[(components.month ?? 8) - 1]
        repository.getLastReleases(year: year, month: month) { [weak self] response in
            switch response {
            case .success(let films):
                let lastFilms = self?.film2TopFilmCell(films) ?? []
                self?.view.showLastReleases(lastFilms)
            case .failure(let error): break
            }
        }
    }
    
    func loadImage(_ url: String, parameters: [MethodParams] = [], completion: @escaping(Response<UIImage>) -> ()) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        (repository as? HomePageRepository)?.loadImage(url: url, parameters: parameters, completion: { response in
            completion(response)
        })
    }
}

extension HomePageViewModel {
    private func film2TopFilmCell<T: FilmModelProtocol>(_ films: [T]) -> [FilmCell] {
        let imagesQueue = OperationQueue()
        var topFilmCells = [FilmCell]()
        
        // Загрузка постеров для каждого фильма
        // (загрузка синхронная)
        for film in films {
            let operation = BlockOperation { [weak self] in
                guard let stringUrl = film.posterUrlPreview ?? film.posterUrl,
                      let url = URL(string: stringUrl) else {
                    return
                }
                
                if let image = self?.repository.syncLoadImage(url: url, parameters: [], delegateQueue: imagesQueue) {
                    let name = film.nameRu ?? film.nameEn ?? "Без названия"
                    let cell = FilmCell(name: name, year: "\(film.year)", image: image)
                    topFilmCells.append(cell)
                }
            }
            imagesQueue.addOperation(operation)
        }
        
        // Ждём загрузку
        imagesQueue.waitUntilAllOperationsAreFinished()
        var correct = [FilmCell]()
        
        // Компануем в правильном порядке
        for film in films {
            let name = film.nameRu ?? film.nameEn ?? "Без названия"
            guard let index = topFilmCells.firstIndex(where: { $0.name == name }) else {
                continue
            }
            correct.append(topFilmCells[index])
            topFilmCells.remove(at: index)
        }
        return correct
    }
}
