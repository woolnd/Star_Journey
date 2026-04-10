//
//  PassportFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture

@Reducer
struct TracesFeature {
    
    @ObservableState
    struct State: Equatable {}
    
    enum Action: Equatable {}
    
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
