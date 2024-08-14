//
//  StoryCell.swift
//  TheGlobe
//
//  Created by Wu Yian on 2024-08-13.
//

import Foundation
import UIKit

class StoryCell: UITableViewCell {
    // MARK: Constant
    struct Constant {
        static let reuseIdentifier = "StoryCell"
    }
    
    struct ViewConstants {
        static let verticalStackSpacing = CGFloat(8)
        static let horizontalStackSpacing = CGFloat(12)
        static let sidePadding = CGFloat(16)
        static let imageWidth = CGFloat(100)
        static let imageHeight = CGFloat(50)
    }
    
    // MARK: UI Components
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headlineLabel, authorsLabel])
        stackView.axis = .vertical
        stackView.spacing = ViewConstants.verticalStackSpacing
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy private var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verticalStackView, newsImageView])
        stackView.axis = .horizontal
        stackView.spacing = ViewConstants.horizontalStackSpacing
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUIAndSetUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Setup
    func buildUIAndSetUpConstraints() {
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewConstants.sidePadding),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.sidePadding),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.sidePadding),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewConstants.sidePadding),
            
            newsImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageWidth),
            newsImageView.heightAnchor.constraint(equalToConstant: ViewConstants.imageHeight)
        ])
    }
    
    func configure(storyCellViewModel: StoryCellViewModel) {
        Task {
            do {
                let imageData = try await storyCellViewModel.fetchImage()
                self.newsImageView.image = UIImage(data: imageData)
            } catch {
                print("Failed to load image: \(error)")
                // TODO: Set a placeholder image depends on the use cases
            }
        }
        
        headlineLabel.attributedText = storyCellViewModel.attributedHeadline
        authorsLabel.text = storyCellViewModel.authors
    }
}
