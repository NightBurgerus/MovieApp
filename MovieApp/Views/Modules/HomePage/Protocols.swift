//
//  Protocols.swift
//  MovieApp
//
//  Created by Чебупелина on 03.08.2023.
//

import Foundation
import UIKit

protocol HomePageViewOutput: AnyObject {
    func getTopFilms()
    func getRandom()
    func getLastReleases()
    func loadImage(_ url: String, parameters: [MethodParams], completion: @escaping(Response<UIImage>) -> ())
}

protocol HomePageViewInput: AnyObject {
    func showTopFilms(_ films: [FilmCell])
    func showRandomFilms(_ films: [FilmCell])
    func showLastReleases(_ films: [FilmCell])
}
