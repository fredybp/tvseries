//
//  HomeViewController.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import UIKit

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TVShowCell.self, forCellReuseIdentifier: "TVShowCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search TV Shows"
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchBar.autocapitalizationType = .none
        controller.searchBar.autocorrectionType = .no
        return controller
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var loadingMoreIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let imageView = UIImageView(image: UIImage(systemName: "tv"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])

        // Store references to labels for later updates
        self.emptyStateTitleLabel = titleLabel
        self.emptyStateMessageLabel = messageLabel

        return view
    }()

    private var emptyStateTitleLabel: UILabel?
    private var emptyStateMessageLabel: UILabel?

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Shows"
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
        setupNavigationBar()
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateView)

        let tableFooterView = UIView(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        tableFooterView.addSubview(loadingMoreIndicator)
        loadingMoreIndicator.center = tableFooterView.center
        tableView.tableFooterView = tableFooterView

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupBindings() {
        viewModel.$shows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shows in
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoadingMore in
                if isLoadingMore {
                    self?.loadingMoreIndicator.startAnimating()
                } else {
                    self?.loadingMoreIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)

        viewModel.$isSearching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSearching in
                self?.navigationItem.title = isSearching ? "Search Results" : "TV Shows"
                self?.updateEmptyState()
            }
            .store(in: &cancellables)
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
    }

    private func showError(_ error: TVMazeError) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func settingsTapped() {
        viewModel.openSettings()
    }

    private func updateEmptyState() {
        let isEmpty = viewModel.shows.isEmpty
        emptyStateView.isHidden = !isEmpty

        if isEmpty {
            if viewModel.isSearching {
                emptyStateTitleLabel?.text = "No Results Found"
                emptyStateMessageLabel?.text = "Try a different search term"
            } else if viewModel.error != nil {
                emptyStateTitleLabel?.text = "Error Loading Shows"
                emptyStateMessageLabel?.text = "Please try again later"
            } else {
                emptyStateTitleLabel?.text = "No TV Shows"
                emptyStateMessageLabel?.text = "Start by searching for your favorite shows"
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isLoading && viewModel.shows.isEmpty {
            return 10  // Show 10 skeleton cells while loading
        }
        return viewModel.shows.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.shows.indices.contains(indexPath.row),
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "TVShowCell", for: indexPath)
                as? TVShowCell
        else { return UITableViewCell() }
        let show = viewModel.shows[indexPath.row]
        cell.configure(with: show)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = viewModel.shows[indexPath.row]
        viewModel.didSelectShow(show)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight * 1.5 {
            viewModel.loadMoreShows()
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
    }
}

// MARK: - TVShowCell
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
        networkLabel.text = show.displayNetwork
        ratingLabel.text = show.rating.average.map { String(format: "⭐️ %.1f", $0) } ?? "No rating"

        if let imageURL = show.image?.medium {
            posterImageView.loadImage(from: imageURL)
        } else {
            posterImageView.image = UIImage(systemName: "tv")
        }
    }
}
