//
//  ContestAlbumRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct ContestAlbumRouter: Router {
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let contestAlbum = ContestAlbumViewController()
        RoutingExecutor.navigate(from: root, to: contestAlbum, transitionType: transitionType, animated: animated)
        return contestAlbum
    }
}
