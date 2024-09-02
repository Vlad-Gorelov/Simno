//
//  NoteCollectionViewController.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit
import CoreData

final class NoteCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NoteCollectionViewCellDelegate {

    var notes: [Note] = []
    var filteredNotes: [Note] = []
    let collectionView: UICollectionView

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)

        filteredNotes = notes
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snBackground
        fetchNotes()
        setCollectionView()
    }

    func setCollectionView() {
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .snBackground
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: "NoteCell")

        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchNotes() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()

        do {
            let savedNotes = try context.fetch(fetchRequest)
            notes = savedNotes
            filteredNotes = notes.sorted { $0.isPinned && !$1.isPinned }
            collectionView.reloadData()

            (parent as? MainViewController)?.updateEmptyTextLabelVisibility()
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
        }
    }

    func filterNotes(with searchText: String) {
        if searchText.isEmpty {
            filteredNotes = notes.sorted { $0.isPinned && !$1.isPinned }
        } else {
            filteredNotes = notes.filter { note in
                (note.title?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (note.noteDescription?.lowercased().contains(searchText.lowercased()) ?? false)
            }.sorted { $0.isPinned && !$1.isPinned }
        }
        collectionView.reloadData()
    }

    func didTapPinButton(on cell: NoteCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let note = filteredNotes[indexPath.item]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Снимаем закрепление с других заметок
        if note.isPinned {
            note.isPinned = false
        } else {
            notes.forEach { $0.isPinned = false }
            note.isPinned = true
        }

        do {
            try context.save()
        } catch {
            print("Failed to update pin status: \(error.localizedDescription)")
        }

        fetchNotes() // Обновляем коллекцию
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCollectionViewCell
        let note = filteredNotes[indexPath.item]
        let color = note.color as? UIColor ?? .white

        cell.configure(with: note.title ?? "", description: note.noteDescription ?? "", date: formatDate(note.date ?? Date()), iconColor: color)
        cell.setPinned(note.isPinned)
        cell.delegate = self
        return cell
    }

    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let dummyCell = NoteCollectionViewCell(frame: CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude))
        let note = filteredNotes[indexPath.item]
        dummyCell.configure(with: note.title ?? "", description: note.noteDescription ?? "", date: formatDate(note.date ?? Date()), iconColor: (note.color as? UIColor) ?? .white)
        dummyCell.layoutIfNeeded()

        let targetSize = CGSize(width: cellWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = dummyCell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return CGSize(width: cellWidth, height: size.height)
    }

    func didTapDeleteButton(on cell: NoteCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }

        AlertHelper.showDeleteConfirmation(on: parent!) { confirmed in
            if confirmed {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()

                do {
                    let savedNotes = try context.fetch(fetchRequest)
                    context.delete(savedNotes[indexPath.row])
                    try context.save()

                    self.notes.remove(at: indexPath.row)
                    self.filteredNotes.remove(at: indexPath.row)
                    self.collectionView.deleteItems(at: [indexPath])

                    (self.parent as? MainViewController)?.updateEmptyTextLabelVisibility()

                } catch {
                    print("Failed to delete note: \(error.localizedDescription)")
                }
            }
        }
    }

    func didTapEditButton(on cell: NoteCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let note = filteredNotes[indexPath.row]
        let createNoteVC = CreateNoteViewController()
        createNoteVC.delegate = parent as? CreateNoteDelegate
        createNoteVC.configureForEditing(title: note.title ?? "", description: note.noteDescription ?? "", color: note.color as? UIColor ?? .white, note: note)
        present(createNoteVC, animated: true, completion: nil)
    }
}
