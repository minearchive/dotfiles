import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import {bind, GLib, Variable} from "astal"
import Battery from "gi://AstalBattery"
import Wifi from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"
// import Workspace from "gi://AstalWorkspace"

export default function Bar(gdkMonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={gdkMonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <centerbox>
            <box halign={Gtk.Align.START} >
                <label halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} className={"icon"}>
                    
                </label>
                <box className={"onBackground"}>
                    <Time/>
                </box>
            </box>

            <box halign={Gtk.Align.CENTER}>

            </box>

            <box halign={Gtk.Align.END}>
                <box className={"onBackground"} halign={Gtk.Align.END}>
                    <BluetoothLabel/>
                    <Separator/>
                    <WifiLabel/>
                    <Separator/>
                    <BatteryLevel/>
                </box>
            </box>
        </centerbox>
    </window>
}


function Time() {
    const englishWeekdays = [
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    ];

    const time = Variable<string>("").poll(1000, () => {
        const now = GLib.DateTime.new_now_local();

        const hourMinuteSecond = now.format("%H:%M:%S");
        const month = now.format("%-m"); // 月 (1〜12), `-`でゼロ詰めなし
        const day = now.format("%d");    // ゼロ詰めされた日付
        const weekdayIndex = parseInt(now.format("%u") as string) % 7;
        const weekday = englishWeekdays[weekdayIndex];

        return `${hourMinuteSecond} - ${month}/${day} (${weekday})`;
    });

    return <label
        className={"TimeBox"}
        onDestroy={() => time.drop()}
        label={time()}>
    </label>;
}

function WorkspaceLabel() {

}

function BluetoothLabel() {
    const bluetooth = Bluetooth.get_default()
    const connected = bind(bluetooth, "is_connected")
    const className = connected.as(c => c ? "Bluetooth connected" : "Bluetooth")

    const icon = bind(bluetooth, "is_powered").as(c => c ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic")

    return <box>
        <icon className={className} icon={icon}/>
    </box>
}

function WifiLabel() {
    const network = Wifi.get_default()
    const wifi = bind(network, "wifi")

    return <box visible={wifi.as(Boolean)}>
        {wifi.as(wifi => wifi && (
            <box>
                <icon
                    tooltipText={bind(wifi, "ssid").as(String)}
                    className="Wifi systemIcon"
                    icon={bind(wifi, "iconName")}
                />
                <label
                    label={bind(wifi, "ssid").as(p => p)}
                    className="WifiLabel"/>
            </box>
        ))}
    </box>
}

function BatteryLevel() {
    const bat = Battery.get_default()

    return <box className="tray"
                visible={bind(bat, "isPresent")}>
        <icon icon={bind(bat, "batteryIconName")} className={"systemIcon"} />
        <label label={bind(bat, "percentage").as(p =>
            `${Math.floor(p * 100)}%`
        )} />
    </box>
}

function Separator() {
    return <label className={"Separator"} label={"|"} />
}
