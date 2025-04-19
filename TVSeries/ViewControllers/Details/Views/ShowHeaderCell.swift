//
//  ShowHeaderCell.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class ShowHeaderCell: UITableViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

    func configure(with show: TVShow) {
        if let imageURL = show.image?.medium {
            posterImageView.loadImage(from: imageURL)
        }
    }
}
