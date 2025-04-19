//
//  EpisodeDetailViewController.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    private let episode: Episode

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private lazy var seasonAndNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure(with: episode)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Episode Details"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(episodeImageView)
        contentView.addSubview(infoStackView)

        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(seasonAndNumberLabel)
        infoStackView.addArrangedSubview(summaryLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            episodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            episodeImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            episodeImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            episodeImageView.heightAnchor.constraint(
                equalTo: episodeImageView.widthAnchor, multiplier: 0.5),

            infoStackView.topAnchor.constraint(
                equalTo: episodeImageView.bottomAnchor, constant: 24),
            infoStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }

    private func configure(with episode: Episode) {
        nameLabel.text = episode.name
        seasonAndNumberLabel.text = "Season \(episode.season) • Episode \(episode.number)"

        if let summary = episode.summary {
            summaryLabel.text = summary.replacingOccurrences(
                of: "<[^>]+>", with: "", options: .regularExpression)
        } else {
            summaryLabel.text = "No summary available"
        }

        if let imageURL = episode.image?.original {
            episodeImageView.loadImage(from: imageURL)
        } else {
            episodeImageView.image = nil
        }
    }
}
