//
//  MainViewController.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//


import UIKit

final class MainViewController: UIViewController, CreateNoteDelegate, UISearchBarDelegate {

    let collectionViewController = NoteCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snBackground
        setupSearchBar()
        setupCollectionView()
        setupNewNoteButton()
    }

    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self

        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear

        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionViewController.filterNotes(with: searchText)
    }

    private func setupCollectionView() {
        addChild(collectionViewController)
        view.addSubview(collectionViewController.view)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72)
        ])

        collectionViewController.didMove(toParent: self)
    }

    private func setupNewNoteButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "MainColor") ?? .blue
        button.setTitle(" Новая заметка", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)

        let plusImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])

        button.addTarget(self, action: #selector(newNoteButtonTapped), for: .touchUpInside)
    }

    @objc private func newNoteButtonTapped() {
        let createNoteVC = CreateNoteViewController()
        createNoteVC.delegate = self
        present(createNoteVC, animated: true, completion: nil)
    }

    func didCreateNote(title: String, description: String, color: UIColor) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())

        let newNote = (title: title, description: description, date: date, color: color)
        collectionViewController.notes.append(newNote)
        collectionViewController.filteredNotes = collectionViewController.notes
        collectionViewController.collectionView.reloadData()
    }
}
