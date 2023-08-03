//
//  FilmCollectionCell.swift
//  MovieApp
//
//  Created by Чебупелина on 02.08.2023.
//

import UIKit

class FilmCollectionCell: UICollectionViewCell {
    private var image: UIImage? = nil {
        didSet {
            guard let img = image else { return }
            imageView.image = img
            imageView.sizeToFit()
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
        }
    }
    private var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    private var date: String = "" {
        didSet {
            dateLabel.text = date
        }
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with image: UIImage, name: String, date: String) {
        self.image = image
        self.name = name
        self.date = date
        background.backgroundColor = AppColors.appBackground
        nameLabel.textColor = AppColors.lightGray
        dateLabel.textColor = AppColors.lightGray
    }

}
