//
//  CharacterTableViewCell.swift
//  Marvel
//
//  Created by Aitor Sola on 25/10/21.
//

import UIKit
import SDWebImage

class CharacterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var characterImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  // MARK: - Public
  
  func setupUI(data: CharacterTableViewCellData) {
    let placeholder = UIImage(systemName: "photo.fill")?.withRenderingMode(.automatic)
    nameLabel?.text = data.name
    characterImageView?.sd_setImage(with: data.url,
                                    placeholderImage: placeholder,
                                    completed: nil)
  }
  
  // MARK: - Private
  
  func configure() {
    backgroundColor = .clear
    
    characterImageView?.layer.masksToBounds = true
    characterImageView?.layer.cornerRadius = 25
    characterImageView.clipsToBounds = true
    characterImageView.contentMode = .scaleAspectFit
    characterImageView.tintColor = .systemRed
  }
}
