//
//  EpisodeCell.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class EpisodeCell: UITableViewCell {
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [numberLabel, nameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4

        contentView.addSubview(episodeImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            episodeImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            episodeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            episodeImageView.widthAnchor.constraint(equalToConstant: 100),
            episodeImageView.heightAnchor.constraint(equalToConstant: 60),

            stackView.leadingAnchor.constraint(
                equalTo: episodeImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            separatorView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }

    func configure(with episode: Episode) {
        numberLabel.text = "Episode \(episode.number)"
        nameLabel.text = episode.name

        if let imageURL = episode.image?.medium {
            episodeImageView.loadImage(from: imageURL)
        } else {
            episodeImageView.image = nil
        }
    }
}
