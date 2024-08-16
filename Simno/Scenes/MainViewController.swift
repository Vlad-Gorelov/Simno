//
//  MainViewController.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit

final class MainViewController: UIViewController, CreateNoteDelegate, UISearchBarDelegate {

    //MARK: - Properties

    let collectionViewController = NoteCollectionViewController()
    var isSortedAscending = true

    private let emptyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас ещё нет заметок"
        label.textColor = .snText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.isHidden = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snBackground
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupNewNoteButton()
        setupEmptyTextLabel()
        hideKeyboard()
    }

    //MARK: - Methods

    private func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupNavigationBar() {
        title = "Simno"

        let filterButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .snText
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupEmptyTextLabel() {
        view.addSubview(emptyTextLabel)
        view.bringSubviewToFront(emptyTextLabel)
        emptyTextLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionViewController.filterNotes(with: searchText)

        if collectionViewController.filteredNotes.isEmpty {
            updateEmptyTextLabelVisibility(withText: "Заметок не найдено")
        } else {
            updateEmptyTextLabelVisibility()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupCollectionView() {
        addChild(collectionViewController)
        view.addSubview(collectionViewController.view)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

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

    func didCreateNote(title: String, description: String, color: UIColor) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let newNote = (title: title, description: description, date: date, color: color)
        collectionViewController.notes.append(newNote)
        collectionViewController.filteredNotes = collectionViewController.notes
        collectionViewController.collectionView.reloadData()

        updateEmptyTextLabelVisibility()
    }

    private func updateEmptyTextLabelVisibility(withText text: String? = nil) {
        let isEmpty = collectionViewController.filteredNotes.isEmpty
        if let text = text {
            emptyTextLabel.text = text
        } else {
            emptyTextLabel.text = "У вас ещё нет заметок"
        }
        emptyTextLabel.isHidden = !isEmpty
    }

    //MARK: - Obj-C

    @objc private func filterButtonTapped() {
        isSortedAscending.toggle()

        if isSortedAscending {
            collectionViewController.filteredNotes.sort { $0.title.lowercased() < $1.title.lowercased() }
        } else {
            collectionViewController.filteredNotes.sort { $0.title.lowercased() > $1.title.lowercased() }
        }

        UIView.transition(with: collectionViewController.collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionViewController.collectionView.reloadData()
        }, completion: nil)
    }

    @objc private func newNoteButtonTapped() {
        let createNoteVC = CreateNoteViewController()
        createNoteVC.delegate = self
        present(createNoteVC, animated: true, completion: nil)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
