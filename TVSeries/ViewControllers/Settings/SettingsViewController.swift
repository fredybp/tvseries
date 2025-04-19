//
//  SettingsViewController.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import UIKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: MainCoordinator?

    private lazy var pinSection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PIN Protection"
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private lazy var pinSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.isOn = viewModel.isPINEnabled
        switchView.addTarget(self, action: #selector(pinSwitchChanged), for: .valueChanged)
        return switchView
    }()

    private lazy var pinDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Protect your app with a 4-digit PIN"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.coordinator = viewModel.coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"

        view.addSubview(pinSection)
        pinSection.addSubview(pinLabel)
        pinSection.addSubview(pinSwitch)
        pinSection.addSubview(pinDescription)

        NSLayoutConstraint.activate([
            pinSection.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pinSection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinSection.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pinLabel.topAnchor.constraint(equalTo: pinSection.topAnchor, constant: 12),
            pinLabel.leadingAnchor.constraint(equalTo: pinSection.leadingAnchor, constant: 16),
            pinLabel.trailingAnchor.constraint(equalTo: pinSwitch.leadingAnchor, constant: -8),

            pinSwitch.centerYAnchor.constraint(equalTo: pinLabel.centerYAnchor),
            pinSwitch.trailingAnchor.constraint(equalTo: pinSection.trailingAnchor, constant: -16),

            pinDescription.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 4),
            pinDescription.leadingAnchor.constraint(
                equalTo: pinSection.leadingAnchor, constant: 16),
            pinDescription.trailingAnchor.constraint(
                equalTo: pinSection.trailingAnchor, constant: -16),
            pinDescription.bottomAnchor.constraint(equalTo: pinSection.bottomAnchor, constant: -12),
        ])
    }

    private func setupBindings() {
        viewModel.$isPINEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.pinSwitch.isOn = isEnabled
            }
            .store(in: &cancellables)
    }

    @objc private func pinSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            coordinator?.navigateToPINSetup()
        } else {
            viewModel.togglePIN()
        }
    }
}
