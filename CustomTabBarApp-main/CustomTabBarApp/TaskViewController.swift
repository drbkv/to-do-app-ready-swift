//import UIKit
//import CoreData
//
//class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var tasks: [Task] = []
//
//    let tableView = UITableView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTableView()
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
//        addButton.tintColor = .black
//        navigationItem.rightBarButtonItem = addButton
//
//        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEdit))
//        editButton.tintColor = .black
//        navigationItem.leftBarButtonItem = editButton
//
//        loadTasks()
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
//    @objc func addTask() {
//        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "Enter task name"
//        }
//        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
//            guard let taskName = alertController?.textFields?.first?.text else { return }
//            let task = Task(context: CoreDataStack.shared.context)
//            task.name = taskName
//            task.completed = false
//            CoreDataStack.shared.saveContext()
//            self?.tasks.append(task)
//            self?.tableView.reloadData()
//        }
//        alertController.addAction(addAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func loadTasks() {
//        let fetchRequest: NSFetchRequest<Task> = NSFetchRequest<Task>(entityName: "Task")
//        do {
//            tasks = try CoreDataStack.shared.context.fetch(fetchRequest)
//        } catch {
//            print("Failed to fetch tasks: \(error)")
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tasks.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let task = tasks[indexPath.row]
//        cell.textLabel?.text = task.name
//        cell.accessoryType = task.completed ? .checkmark : .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let task = tasks[indexPath.row]
//        task.completed.toggle()
//        CoreDataStack.shared.saveContext()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
//
//    @objc func toggleEdit() {
//        tableView.setEditing(!tableView.isEditing, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
//            let task = self?.tasks[indexPath.row]
//            self?.tasks.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            
//            if let taskToDelete = task {
//                CoreDataStack.shared.context.delete(taskToDelete)
//                CoreDataStack.shared.saveContext()
//            }
//        }
//        
//        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (_, indexPath) in
//            self?.editTask(at: indexPath)
//        }
//        
//        return [deleteAction, editAction]
//    }
//
//    func editTask(at indexPath: IndexPath) {
//        let alertController = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.text = self.tasks[indexPath.row].name
//        }
//        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
//            guard let taskName = alertController.textFields?.first?.text else { return }
//            self?.tasks[indexPath.row].name = taskName
//            CoreDataStack.shared.saveContext()
//            self?.tableView.reloadData()
//        }
//        alertController.addAction(saveAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        // This method is required for editingStyle to work properly
//    }
//}
//
//
//

import UIKit
import CoreData
import AVFoundation

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tasks: [Task] = []
    var selectedTaskIndex: Int?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton

        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEdit))
        editButton.tintColor = .black
        navigationItem.leftBarButtonItem = editButton

        let recordButton = UIButton(type: .system)
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        recordButton.tintColor = .black
        recordButton.addTarget(self, action: #selector(startRecording), for: .touchDown)
        recordButton.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(cancelRecording), for: .touchUpOutside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: recordButton)

        loadTasks()
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

    @objc func addTask() {
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
            guard let taskName = alertController?.textFields?.first?.text else { return }
            let task = Task(context: CoreDataStack.shared.context)
            task.name = taskName
            task.completed = false
            CoreDataStack.shared.saveContext()
            self?.tasks.append(task)
            self?.tableView.reloadData()
        }
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }

    func loadTasks() {
        let fetchRequest: NSFetchRequest<Task> = NSFetchRequest<Task>(entityName: "Task")
        do {
            tasks = try CoreDataStack.shared.context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.accessoryType = task.completed ? .checkmark : .none

        if let _ = task.voiceNoteURL {
            cell.imageView?.image = UIImage(systemName: "mic.fill")
            cell.imageView?.tintColor = .black
        } else {
            cell.imageView?.image = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTaskIndex = indexPath.row
        let task = tasks[indexPath.row]
        task.completed.toggle()
        CoreDataStack.shared.saveContext()
        tableView.reloadRows(at: [indexPath], with: .automatic)

        if let voiceNoteURL = task.voiceNoteURL, let url = URL(string: voiceNoteURL) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Failed to play audio: \(error)")
            }
        }
    }

    @objc func toggleEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            let task = self?.tasks[indexPath.row]
            self?.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            if let taskToDelete = task {
                CoreDataStack.shared.context.delete(taskToDelete)
                CoreDataStack.shared.saveContext()
            }
        }

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (_, indexPath) in
            self?.editTask(at: indexPath)
        }

        return [deleteAction, editAction]
    }

    func editTask(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.tasks[indexPath.row].name
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let taskName = alertController.textFields?.first?.text else { return }
            self?.tasks[indexPath.row].name = taskName
            CoreDataStack.shared.saveContext()
            self?.tableView.reloadData()
        }
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // This method is required for editingStyle to work properly
    }

    @objc func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
        } catch {
            print("Recording failed")
        }
    }

    @objc func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        guard let taskIndex = selectedTaskIndex else { return }
        let task = tasks[taskIndex]
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        task.voiceNoteURL = audioFilename.absoluteString
        CoreDataStack.shared.saveContext()
        tableView.reloadData()
    }

    @objc func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
