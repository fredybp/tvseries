//
//  MockMainCoordinator.swift
//  TVSeriesTests
//
//  Created by Fred on 19/04/25.
//

import UIKit

@testable import TVSeries

class MockMainCoordinator: MainCoordinator {
    // Call counts
    private(set) var startCallCount = 0
    private(set) var navigateToDetailCallCount = 0
    private(set) var navigateToEpisodeDetailCallCount = 0
    private(set) var navigateToSettingsCallCount = 0
    private(set) var pinVerifiedCallCount = 0
    private(set) var navigateToPINSetupCallCount = 0
    
    // Parameters
    private(set) var showPassedToDetail: TVShow?
    private(set) var episodePassedToDetail: Episode?
    
    public init() {
        super.init(window: UIWindow(), pinService: MockPINService())
    }
    
    override func start() {
        startCallCount += 1
        super.start()
    }
    
    override func navigateToDetail(with show: TVShow) {
        navigateToDetailCallCount += 1
        showPassedToDetail = show
        super.navigateToDetail(with: show)
    }
    
    override func navigateToEpisodeDetail(episode: Episode) {
        navigateToEpisodeDetailCallCount += 1
        episodePassedToDetail = episode
        super.navigateToEpisodeDetail(episode: episode)
    }
    
    override func navigateToSettings() {
        navigateToSettingsCallCount += 1
        super.navigateToSettings()
    }
    
    override func pinVerified() {
        pinVerifiedCallCount += 1
    }
    
    
    override func navigateToPINSetup() {
        navigateToPINSetupCallCount += 1
    }
    
}
