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
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
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

    let colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snBackground
        setupViews()
    }

    private func setupViews() {
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(colorStackView)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            colorStackView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            colorStackView.heightAnchor.constraint(equalToConstant: 50),

            createButton.topAnchor.constraint(equalTo: colorStackView.bottomAnchor, constant: 16),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        setupColorButtons()
    }

    private func setupColorButtons() {
        for color in colors {
            let button = UIButton()
            button.backgroundColor = color
            button.layer.cornerRadius = 25
            button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
            colorStackView.addArrangedSubview(button)
        }
    }

    @objc private func colorButtonTapped(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        selectedColor = color
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
