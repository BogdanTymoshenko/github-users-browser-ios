//
//  AdditionalParameterMatcher.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import Cuckoo

func emptyList<T:Collection>() -> ParameterMatcher<T> {
    return ParameterMatcher { list in
        list.isEmpty
    }
}

func equal<T:Collection>(to:T) -> ParameterMatcher<T> where T.Iterator.Element:Equatable {
    return ParameterMatcher { actual in
        return actual.elementsEqual(to)
    }
}
