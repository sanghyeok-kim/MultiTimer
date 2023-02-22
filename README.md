<div align="center">

# 멀티 타이머

[<img src="https://user-images.githubusercontent.com/57667738/211710982-9acc94d6-b49b-48fd-833c-b21e96941835.png" width=150 height=150>](https://apps.apple.com/kr/app/%EB%A9%80%ED%8B%B0-%ED%83%80%EC%9D%B4%EB%A8%B8/id1663431308?itsct=apps_box_link&itscg=30200)

[<img src="https://user-images.githubusercontent.com/52783516/149344077-32d9e68e-79bb-4d24-aab4-8c320a241d7c.png" width=20%>](https://apps.apple.com/kr/app/%EB%A9%80%ED%8B%B0-%ED%83%80%EC%9D%B4%EB%A8%B8/id1663431308?itsct=apps_box_link&itscg=30200)

[<img src="https://user-images.githubusercontent.com/57667738/215927346-2bff9839-4625-4df9-8119-e48c32269430.jpg" width=15%>](https://apps.apple.com/kr/app/%EB%A9%80%ED%8B%B0-%ED%83%80%EC%9D%B4%EB%A8%B8/id1663431308?itsct=apps_box_link&itscg=30200)


### 직관적인 다중 타이머 & 스톱워치

</div>

||||||
|----|----|----|----|----|
|![Apple iPhone 11 Pro Max Screenshot 0](https://user-images.githubusercontent.com/57667738/211595215-3d369b57-4aab-4f40-a49a-5f25e3e340ae.png)|![Apple iPhone 11 Pro Max Screenshot 1](https://user-images.githubusercontent.com/57667738/211595224-333bcefb-49e9-4be4-91ae-a72943e12c30.png)|![Apple iPhone 11 Pro Max Screenshot 2](https://user-images.githubusercontent.com/57667738/211595229-22140915-c00c-42a4-a366-acc723b63049.png)|![Apple iPhone 11 Pro Max Screenshot 3](https://user-images.githubusercontent.com/57667738/211595234-5dfbc463-db69-45db-98c4-1b18ce19e036.png)|![Apple iPhone 11 Pro Max Screenshot 4](https://user-images.githubusercontent.com/57667738/211595237-3389f136-01bf-4ca3-8953-025ca820bf13.png)|

<br>

## 📌 Features

|생성 / 삭제|시작 / 일시정지 / 정지|완료 / 재시작|정렬|
|----|----|----|----|
|![CleanShot 2023-01-11 at 00 04 54](https://user-images.githubusercontent.com/57667738/211587047-f2213555-416f-486a-92b6-8f53b6057f83.gif)|![CleanShot 2023-01-10 at 18 20 40](https://user-images.githubusercontent.com/57667738/211511748-80131701-1831-4ecd-b4e9-30e72ad50d69.gif)|![CleanShot 2023-01-10 at 18 22 16](https://user-images.githubusercontent.com/57667738/211512102-2ef86af2-4183-4b2b-9fe2-f297cc396b31.gif)|![CleanShot 2023-01-11 at 00 06 40](https://user-images.githubusercontent.com/57667738/211587345-a7e395cd-8f81-4914-903a-5842a08cb5b0.gif)|


|다중 선택|활성화된 타이머 필터링|재시작시 상태 복구|다크모드 커스텀 컬러|
|----|----|----|----|
|![CleanShot 2023-01-11 at 00 26 48](https://user-images.githubusercontent.com/57667738/211592449-e1cb3bcb-4f73-4434-afb9-25fb90ebfd53.gif)|![CleanShot 2023-01-11 at 00 31 30](https://user-images.githubusercontent.com/57667738/211593606-a766ac02-0194-47d9-84d4-be6ac1655ca8.gif)|![CleanShot 2023-01-11 at 00 15 15](https://user-images.githubusercontent.com/57667738/211590194-96c03884-65ba-41f3-9c4f-eea769b8ecbf.gif)|![CleanShot 2023-01-11 at 00 23 22](https://user-images.githubusercontent.com/57667738/211591819-12a1965f-0b22-4d19-b5e3-4567ed502315.gif)|

<br>

## 🗂 System Structure

```swift
Multimer/
├── Application/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Presentation/
│   ├── Support/
│   │   ├── Constant.swift
│   │   ├── Common/
│   │   │   ├── PaddingButton.swift
│   │   │   ├── SymbolImageButton.swift
│   │   │   └── NameTextField.swift
│   │   ├── Enum/
│   │   │   ├── CustomColor.swift
│   │   │   ├── EditViewButtonType.swift
│   │   │   ├── TimeType.swift
│   │   │   ├── TimerFilteringCondition.swift
│   │   │   ├── TimerTableViewSection.swift
│   │   │   ├── TimerType.swift
│   │   │   └── ToolbarType.swift
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
│   │   └── Protocol/
│   │       ├── CellIdentifiable.swift
│   │       └── MVVMInterface.swift      
│   ├── Main/
│   │   ├── MainViewController.swift
│   │   ├── MainViewModel.swift
│   │   ├── TimerViewCell/
│   │   │   ├── TimerCellViewModel.swift
│   │   │   └── TimerViewCell.swift
│   │   ├── TimerTableView/
│   │   │   ├── TimerTableViewDelegate.swift
│   │   │   └── TimerTableViewDiffableDataSource.swift
│   │   └── CustomView/
│   │       ├── SwipeRightToStopNoticeView.swift
│   │       ├── EmptyTimerView.swift
│   │       ├── FilteringNavigationTitleView.swift
│   │       └── TimerEditingView.swift
│   ├── TimerCreate/
│   │   ├── TimerCreateViewController.swift
│   │   └── TimerCreateViewModel.swift
│   └── TimerSetting/
│       ├── TimerSettingViewController.swift
│       ├── TimerSettingViewModel.swift
│       ├── CustomView/
│       │   ├── TagButton.swift
│       │   └── TagScrollView.swift
│       └── TimePickerView/
│           ├── TimePickerView.swift
│           ├── TimePickerViewDataSource.swift
│           └── TimePickerViewDelegate.swift
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
├── Data/
│   ├── Persistence/
│   │   └── CoreData/
│   │       ├── CoreDataStorage/
│   │       │   ├── CoreDataStorage+TagColorMO.swift
│   │       │   ├── CoreDataStorage+TagMO.swift
│   │       │   ├── CoreDataStorage+TimeMO.swift
│   │       │   ├── CoreDataStorage+TimerMO.swift
│   │       │   ├── CoreDataStorage.swift
│   │       │   └── CoreDatError.swift
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
├── Localizing/
│   ├── LocalizableString.swift
│   ├── en.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   ├── ja.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   ├── ko.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   ├── vi.lproj/
│   │   ├── InfoPlist.strings
│   │   └── Localizable.strings
│   └── zh-Hans.lproj/
│       ├── InfoPlist.strings
│       └── Localizable.strings
└── Info.plist
```

<br>

## 📝 Latest Release
- [1.3.0](https://github.com/sanghyeok-kim/MultiTimer/releases/tag/1.3.0)
