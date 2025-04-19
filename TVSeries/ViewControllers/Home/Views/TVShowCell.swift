//
//  TVShowCell.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class TVShowCell: UITableViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let networkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemOrange
        return label
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(networkLabel)
        contentView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            networkLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            networkLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            networkLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: networkLabel.bottomAnchor, constant: 4),
            ratingLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(with show: TVShow) {
        titleLabel.text = show.name
        networkLabel.text = show.network?.name
        ratingLabel.text = show.rating?.average
            .map { String(format: "⭐️ %.1f", $0) } ?? "No rating"

        if let imageURL = show.image?.medium {
            posterImageView.loadImage(from: imageURL)
        } else {
            posterImageView.image = UIImage(systemName: "tv")
            posterImageView.contentMode = .center
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        networkLabel.text = nil
        ratingLabel.text = nil
        posterImageView.image = nil
    }
}
