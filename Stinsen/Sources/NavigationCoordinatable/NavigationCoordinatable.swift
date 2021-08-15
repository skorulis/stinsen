import Foundation
import SwiftUI
import Combine

/// The NavigationCoordinatable is used to represent a flow. If you want to push items to the stack you need to wrap this in a NavigationViewCoordinatable.
public protocol NavigationCoordinatable: Coordinatable {
    associatedtype Route: NavigationRoute
    associatedtype Start: View
    func resolveRoute(route: Route) -> Transition
    @ViewBuilder func start() -> Start
    var navigationStack: NavigationStack { get }
}

public extension NavigationCoordinatable {
    var dismissalAction: DismissalAction {
        get {
            navigationStack.dismissalAction
        } set {
            navigationStack.dismissalAction = newValue
        }
    }
    
    var childCoordinators: [AnyCoordinatable] {
        navigationStack.childCoordinators
    }
}

public extension NavigationCoordinatable {
    #warning("TODO: Move to NavigationRouter")
    func route(to route: Route) {
        let resolved = resolveRoute(route: route)
        self.navigationStack.append(resolved)
    }
    
    func coordinatorView() -> AnyView {
        return AnyView(
            NavigationCoordinatableView(
                id: -1,
                coordinator: self
            )
        )
    }
    
    func dismissChildCoordinator(_ childCoordinator: AnyCoordinatable, _ completion: (() -> Void)?) {
        self.navigationStack.popTo(childCoordinator)
    }
}
