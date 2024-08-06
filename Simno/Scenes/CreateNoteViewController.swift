//
//  CreateNoteViewController.swift
//  Simno
//
//  Created by Владислав Горелов on 27.07.2024.
//

import UIKit

protocol CreateNoteDelegate: AnyObject {
    func didCreateNote(title: String, description: String, color: UIColor)
}

final class CreateNoteViewController: UIViewController {

    weak var delegate: CreateNoteDelegate?

    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Заголовок"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.textColor = .lightGray
        textField.layer.borderColor = UIColor.snCellBorder.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true  // Добавляем эту строку
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()


    let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.snCellBorder.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    let colors: [UIColor] = [
        .snColor1,
        .snColor2,
        .snColor3,
        .snColor4,
        .snColor5,
        .snColor6,
        .snColor7,
        .snColor8,
        .snColor9,
        .snColor10
    ]

    var selectedColor: UIColor = .snColor1

    // MARK: - Collection View Setup

    let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        return collectionView
    }()

    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = .snMainColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая заметка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // ==
    private let colorView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 24
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

    //==
        private let borderLayer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.lineWidth = 5
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor.clear.cgColor
            return layer
        }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snBackground
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        setupViews()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(colorCollectionView)
        view.addSubview(descriptionPlaceholderLabel)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 12),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 12),

            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor, constant: -24),

            colorCollectionView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -24),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 108),
            colorCollectionView.widthAnchor.constraint(equalToConstant: 248),

            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func createButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        delegate?.didCreateNote(title: title, description: description, color: selectedColor)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CreateNoteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        cell.configure(color: colors[indexPath.item], isSelected: colors[indexPath.item] == selectedColor)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.item]
    }

    // MARK: - Устанавливаем размер ячеек и отступы
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }

    // MARK: - Отступы для секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset: CGFloat = 24
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
}

// MARK: - ColorCell

class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"

    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 48),
            colorView.heightAnchor.constraint(equalToConstant: 48),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        if isSelected {
            colorView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            colorView.layer.borderWidth = 5
        } else {
            colorView.layer.borderColor = UIColor.clear.cgColor
            colorView.layer.borderWidth = 0
        }
    }
}

