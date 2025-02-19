//
//  CharacterListViewController.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import UIKit
import Combine
import SwiftUI

class CharacterListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let viewModel = CharacterViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        Task {
            await viewModel.fetchCharacters()
        }
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CharacterCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterCellTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        viewModel.refreshCharacters()
    }

    private func setupBindings() {
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isFetching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingFooter()
                } else {
                    self?.hideLoadingFooter()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let _ = errorMessage {
                    self?.showRetryFooter()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowRetry
               .receive(on: DispatchQueue.main)
               .sink { [weak self] shouldShowRetry in
                   if shouldShowRetry {
                       self?.showRetryFooter()
                   } else {
                       self?.hideRetryFooter()
                   }
               }
               .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopRefreshing), name: NSNotification.Name("StopRefreshing"), object: nil)
    }

    @objc private func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoadingFooter() {
        let footerView = UIActivityIndicatorView(style: .medium)
        footerView.startAnimating()
        tableView.tableFooterView = footerView
    }

    private func hideLoadingFooter() {
        tableView.tableFooterView = nil
    }

    @objc private func retryFetching() {
        tableView.tableFooterView = nil
        Task {
            await viewModel.fetchCharacters()
        }
    }
    
    private func showRetryFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = .systemRed
        retryButton.layer.cornerRadius = 8
        retryButton.frame = CGRect(x: 20, y: 10, width: footerView.frame.width - 40, height: 40)
        retryButton.addTarget(self, action: #selector(retryFetching), for: .touchUpInside)
        
        footerView.addSubview(retryButton)
        tableView.tableFooterView = footerView
    }

    private func hideRetryFooter() {
        tableView.tableFooterView = nil
    }

}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCellTableViewCell", for: indexPath) as! CharacterCellTableViewCell
        cell.configure(viewModel.characters[indexPath.row])
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 2, !viewModel.isFetching {
            Task {
                await viewModel.fetchCharacters()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = viewModel.characters[indexPath.row]
        let detailView = CharacterDetailView(character: selectedCharacter)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
