//
//  Officeworks_iOSClientApp.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

@main
struct Officeworks_iOSClientApp: App {

    private let dependencyContainer: AppDependencyContainer

    @StateObject private var coordinator: AppCoordinator

    init() {
        let container = AppDependencyContainer()

        self.dependencyContainer = container

        _coordinator = StateObject(
            wrappedValue: container.appCoordinator
        )
    }

    var body: some Scene {
        WindowGroup {
            ProductListView(
                dependencyContainer: dependencyContainer,
                coordinator: coordinator
            )
        }
    }
}
