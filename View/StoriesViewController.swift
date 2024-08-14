//
//  ViewController.swift
//  TheGlobe
//
//  Created by Wu Yian on 2024-08-13.
//

import UIKit

class StoriesViewController: UIViewController {
    
    var storiesViewModel = StoriesViewModel()
    
    // MARK: UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.register(StoryCell.self, forCellReuseIdentifier: StoryCell.Constant.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchStories()
        view.backgroundColor = .white
        buildUI()
        setUpConstraint()
    }
    
    private func fetchStories() {
        Task {
            await storiesViewModel.fetchStories()
            self.tableView.reloadData()
        }
    }
    
    func buildUI() {
        view.addSubview(tableView)
    }
    
    func setUpConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - Table Delegate and DataSource
extension StoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storiesViewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.Constant.reuseIdentifier, for: indexPath) as? StoryCell else {
            return UITableViewCell()
        }
        
        cell.configure(storyCellViewModel: storiesViewModel.story(at: indexPath.row))
        
        return cell
    }
}

