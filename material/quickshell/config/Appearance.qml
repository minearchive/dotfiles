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
    }

    component AnimationEasings: JsonObject {
        // property list<real> standard: [Easing.InOutQuad, Easing.InOutCubic]
        // property list<real> smooth: [Easing.InOutCubic]
        // property list<real> sharp: [Easing.InOutBack]
        // property list<real> overshoot: [Easing.OutBack]
    }

    component AnimationSettings: JsonObject {
        property AnimationDurations durations: AnimationDurations { }
        property AnimationEasings easings: AnimationEasings { }
    }
}