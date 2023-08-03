//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import UIKit

class BaseViewController: UIViewController {
    private let loadingIndicator = LoadingIndicator()
    var loadingIndicatorIsHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.appBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = AppColors.appBackground
        navigationController?.navigationBar.barTintColor = AppColors.appBackground
        
        tabBarController?.tabBar.backgroundColor = AppColors.lightRed
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = AppColors.lightRed
    }
    
    func showLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicatorIsHidden = false
        loadingIndicator.start()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stop()
        loadingIndicatorIsHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingIndicator.removeFromSuperview()
        }
    }
}
