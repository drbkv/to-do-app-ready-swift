//import UIKit
//import CoreData
//
//class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var completedTasks: [Task] = []
//
//    let tableView = UITableView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTableView()
//
//        loadCompletedTasks()
//    }
//
//    func setupTableView() {
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//    }
//
//    func loadCompletedTasks() {
//        let fetchRequest: NSFetchRequest<Task> = NSFetchRequest<Task>(entityName: "Task")
//        fetchRequest.predicate = NSPredicate(format: "completed == true")
//        do {
//            completedTasks = try CoreDataStack.shared.context.fetch(fetchRequest)
//        } catch {
//            print("Failed to fetch completed tasks: \(error)")
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return completedTasks.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = completedTasks[indexPath.row].name
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let task = completedTasks.remove(at: indexPath.row)
//            CoreDataStack.shared.context.delete(task)
//            CoreDataStack.shared.saveContext()
//            tableView.reloadData()
//        }
//    }
//}


import UIKit
import CoreData

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var completedTasks: [Task] = []

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        fetchCompletedTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchCompletedTasks()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func fetchCompletedTasks() {
        let fetchRequest: NSFetchRequest<Task> = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "completed == true")
        do {
            completedTasks = try CoreDataStack.shared.context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch completed tasks: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = completedTasks[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = completedTasks.remove(at: indexPath.row)
            CoreDataStack.shared.context.delete(task)
            CoreDataStack.shared.saveContext()
            tableView.reloadData()
        }
    }
}
