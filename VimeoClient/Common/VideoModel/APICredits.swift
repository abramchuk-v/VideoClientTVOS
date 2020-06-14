//
//  APICredits.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/5/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking

/// Extend app configuration to provide a default configuration
extension AppConfiguration
{
    /// The default configuration to use for this application, populate your client key, secret, and scopes.
    /// Also, don't forget to set up your application to receive the code grant authentication redirect, see the README for details.
    static let defaultConfiguration = AppConfiguration(clientIdentifier: "40cd2959ae06102c636801f12e84cfa3c38b8656",
                                                       clientSecret: "sCYS1wgxvzvlskAQIz9iT2eF0dxqC3WPWcFXLOnB3FAwWN9b01nuWPfgYUMb4TnEfbcVxQi+GHDVBXGQRD0zrFcc2obH1sTRxJ3cKPksKX7j07tWmCcowTKn9v+ZVFS/",
                                                       scopes: [.VideoFiles], keychainService: "")
}

/// Extend vimeo client to provide a default client
extension VimeoClient
{
    /// The default client this application should use for networking, must be authenticated by an `AuthenticationController` before sending requests
    static let defaultClient = VimeoClient(appConfiguration: AppConfiguration.defaultConfiguration, configureSessionManagerBlock: nil)
}
