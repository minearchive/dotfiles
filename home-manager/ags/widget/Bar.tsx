import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import {bind, exec, GLib, Variable} from "astal"
import Battery from "gi://AstalBattery"
import Wifi from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"

export default function Bar(gdkMonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={gdkMonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <box className={"main"}>
            <Icon/>
        </box>
    </window>
}

function Icon() {
    return (
        <box className="icon">
            <label></label>
        </box>
    )
}
