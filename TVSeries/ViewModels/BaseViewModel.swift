//
//  BaseViewModel.swift
//  TVSeries
//
//  Created by Fred on 19/04/25.
//

import Foundation

class BaseViewModel {
    weak var coordinator: MainCoordinator?

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
}
