//
//  PassportFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TracesFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: Int = 0
        var trailEntries: [StarTrailEntry] = []
        var journalEntries: [StarJournalEntry] = []
        var currentMonth: Date = Date()
        var selectedDate: Date? = nil
        var selectedJournalEntry: StarJournalEntry? = nil
        var isCompassMode: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case tabSelected(Int)
        case previousMonthTapped
        case nextMonthTapped
        case dateTapped(Date)
        case dateDismissed
        case journalEntryTapped(StarJournalEntry)
        case journalDetailDismissed
        case journalEntriesLoaded([StarJournalEntry])
        case trailEntriesLoaded([StarTrailEntry])
        case compassModeTapped
        case compassModeClosed
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { send in
                    let trails = CoreDataService.shared.fetchAllTrailEntries()
                    let journals = CoreDataService.shared.fetchAllJournalEntries()
                    await send(.trailEntriesLoaded(trails))
                    await send(.journalEntriesLoaded(journals))
                }
            case let .tabSelected(tab):
                state.selectedTab = tab
                if tab == 1 {
                    state.selectedDate = Date()
                    return .run { send in
                        let journals = CoreDataService.shared.fetchAllJournalEntries()
                        await send(.journalEntriesLoaded(journals))
                    }
                }
                return .none
                
            case .previousMonthTapped:
                state.selectedDate = nil
                state.currentMonth = Calendar.current.date(
                    byAdding: .month, value: -1, to: state.currentMonth
                ) ?? state.currentMonth
                return .none
                
            case .nextMonthTapped:
                state.selectedDate = nil
                state.currentMonth = Calendar.current.date(
                    byAdding: .month, value: 1, to: state.currentMonth
                ) ?? state.currentMonth
                return .none
                
            case let .dateTapped(date):
                if let selected = state.selectedDate,
                   Calendar.current.isDate(selected, inSameDayAs: date) {
                    state.selectedDate = nil
                } else {
                    state.selectedDate = date
                }
                return .none
                
            case .dateDismissed:
                state.selectedDate = nil
                return .none
                
            case let .journalEntryTapped(entry):
                state.selectedJournalEntry = entry
                return .none
                
            case .journalDetailDismissed:
                state.selectedJournalEntry = nil
                return .run { send in
                    let journals = CoreDataService.shared.fetchAllJournalEntries()
                    await send(.journalEntriesLoaded(journals))
                }
                
            case let .journalEntriesLoaded(entries):
                state.journalEntries = entries
                return .none
                
            case let .trailEntriesLoaded(entries):
                state.trailEntries = entries
                return .none
                
            case .compassModeTapped:
                state.isCompassMode = true
                return .none

            case .compassModeClosed:
                state.isCompassMode = false
                return .run { send in
                    let journals = CoreDataService.shared.fetchAllJournalEntries()
                    await send(.journalEntriesLoaded(journals))
                }
            }
        }
    }
}
