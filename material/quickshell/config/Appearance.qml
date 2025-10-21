pragma Singleton

import QtQuick
import Quickshell.Io

JsonObject {
    property AnimationSettings animation: AnimationSettings { }

    component AnimationDurations: JsonObject {
        property int small: 150
        property int medium: 400
        property int large: 800
        property int extraLarge: 1200
        property int expressive_fast_spatial: 350
        property int expressive_default_spatial: 500
        property int expressive_slow_spatial: 650
        property int expressive_fast_effects: 150
        property int expressive_default_effects: 200
        property int expressive_slow_effects: 300
        property int standard_fast_spatial: 350
        property int standard_default_spatial: 500
        property int standard_slow_spatial: 750
        property int standard_fast_effects: 150
        property int standard_default_effects: 200
        property int standard_slow_effects: 300
    }

    component AnimationEasings: JsonObject {
        property list<real> expressive_fast_spatial: [0.42, 1.67, 0.21, 0.90]
        property list<real> expressive_default_spatial: [0.38, 1.21, 0.22, 1.00]
        property list<real> expressive_slow_spatial: [0.39, 1.29, 0.35, 0.98]
        property list<real> expressive_fast_effects: [0.31, 0.94, 0.34, 1.00]
        property list<real> expressive_default_effects: [0.34, 0.80, 0.34, 1.00]
        property list<real> expressive_slow_effects: [0.34, 0.88, 0.34, 1.00]
        property list<real> standard_fast_spatial: [0.27, 1.06, 0.18, 1.00]
        property list<real> standard_default_spatial: [0.27, 1.06, 0.18, 1.00]
        property list<real> standard_slow_spatial: [0.27, 1.06, 0.18, 1.00]
        property list<real> standard_fast_effects: [0.31, 0.94, 0.34, 1.00]
        property list<real> standard_default_effects: [0.34, 0.80, 0.34, 1.00]
        property list<real> standard_slow_effects: [0.34, 0.88, 0.34, 1.00]
    }

    component AnimationSettings: JsonObject {
        property AnimationDurations durations: AnimationDurations { }
        property AnimationEasings easings: AnimationEasings { }
    }
}