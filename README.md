## 멀티 타이머
- [앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%A9%80%ED%8B%B0-%ED%83%80%EC%9D%B4%EB%A8%B8/id1663431308)

||||||
|----|----|----|----|----|
|![Apple iPhone 11 Pro Max Screenshot 0](https://user-images.githubusercontent.com/57667738/211595215-3d369b57-4aab-4f40-a49a-5f25e3e340ae.png)|![Apple iPhone 11 Pro Max Screenshot 1](https://user-images.githubusercontent.com/57667738/211595224-333bcefb-49e9-4be4-91ae-a72943e12c30.png)|![Apple iPhone 11 Pro Max Screenshot 2](https://user-images.githubusercontent.com/57667738/211595229-22140915-c00c-42a4-a366-acc723b63049.png)|![Apple iPhone 11 Pro Max Screenshot 3](https://user-images.githubusercontent.com/57667738/211595234-5dfbc463-db69-45db-98c4-1b18ce19e036.png)|![Apple iPhone 11 Pro Max Screenshot 4](https://user-images.githubusercontent.com/57667738/211595237-3389f136-01bf-4ca3-8953-025ca820bf13.png)|

<br>

## 📌 Features

|타이머(스톱워치) 생성 및 삭제|시작 / 일시정지 / 정지|완료 / 재시작|정렬|
|----|----|----|----|
|![CleanShot 2023-01-11 at 00 04 54](https://user-images.githubusercontent.com/57667738/211587047-f2213555-416f-486a-92b6-8f53b6057f83.gif)|![CleanShot 2023-01-10 at 18 20 40](https://user-images.githubusercontent.com/57667738/211511748-80131701-1831-4ecd-b4e9-30e72ad50d69.gif)|![CleanShot 2023-01-10 at 18 22 16](https://user-images.githubusercontent.com/57667738/211512102-2ef86af2-4183-4b2b-9fe2-f297cc396b31.gif)|![CleanShot 2023-01-11 at 00 06 40](https://user-images.githubusercontent.com/57667738/211587345-a7e395cd-8f81-4914-903a-5842a08cb5b0.gif)|


|다중 시작 / 일시정지 / 정지 / 삭제|활성화된 타이머 필터링|재시작시 남은 시간 불러오기|다크모드 커스텀 컬러 적용|
|----|----|----|----|
|![CleanShot 2023-01-11 at 00 26 48](https://user-images.githubusercontent.com/57667738/211592449-e1cb3bcb-4f73-4434-afb9-25fb90ebfd53.gif)|![CleanShot 2023-01-11 at 00 31 30](https://user-images.githubusercontent.com/57667738/211593606-a766ac02-0194-47d9-84d4-be6ac1655ca8.gif)|![CleanShot 2023-01-11 at 00 15 15](https://user-images.githubusercontent.com/57667738/211590194-96c03884-65ba-41f3-9c4f-eea769b8ecbf.gif)|![CleanShot 2023-01-11 at 00 23 22](https://user-images.githubusercontent.com/57667738/211591819-12a1965f-0b22-4d19-b5e3-4567ed502315.gif)|


<br>

## 🛠 Project Tech Stack
### MVVM Pattern - RxSwift
- MVVM binding tool로 RxSwift 사용 (+ RxCocoa, RxAppState)
- ViewType, ViewModelType을 추상화한 [MVVMInterface](https://github.com/sanghyeok-kim/MultiTimer/blob/main/Multimer/Multimer/Presentation/Support/Protocol/MVVMInterface.swift) 프로토콜 적용하여 Input - Output 구조 통일

### Persistence - Core Data
- 모델 설계 및 관계도  
  <img width="542" alt="CleanShot 2023-01-10 at 17 39 05@2x" src="https://user-images.githubusercontent.com/57667738/211502075-5fe18dfe-cfff-45bc-b784-d499c01d03cb.png">
  
- [ManagedObjectConvertible](https://github.com/sanghyeok-kim/MultiTimer/blob/main/Multimer/Multimer/Data/Persistence/CoreData/Protocol/ManagedObjectConvertible.swift), [ModelConvertible](https://github.com/sanghyeok-kim/MultiTimer/blob/main/Multimer/Multimer/Data/Persistence/CoreData/Protocol/ModelConvertible.swift)
  프로토콜을 통해 Model(Domain Layer) <-> NSManagedObject(Data Layer) 객체간 Mapping
- [CoreDataStorage](https://github.com/sanghyeok-kim/MultiTimer/blob/main/Multimer/Multimer/Data/Persistence/CoreData/CoreDataStorage/CoreDataStorage.swift) 구현하여 Background Context에서 CRUD 수행 (U를 제외한 CRD는 제네릭을 활용하여 코드 재사용)
- 타이머 실행 중 앱 종료 후 재시작해도 이전 실행 상태를 복구 (이전 실행 시점과 재시작한 시점의 시간차 계산)

### Localizing
  - English
  - Korean
  - Japanese
  - Chinese(Simplified)

<br>

## 🗂 System Structure

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

<br>

## 📝 Release
- 1.0.1
  - 마케팅 URL이 추가되었습니다.
