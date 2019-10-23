//
//  UpdateContentPostRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct UpdatePostContentRouter: Router {

    var galleryViewModel: GalleryViewModel?
    init(viewModel: GalleryViewModel?) {
        self.galleryViewModel = viewModel
    }
    
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let updatePostContentVC = UpdatePostContentViewController(viewModel: self.galleryViewModel)
        RoutingExecutor.navigate(from: root, to: updatePostContentVC, transitionType: transitionType, animated: animated, completion: nil)
        return updatePostContentVC
    }
}
