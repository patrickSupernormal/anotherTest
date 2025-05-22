import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tasks: [String] = []
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "To Do"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTask))

        tableView = UITableView(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    @objc private func addTask() {
        let alert = UIAlertController(title: "New Task",
                                      message: "Enter task name",
                                      preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Task" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self = self,
                  let text = alert.textFields?.first?.text,
                  !text.isEmpty else { return }
            self.tasks.append(text)
            self.tableView.insertRows(at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                                      with: .automatic)
        }))
        present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
