//
//  PopFormViewController.swift
//  Swift_POP_Form
//
//  Created by Aaron bikis on 5/14/18.
//  Copyright © 2018 Aaron bikis. All rights reserved.
//

import UIKit


typealias PopFormViewControllerCallback = (Bool, [String]?)

protocol PopFormViewControllerDelegate: class {
  func formWasValidated(callback: PopFormViewControllerCallback)
}

/// Can be either embeded in another VC or presented on its own.
/// By setting up the whole datasource elsewhere you can pass in an instance of *PopForm_DataSource* to create an instance of this viewcontroller
final class PopFormViewController: UIViewController {
  
  weak var delegate: PopFormViewControllerDelegate?
  
  var shouldValidateOnLastFieldReturnKeyTap = true
  
  private var viewModel: PopForm_ViewModel
 
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.delegate = self
    tv.dataSource = viewModel
    tv.backgroundColor = viewModel.dataSource.theme.backgroundColor
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.register(PopFormTableViewCell.self, forCellReuseIdentifier: PopFormTableViewCell.ReuseID)
    view.addSubview(tv)
    return tv
  }()
  
  private var validator = Validator()
  
  
  init(dataSource: PopFormDataSource){
    self.viewModel = PopForm_ViewModel(dataSource: dataSource)
    super.init(nibName: nil, bundle: nil)
    self.viewModel.delegate = self
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder: not supported")
  }
  
  
  override func loadView() {
    view = UIView()
    view.backgroundColor = UIColor.white // add to theme
    view.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  
  func validateForm(){
    validator.validate(self)
  }
}


extension PopFormViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.dataSource.fields[indexPath.row].theme.height
  }
}

extension PopFormViewController: PopForm_ViewModelDelegate {
  func registerForValidation(validatable: UITextField, rules: [Rule]) {
    validator.registerField(validatable, rules: rules)
    validatable.delegate = self
  }
}

extension PopFormViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let cell = textField.superview as? PopFormTableViewCell else {
      fatalError() }
    
    guard let currentIndex = tableView.indexPath(for: cell) else {
      fatalError("cell does not exist") }
    
    let nextIndex = IndexPath(row: currentIndex.row + 1, section: currentIndex.section)
    let isLastField = viewModel.dataSource.fields.count == nextIndex.row
    
    if isLastField {
      cell.textField.resignFirstResponder()
      if shouldValidateOnLastFieldReturnKeyTap {
        validator.validate(self)
      }
      return true
    }
    
    guard let nextCell = tableView.cellForRow(at: nextIndex) as? PopFormTableViewCell else {
      fatalError() }
    
    nextCell.textField.becomeFirstResponder()
    return true
  }
}

extension PopFormViewController: ValidationDelegate {
  func validationSuccessful() {
    delegate?.formWasValidated(callback: (true, nil))
  }

  func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    delegate?.formWasValidated(callback: (false, errors.map({ $0.1.errorMessage })))
  }
}
