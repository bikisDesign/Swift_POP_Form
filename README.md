**POP! A form builder written in Swift**

[![Build Status](https://travis-ci.com/bikisDesign/Swift_POP_Form.svg?branch=master)](https://travis-ci.com/bikisDesign/Swift_POP_Form)[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A basic form creation system that uses MVVM and POP to quickly create and customize iOS forms

It uses [SwiftValidator](https://github.com/SwiftValidatorCommunity/SwiftValidator) and for it's validation

**Documentation** 

Regularly updated documentation can be found here [bikisdesign.github.io/Swift_POP_Form](https://bikisdesign.github.io/Swift_POP_Form/)

**Quick Start Guide**

Let's start by creating a field's datasource:

`private struct FirstName_Field: PopFormFieldDataSource {`

  `var prefilledText: String?`

  `var theme: PopFormFieldTheme = TextFieldTheme()`

  `var placeholder: String = "First Name"`

  `var apiKey: String = "firstName"`

  `var validationRule: [Rule]? = [RequiredRule(message: "First Name is Required")]`

  `var returnKey: UIReturnKeyType? = .next`

  `var autoCapitilization: UITextAutocapitalizationType = .words`

`}`

Then add some field styling:

`private struct TextFieldTheme: PopFormFieldTheme {`

  `var focusedColor: UIColor = UIColor.lightGray`

  `var textfieldFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .light)`

  `var borderOpacity: Float = 0.85`

  `var textAlignment: NSTextAlignment = .center`

  `var borderIsUnderline: Bool = false`

  `var errorColor: UIColor = .red`

  `var backgroundColor: UIColor = UIColor.white`

  `var textColor: UIColor = UIColor.black`

  `var placeholderTextColor: UIColor = UIColor.lightGray`

  `var borderColor: UIColor = UIColor.lightGray`

  `var borderWidth: CGFloat = 0.5`

  `var height: CGFloat = 65`

  `var textFieldHeight: CGFloat = 60`

  `var textViewHeight: CGFloat = 120`

  `var cursorColor: UIColor = UIColor.blue`

`}`

Now add styling for the form itself:

`private struct FormTheme: PopFormTheme {`

  `var backgroundColor: UIColor = .white`

  `var formColor: UIColor = .white`

`}`



Now create your form:

`struct PersonalInformationForm: PopFormDataSource {`

  `var fields: PopFormFields = [FirstName_Field(),`

​                               `LastName_Field(),`

​                               `Zip_Field(),`

​                               `PhoneNumber_Field(),`

​                               `Occupation_Field(),`

​                               `Notes_Field(),`

​                               `Birthday_Field()]`

  `var theme: PopFormTheme = FormTheme()`

`}`



Lastly, create an instance of a *PopFormViewController* and pass the form datasource to it:

  `private lazy var formVC: PopFormViewController = {`

​    `let f = PopFormViewController(dataSource: formDataSource)`

​    `f.delegate = self`

​    `return f`

  `}()`

![Alt Text](https://raw.githubusercontent.com/bikisDesign/Swift_POP_Form/master/demo/popFormDemo.gif)




