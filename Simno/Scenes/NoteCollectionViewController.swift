//
//  NoteCollectionViewController.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit
import CoreData

class NoteCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NoteCollectionViewCellDelegate {

    var notes: [(title: String, description: String, date: String, color: UIColor)] = []
    var filteredNotes: [(title: String, description: String, date: String, color: UIColor)] = []
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
            notes = savedNotes.map { note in
                return (title: note.title ?? "", description: note.noteDescription ?? "", date: formatDate(note.date ?? Date()), color: note.color as? UIColor ?? .white)
            }
            filteredNotes = notes
            collectionView.reloadData()

            (parent as? MainViewController)?.updateEmptyTextLabelVisibility()
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
        }
    }

    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    func filterNotes(with searchText: String) {
        if searchText.isEmpty {
            filteredNotes = notes
        } else {
            filteredNotes = notes.filter { note in
                note.title.lowercased().contains(searchText.lowercased()) ||
                note.description.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCollectionViewCell
        let note = filteredNotes[indexPath.item]
        cell.configure(with: note.title, description: note.description, date: note.date, iconColor: note.color)
        cell.delegate = self
        return cell
    }

    // MARK: - NoteCollectionViewCellDelegate

    func didTapPinButton(on cell: NoteCollectionViewCell) {
        //TODO: - pin logic
        print("Заметка закреплена")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let dummyCell = NoteCollectionViewCell(frame: CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude))
        let note = filteredNotes[indexPath.item]
        dummyCell.configure(with: note.title, description: note.description, date: note.date, iconColor: note.color)
        dummyCell.layoutIfNeeded()

        let targetSize = CGSize(width: cellWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = dummyCell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return CGSize(width: cellWidth, height: size.height)
    }


    func didTapDeleteButton(on cell: NoteCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()

        do {
            let savedNotes = try context.fetch(fetchRequest)
            context.delete(savedNotes[indexPath.row])
            try context.save()

            notes.remove(at: indexPath.row)
            filteredNotes.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])

            (parent as? MainViewController)?.updateEmptyTextLabelVisibility()

        } catch {
            print("Failed to delete note: \(error.localizedDescription)")
        }
    }
}
