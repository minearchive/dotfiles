import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import {GLib, Variable} from "astal"

const time = Variable("").poll(1000, "date")

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
                <label className={"icon"} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER}>
                    
                </label>
            </box>

            <box halign={Gtk.Align.END}>

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