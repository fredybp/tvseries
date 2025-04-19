//
//  DetailViewController.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import UIKit

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShowHeaderCell.self, forCellReuseIdentifier: "ShowHeaderCell")
        tableView.register(ShowInfoCell.self, forCellReuseIdentifier: "ShowInfoCell")
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "EpisodeCell")
        tableView.register(
            SeasonHeaderView.self, forHeaderFooterViewReuseIdentifier: "SeasonHeaderView")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()

    private lazy var loadingIndicator: LoadingIndicatorView = {
        let indicator = LoadingIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private var seasons: [Int] = []
    private var episodesBySeason: [Int: [Episode]] = [:]

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.show.name
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupBindings() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        viewModel.$episodes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] episodes in
                self?.organizeEpisodesBySeason(episodes)
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func organizeEpisodesBySeason(_ episodes: [Episode]) {
        episodesBySeason.removeAll()
        seasons.removeAll()

        for episode in episodes {
            if episodesBySeason[episode.season] == nil {
                episodesBySeason[episode.season] = []
                seasons.append(episode.season)
            }
            episodesBySeason[episode.season]?.append(episode)
        }

        seasons.sort()
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + seasons.count  // Header + Info + Seasons
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1  // Header
        } else if section == 1 {
            return 1  // Info
        } else {
            let season = seasons[section - 2]
            return episodesBySeason[season]?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ShowHeaderCell", for: indexPath) as? ShowHeaderCell
            else { return UITableViewCell() }
            cell.configure(with: viewModel.show)
            return cell
        } else if indexPath.section == 1 {
            guard
                let cell =
                    tableView.dequeueReusableCell(withIdentifier: "ShowInfoCell", for: indexPath)
                    as? ShowInfoCell
            else { return UITableViewCell() }
            cell.configure(with: viewModel.show)
            return cell
        } else {
            guard
                let cell =
                    tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
                    as? EpisodeCell
            else { return UITableViewCell() }
            let season = seasons[indexPath.section - 2]
            if let episode = episodesBySeason[season]?[indexPath.row] {
                cell.configure(with: episode)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= 2 {
            guard
                let header =
                    tableView.dequeueReusableHeaderFooterView(withIdentifier: "SeasonHeaderView")
                    as? SeasonHeaderView
            else { return nil }
            let season = seasons[section - 2]
            header.configure(with: season)
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section >= 2 ? 44 : 0
    }

    func tableView(
        _ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int
    ) {
        if section >= 2 {
            //            view.backgroundColor = .systemGroupedBackground
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        }

        return 80
    }
}
