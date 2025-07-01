import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import {bind, exec, GLib, Variable } from "astal"
import Battery from "gi://AstalBattery"
import Wifi from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"
import Gio from "gi://Gio?version=2.0";
import {registerFile} from "../utils/ColorCalculator";
import {writeFileAsync} from "astal/file"

export default function Bar(gdkMonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    console.log("AAAA")
    copyToSpace()

    return <window
        className="Bar"
        gdkmonitor={gdkMonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <box className={"main"}>
            <Icon icon={"󱄅"} label={""}></Icon>
        </box>
    </window>
}

function Icon({ icon = "", label = "" }: { icon?: string, label?: string }) {
    return (
        <box className="icon">
            <label label={icon} className={"icon-label " + label}/>
        </box>
    )
}

function copyToSpace() {
    writeFileAsync("~/.theme_runner.ts", "test").then(it => {
    })
}