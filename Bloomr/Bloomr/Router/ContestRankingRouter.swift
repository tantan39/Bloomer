//
//  HomeContestRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/15/19.
//  Copyright © 2019 phdv. All rights reserved.
//

import Foundation

struct ContestRankingRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let contestRankingVC = ContestRankingViewController()
        RoutingExecutor.navigate(from: root, to: contestRankingVC, transitionType: transitionType)
        return contestRankingVC
    }
}
