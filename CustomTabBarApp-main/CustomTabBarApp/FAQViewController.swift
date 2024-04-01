
import Foundation
import UIKit

class FAQViewController: UIViewController {

    let faqData: [(question: String, answer: String)] = [
        ("Как добавить новую задачу?", "Чтобы добавить новую задачу, нажмите на кнопку '+' и введите название задачи."),
        ("Как отметить задачу как выполненную?", "Чтобы отметить задачу как выполненную, нажмите на задачу в списке."),
        ("Можно ли отредактировать задачу после добавления?", "Да, вы можете отредактировать задачу, нажав на неё и затем отредактировав текст."),
        ("Как удалить задачу?", "Чтобы удалить задачу, проведите по ней влево и нажмите кнопку 'Удалить'."),
        ("Есть ли способ задать приоритет задачам?", "Да, вы можете задать приоритет задачам, перетаскивая их вверх или вниз в списке."),
        ("Можно ли добавить срок выполнения задачи?", "Да, вы можете добавить срок выполнения задачи, нажав на задачу и затем задав срок выполнения."),
        ("Как просмотреть выполненные задачи?", "Чтобы просмотреть выполненные задачи, переключитесь на вкладку 'Выполненные'."),
        ("Можно ли поделиться задачей с другими?", "Да, вы можете поделиться задачей с другими, нажав на задачу и затем выбрав опцию 'Поделиться'."),
        ("Есть ли способ категоризировать задачи?", "Да, вы можете категоризировать задачи, добавив к ним теги."),
        ("Как найти определенную задачу?", "Чтобы найти определенную задачу, используйте строку поиска в верхней части экрана.")
    ]


    let tableView = UITableView()
    var faqItems: [(question: String, answer: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FAQ"

        setupTableView()

        // Select 10 random FAQ items
        let randomIndices = Set<Int>(faqData.indices.shuffled().prefix(10))
        faqItems = randomIndices.map { faqData[$0] }
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
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let faqItem = faqItems[indexPath.row]
        cell.textLabel?.text = faqItem.question
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let faqItem = faqItems[indexPath.row]
        let alertController = UIAlertController(title: faqItem.question, message: faqItem.answer, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
