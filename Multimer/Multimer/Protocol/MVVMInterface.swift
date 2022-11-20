//
//  MVVMInterface.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

protocol ViewType: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel? { get set }
    
    func bindInput(to viewModel: ViewModel)
    func bindOutput(from viewModel: ViewModel)
}

extension ViewType {
    func bind(to viewModel: ViewModel) {
        self.viewModel = viewModel
        bindInput(to: viewModel)
        bindOutput(from: viewModel)
    }
}
