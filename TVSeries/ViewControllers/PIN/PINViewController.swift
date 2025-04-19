//
//  PINViewController.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import UIKit

class PINViewController: UIViewController {
    private let viewModel: PINViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = viewModel.mode == .setup ? "Set PIN" : "Enter PIN"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text =
            viewModel.mode == .setup
            ? "Enter a 4-digit PIN to protect your app" : "Enter your PIN to continue"
        return label
    }()

    private lazy var pinTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 32)
        textField.delegate = self
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()

    private lazy var confirmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Confirm PIN"
        label.isHidden = viewModel.mode == .verify
        return label
    }()

    private lazy var confirmPinTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 32)
        textField.delegate = self
        textField.isHidden = viewModel.mode == .verify
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init(viewModel: PINViewModel) {
        self.viewModel = viewModel
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

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(pinTextField)
        view.addSubview(confirmLabel)
        view.addSubview(confirmPinTextField)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            pinTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            pinTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pinTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pinTextField.heightAnchor.constraint(equalToConstant: 50),

            confirmLabel.topAnchor.constraint(equalTo: pinTextField.bottomAnchor, constant: 40),
            confirmLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            confirmPinTextField.topAnchor.constraint(
                equalTo: confirmLabel.bottomAnchor, constant: 8),
            confirmPinTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPinTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),
            confirmPinTextField.heightAnchor.constraint(equalToConstant: 50),

            errorLabel.topAnchor.constraint(
                equalTo: confirmPinTextField.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func setupBindings() {
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error?.localizedDescription
            }
            .store(in: &cancellables)

        viewModel.$isVerified
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVerified in
                if isVerified {
                    self?.pinTextField.resignFirstResponder()
                    self?.confirmPinTextField.resignFirstResponder()
                }
            }
            .store(in: &cancellables)
    }
}

extension PINViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if textField == pinTextField {
            viewModel.updatePIN(newText)
            if newText.count == 4 && viewModel.mode == .verify {
                viewModel.verify()
            }
        } else if textField == confirmPinTextField {
            viewModel.updateConfirmPIN(newText)
            if newText.count == 4 {
                viewModel.setup()
            }
        }

        return newText.count <= 4
    }
}
