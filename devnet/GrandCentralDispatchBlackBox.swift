//
//  GrandCentralDispatchBlackBox.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 1/18/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

