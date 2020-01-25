//
//  \.swift
//  Whatchu
//
//  Created by Andrey Timchenko on 7/12/17.
//  Copyright © 2017 Gill. All rights reserved.
//

import Foundation
import SwiftMessages
/* Show message box on bottom screen */

class MessagesInteractor: NSObject {
    
    static let shared = MessagesInteractor()
    var snackView: SnackBar!
    
    func showSnack(withMessage message: String, backgroundColor: UIColor? = nil, showTop: Bool = true) {
        let snackView: SnackBar = try! SwiftMessages.viewFromNib()
        snackView.configureContent(body: message)
        if backgroundColor == nil {
            snackView.configureTheme(backgroundColor: UIColor.red, foregroundColor: .white, iconImage: nil, iconText: nil)
        }
        else {
            snackView.configureTheme(backgroundColor: backgroundColor!, foregroundColor: .white, iconImage: nil, iconText: nil)
        }
        
        snackView.titleLabel?.isHidden  = true
        snackView.button?.isHidden      = true
        
        var config = SwiftMessages.defaultConfig
        
        if showTop {
            config.presentationStyle = .top
        }
        else {
            config.presentationStyle = .bottom
        }
        
        config.duration = .seconds(seconds: 2)
        config.shouldAutorotate = true
        config.interactiveHide  = true
        
        SwiftMessages.show(config: config, view: snackView)
    }
    
}
