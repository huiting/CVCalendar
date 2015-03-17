//
//  CVCalendarDayViewControlCoordinator.swift
//  CVCalendar
//
//  Created by E. Mozharovsky on 12/27/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

/// Singleton
private let instance = CVCalendarDayViewControlCoordinator()

// MARK: - Type work 

typealias DayView = CVCalendarDayView
typealias Appearance = CVCalendarViewAppearance
typealias Coordinator = CVCalendarCoordinator

/// Coordinator's control actions
protocol CVCalendarCoordinator {
    func performDayViewSingleSelection(dayView: DayView)
    func performDayViewRangeSelection(dayView: DayView)
}

class CVCalendarDayViewControlCoordinator: NSObject {
    // MARK: - Non public properties
    private var selectionSet = CVSet<DayView>()
    
    lazy var appearance: Appearance = {
        return Appearance.sharedCalendarViewAppearance
    }()
    
    // MARK: - Public properties
    var selectedDayView: CVCalendarDayView?
    var animator: CVCalendarViewAnimatorDelegate?
    class var sharedControlCoordinator: CVCalendarDayViewControlCoordinator {
        return instance
    }

    // MARK: - Private initialization
    private override init() { }
}

// MARK: - Animator side callback

extension CVCalendarDayViewControlCoordinator {
    func selectionPerformedOnDayView() {
        // TODO:
    }
    
    func deselectionPerformedOnDayView(dayView: DayView) {
        selectionSet.removeObject(dayView)
    }
}

// MARK: - Animator reference 

private extension CVCalendarDayViewControlCoordinator {
    func presentSelectionOnDayView(dayView: DayView) {
        animator?.animateSelection(dayView, withControlCoordinator: self)
    }
    
    func presentDeselectionOnDayView(dayView: DayView) {
        animator?.animateDeselection(dayView, withControlCoordinator: self)
    }
}

// MARK: - CVCalendarCoordinator

extension CVCalendarDayViewControlCoordinator: Coordinator {
    func performDayViewSingleSelection(dayView: DayView) {
        selectionSet.addObject(dayView)
        println(selectionSet.count)
        
        if selectionSet.count > 1 {
            let count = selectionSet.count-1
            for dayViewInQueue in selectionSet {
                if dayView != dayViewInQueue {
                    presentDeselectionOnDayView(dayViewInQueue)
                    
                }
                
            }
        }
        
        if let animator = animator {
            if selectedDayView != dayView {
                selectedDayView = dayView
                presentSelectionOnDayView(dayView)
            }
        } else {
            animator = dayView.calendarView.animator!
        }
    }
    
    func performDayViewRangeSelection(dayView: DayView) {
        println("Day view range selection found")
    }
}




