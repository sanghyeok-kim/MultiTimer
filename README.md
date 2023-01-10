# Multi+Timer

<br>

## MVVM Pattern
- Binding Tool: [RxSwift](https://github.com/ReactiveX/RxSwift)
- ViewType, ViewModelType을 추상화한 [MVVMInterface](https://github.com/sanghyeok-kim/MultiTimer/blob/main/Multimer/Multimer/Presentation/Support/Protocol/MVVMInterface.swift) 프로토콜 적용


## Features
- Persistence
  - Core Data 사용

- Localizing
  - English
  - Korean
  - Japanese
  - Chinese(Simplified)

<br>

## System Structure

```swift
Multimer/
├── Application/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Data/
│   ├── Persistence/
│   │   └── CoreData/
│   │       ├── CoreDataStorage/
│   │       │   ├── CoreDataStorage+TagColorMO.swift
│   │       │   ├── CoreDataStorage+TagMO.swift
│   │       │   ├── CoreDataStorage+TimeMO.swift
│   │       │   ├── CoreDataStorage+TimerMO.swift
│   │       │   └── CoreDataStorage.swift
│   │       ├── ManagedObjectSubclass/
│   │       │   ├── TagColorMO+CoreDataClass.swift
│   │       │   ├── TagMO+CoreDataClass.swift
│   │       │   ├── TimeMO+CoreDataClass.swift
│   │       │   └── TimerMO+CoreDataClass.swift
│   │       ├── Protocol/
│   │       │   ├── ManagedObjectConvertible.swift
│   │       │   └── ModelConvertible.swift  
│   │       └── TimerModel.xcdatamodeld/TimerModel.xcdatamodel    
│   └── Repository/
│       ├── Protocol/
│       │   └── TimerPersistentRepository.swift    
│       └── CoreDataTimerRepository.swift
├── Domain/
│   ├── Model/
│   │   ├── Factory/
│   │   │   ├── TimeFactory.swift
│   │   │   └── TimerFactory.swift
│   │   ├── Tag.swift
│   │   ├── TagColor.swift
│   │   ├── Time.swift
│   │   └── Timer.swift
│   └── UseCase/
│       ├── Protocol/
│       │   ├── MainUseCase.swift
│       │   └── TimerUseCase.swift
│       ├── CountDownTimerUseCase.swift
│       ├── CountUpTimerUseCase.swift
│       └── DefaultMainUseCase.swift
├── Presentation/
│   ├── Support/
│   │   ├── Common/
│   │   │   ├── PaddingButton.swift
│   │   │   └── SymbolImageButton.swift
│   │   ├── Enum/
│   │   │   ├── CustomColor.swift
│   │   │   ├── EditViewButtonType.swift
│   │   │   ├── TimeType.swift
│   │   │   ├── TimerFilteringCondition.swift
│   │   │   ├── TimerTableViewSection.swift
│   │   │   └── TimerType.swift
│   │   ├── Extension/
│   │   │   ├── TimerTableViewDiffableDataSource+Rx+update.swift
│   │   │   ├── UIImage+makeSFSymbolImage.swift
│   │   │   ├── UIPickerView+setFixedLabels.swift
│   │   │   ├── UIStackView+addArrangedSubviews.swift
│   │   │   ├── UITextField+Rx+textChanged.swift
│   │   │   ├── UITextField+addLeftPadding.swift
│   │   │   └── UIView+snapshotCellStyle.swift
│   │   ├── Factory/
│   │   │   └── TagColorFactory.swift
│   │   ├── Protocol/
│   │   │   ├── CellIdentifiable.swift
│   │   │   └── MVVMInterface.swift      
│   │   └── Constant.swift
│   ├── Main/
│   │   ├── MainViewController.swift
│   │   ├── MainViewModel.swift
│   │   ├── CustomView/
│   │   │   ├── EmptyTimerView.swift
│   │   │   ├── FilteringNavigationTitleView.swift
│   │   │   └── TimerEditingView.swift
│   │   └── TimerTableView/
│   │       ├── TimerTableViewDelegate.swift
│   │       └── TimerTableViewDiffableDataSource.swift
│   ├── TimerCreate/
│   │   ├── TimerCreateViewController.swift
│   │   └── TimerCreateViewModel.swift
│   ├── TimerSetting/
│   │   ├── TimerSettingViewController.swift
│   │   ├── TimerSettingViewModel.swift
│   │   ├── CustomView/
│   │   │   ├── TagButton.swift
│   │   │   └── TagScrollView.swift
│   │   └── TimePickerView/
│   │       ├── TimePickerView.swift
│   │       ├── TimePickerViewDataSource.swift
│   │       └── TimePickerViewDelegate.swift
│   └── TimerViewCell/
│       ├── TimerCellViewModel.swift
│       └── TimerViewCell.swift
├── Localizing/
│   ├── en.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   ├── ja.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   ├── ko.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   ├── zh-Hans.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   └── LocalizableString.swift
├── Info.plist
└── Localizable.strings
```
