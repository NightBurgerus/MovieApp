//
//  HomePageRepository.swift
//  MovieApp
//
//  Created by Чебупелина on 02.08.2023.
//

import Foundation
import UIKit

protocol HomePageRepositoryProtocol: AnyObject {
    func getTopFilms(completion: @escaping(Response<[TopFilm]>) -> ())
    func getRandom(completion: @escaping(Response<[RandomFilm]>) -> ())
    func getLastReleases(year: String, month: String, completion: @escaping(Response<[LastReleaseFilm]>) -> ())
    func loadImage(url: URL, parameters: [MethodParams], completion: @escaping(Response<UIImage>) -> ())
    func syncLoadImage(url: URL, parameters: [MethodParams], delegateQueue: OperationQueue?) -> UIImage?
}

final class HomePageRepository: HomePageRepositoryProtocol {
    func getTopFilms(completion: @escaping (Response<[TopFilm]>) -> ()) {
        let _ = ApiWorker.shared
            .get(url: URL(string: Links.Films.top)!, parameters: [
                .headers([
                    "X-API-KEY": "bbe87649-1adb-4ad9-a173-ccb11918e65f",
                    "Content-Type": "application/json"
                ])
            ])
            .request { [weak self] response in
                guard let self = self else {
                    completion(.failure(.unknownError))
                    return
                }
                completion(self.handleResponse(response, model: TopFilmsResponse.self))
            }
    }
    
    
    func getRandom(completion: @escaping (Response<[RandomFilm]>) -> ()) {
        guard let url = URL(string: Links.Films.films) else {
            completion(.failure(.invalidURL))
            return
        }
        print("~", url)
        ApiWorker.shared
                .get(url: url, parameters: [
                    .headers([
                        "X-API-KEY": "bbe87649-1adb-4ad9-a173-ccb11918e65f",
                        "Content-Type": "application/json"
                    ])
                ])
                .request { [weak self] response in
                    guard let self = self else {
                        completion(.failure(.unknownError))
                        return
                    }
                    completion(self.handleResponse(response, model: RandomFilmResponse.self))
                }
    }
    
    func getLastReleases(year: String, month: String, completion: @escaping (Response<[LastReleaseFilm]>) -> ()) {
        guard let url = URL(string: Links.Films.premieres + "?year=\(year)&month=\(month)") else {
            completion(.failure(.invalidURL))
            return
        }
        ApiWorker.shared
                .get(url: url, parameters: [
                    .headers([
                        "X-API-KEY": "bbe87649-1adb-4ad9-a173-ccb11918e65f",
                        "Content-Type": "application/json"
                    ])
                ])
                .request { [weak self] response in
                    guard let self = self else {
                        completion(.failure(.unknownError))
                        return
                    }
                    completion(self.handleResponse(response, model: LastReleasesResponse.self))
                }
    }
    
    func loadImage(url: URL, parameters: [MethodParams] = [], completion: @escaping(Response<UIImage>) -> ()) {
        ApiWorker.shared
            .get(url: url, parameters: parameters)
            .request { [weak self] response in
                guard let self = self else {
                    completion(.failure(.unknownError))
                    return
                }
                completion(self.decodeImage(response))
            }
    }
    
    func syncLoadImage(url: URL, parameters: [MethodParams] = [], delegateQueue: OperationQueue? = nil) -> UIImage? {
        let data = ApiWorker.shared
                    .get(url: url, parameters: parameters)
                    .syncRequest(delegateQueue: delegateQueue)
        return UIImage(data: data ?? Data())
    }
    
    
}

extension HomePageRepository {
    private func handleResponse<Model: FilmsProtocol>(_ response: LoadingResponse, model: Model.Type) -> Response<[Model.T]> {
        switch response {
        case .failure(let error): return .failure(error)
        case .success(let data):
            do {
                let json = try JSONDecoder().decode(Model.self, from: data)
                return .success(json.data)
            } catch {
                print("~ decode error: ", error)
                return .failure(.decodeError)
            }
        }
    }
    
    private func decodeImage(_ response: LoadingResponse) -> Response<UIImage> {
        switch response {
        case .failure(let error): return .failure(error)
        case .success(let data):
            if let image = try? UIImage(data: data) {
                return .success(image)
            }
            return .failure(.decodeError)
        }
    }
}
