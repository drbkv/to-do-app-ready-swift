
import UIKit
import CoreData

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }

    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: UINavigationController(rootViewController: TaskViewController()), // Используем TaskViewController в навигационной панели
                title: "Tasks", // Название вкладки
                image: UIImage(systemName: "list.bullet") // Иконка вкладки
            ),
            generateVC(
                viewController: UINavigationController(rootViewController: CompletedViewController()), // Используем CompletedViewController в навигационной панели
                title: "Completed", // Название вкладки
                image: UIImage(systemName: "checkmark.circle.fill") // Иконка вкладки
            ),
            generateVC(
                viewController: UINavigationController(rootViewController: FAQViewController()),
                title: "FAQ",
                image: UIImage(systemName: "questionmark.circle.fill")
            )

        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.white.cgColor
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
    }
}

