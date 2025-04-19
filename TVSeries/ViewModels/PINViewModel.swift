//
//  PINViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Combine
import Foundation

class PINViewModel: BaseViewModel {
    enum Mode {
        case setup
        case verify
    }

    let mode: Mode
    @Published private(set) var pin = ""
    @Published private(set) var confirmPin = ""
    @Published private(set) var error: PINError?
    @Published private(set) var isVerified = false

    private let pinService: PINServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(coordinator: MainCoordinator, mode: Mode, pinService: PINServiceProtocol) {
        self.mode = mode
        self.pinService = pinService
        super.init(coordinator: coordinator)
    }

    func updatePIN(_ pin: String) {
        self.pin = pin
        error = nil
    }

    func updateConfirmPIN(_ pin: String) {
        self.confirmPin = pin
        error = nil
    }

    func verify() {
        guard !pin.isEmpty else { return }

        pinService.verifyPIN(pin)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] isValid in
                if isValid {
                    self?.isVerified = true
                    self?.coordinator?.pinVerified()
                } else {
                    self?.error = .pinMismatch
                }
            }
            .store(in: &cancellables)
    }

    func setup() {
        guard !pin.isEmpty, !confirmPin.isEmpty else { return }

        pinService.setPIN(pin, confirmPin: confirmPin)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] _ in
                self?.isVerified = true
                self?.coordinator?.pinVerified()
            }
            .store(in: &cancellables)
    }

    func clearPIN() {
        pinService.clearPIN()
    }
}
