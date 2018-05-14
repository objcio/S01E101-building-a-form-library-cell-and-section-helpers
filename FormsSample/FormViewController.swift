//
//  ViewController.swift
//  FormsSample
//
//  Created by Chris Eidhof on 22.03.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import UIKit

struct Hotspot {
    var isEnabled: Bool = true
    var password: String = "hello"
}

extension Hotspot {
    var enabledSectionTitle: String? {
        return isEnabled ? "Personal Hotspot Enabled" : nil
    }
}

func section<State>(_ renderedCells: [RenderedElement<FormCell, State>]) -> RenderedElement<Section, State> {
    let cells = renderedCells.map { $0.element }
    let strongReferences = renderedCells.flatMap { $0.strongReferences }
    let update: (State) -> () = { state in
        for c in renderedCells {
            c.update(state)
        }
    }
    return RenderedElement(element: Section(cells: cells, footerTitle: nil), strongReferences: strongReferences, update: update)
}

// todo DRY
func sections<State>(_ renderedSections: [RenderedElement<Section, State>]) -> RenderedElement<[Section], State> {
    let sections = renderedSections.map { $0.element }
    let strongReferences = renderedSections.flatMap { $0.strongReferences }
    let update: (State) -> () = { state in
        for c in renderedSections {
            c.update(state)
        }
    }
    return RenderedElement(element: sections, strongReferences: strongReferences, update: update)
}

func hotspotForm(context: RenderingContext<Hotspot>) -> RenderedElement<[Section], Hotspot> {
    let renderedToggle = uiSwitch(context: context, keyPath: \Hotspot.isEnabled)
    let renderedToggleCell = controlCell(title: "Personal Hotspot", control: renderedToggle)

    let renderedPasswordForm = buildPasswordForm(context)
    let nested = FormViewController(sections: renderedPasswordForm.element, title: "Personal Hotspot Password")
    
    let passwordCell = detailTextCell(title: "Password", keyPath: \Hotspot.password) {
        context.pushViewController(nested)
    }
    
    let toggleSection = section([renderedToggleCell])
//    updates.append { state in
//        toggleSection.footerTitle = state.enabledSectionTitle
//    }
    let passwordSection = section([passwordCell])

    return sections([toggleSection, passwordSection])
    
//    ], strongReferences: strongReferences + renderedPasswordForm.strongReferences) { state in
//        renderedPasswordForm.update(state)
//        passwordCell.update(state)
//        for u in updates {
//            u(state)
//        }
//    }
}

func buildPasswordForm(_ context: RenderingContext<Hotspot>) -> RenderedElement<[Section], Hotspot> {
    let renderedPasswordField = textField(context: context, keyPath: \.password)
    let renderedCell = controlCell(title: "Password", control: renderedPasswordField, leftAligned: true)
    return sections([section([renderedCell])])
}
