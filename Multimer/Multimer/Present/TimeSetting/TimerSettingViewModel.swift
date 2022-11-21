//
//  TimerSettingViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/07.
//

import RxSwift
import RxRelay

final class TimerSettingViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let tagDidSelect = PublishRelay<Tag?>()
        let nameTextFieldDidEdit = PublishRelay<String>()
        let timePickerViewDidEdit = PublishRelay<(hour: Int, minute: Int, second: Int)>()
        let completeButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let timer: BehaviorRelay<Timer>
        let newTimer = PublishRelay<Timer>()
    }
    
    let output: Output
    let input = Input()
    
    private let disposeBag = DisposeBag()
    
    init(timer: Timer) {
        self.output = Output(timer: BehaviorRelay<Timer>(value: timer))
        
        let timerState = Observable
            .combineLatest(
//                input.nameTextFieldDidEdit.ifEmpty(default: output.timer.value.name),
//                input.timePickerViewDidEdit.ifEmpty(default: output.timer.value.time.dividedSeconds)
                input.nameTextFieldDidEdit,
                input.timePickerViewDidEdit
                //맨 처음에 default값으로 기존에 있던 값 방출하도록 변경해야할듯? -> 둘 중 하나만 변경해도 변경되기 위함
                //지금 이 상태론 둘 중 하나만 변경하면 Combine 스트림으로 이벤트가 방출되지 않음 -> 이름 or 시간 둘 중 하나만 바꾸고싶어도 못바꿈
                input.tagDidSelect
            )
            .share()
        
        input.completeButtonDidTap
            .withLatestFrom(timerState)
            .withUnretained(self) { `self`, timerState -> Timer in
                let (name, time) = timerState
                print("last value: \(name)\(time)")
                return self.makeTimer(with: name, time: time)
                
                return Timer(
                    name: name,
                    tag: tag,
                    time: Time(hour: time.hour, minute: time.minute, second: time.second)
                )
            }
//            .distinctUntilChanged() // TODO: 버튼 여러번 누르면 무시 기능 추가 - 이거 아니면 tap 자체에 debounce, throttle로 할지?
            .bind(to: output.newTimer)
            .disposed(by: disposeBag)
    }
    
    private func makeTimer(with name: String, time: (hour: Int, minute: Int, second: Int)) -> Timer {
        let newTime = Time(hour: time.hour, minute: time.minute, second: time.second)
        return Timer(name: name, time: newTime) //TODO: Tag도 추가
    }
}
