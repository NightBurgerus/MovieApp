//
//  HomePageAssembly.swift
//  MovieApp
//
//  Created by Чебупелина on 03.08.2023.
//

import Foundation
import UIKit

class HomePageAssambly: NSObject {
    @IBOutlet weak var viewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let view = viewController as? HomePageViewController else { return }
        let viewModel = HomePageViewModel()
        let repository = HomePageRepository()
        
        viewModel.repository = repository
        viewModel.view = view
        
        view.viewModel = viewModel
    }
}
