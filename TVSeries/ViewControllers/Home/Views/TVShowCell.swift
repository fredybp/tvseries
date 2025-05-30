//
//  TVShowCell.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import UIKit

class TVShowCell: UITableViewCell {
    static let identifier = "TVShowCell"

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

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var cancellables = Set<AnyCancellable>()
    private var onFavoriteTapped: ((Int) -> Void)?
    private var showId: Int?

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
        contentView.addSubview(favoriteButton)

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

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
                equalTo: favoriteButton.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            networkLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            networkLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            networkLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: networkLabel.bottomAnchor, constant: 4),
            ratingLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),

            favoriteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    func configure(with show: TVShow, isFavorite: Bool, onFavoriteTapped: @escaping (Int) -> Void) {
        titleLabel.text = show.name
        networkLabel.text = show.network?.name
        ratingLabel.text =
            show.rating?.average
            .map { String(format: "⭐️ %.1f", $0) } ?? "No rating"
        showId = show.id
        self.onFavoriteTapped = onFavoriteTapped
        favoriteButton.isSelected = isFavorite

        if let imageURL = show.image?.medium {
            posterImageView.loadImage(from: imageURL)
        } else {
            posterImageView.image = UIImage(systemName: "tv")
            posterImageView.contentMode = .center
        }
    }

    @objc private func favoriteButtonTapped() {
        guard let showId = showId else { return }
        onFavoriteTapped?(showId)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        networkLabel.text = nil
        ratingLabel.text = nil
        posterImageView.image = nil
        favoriteButton.isSelected = false
        showId = nil
        onFavoriteTapped = nil
        cancellables.removeAll()
    }
}
