import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"

App.apply_css("")

App.start({
    css: style,
    main() {
        App.get_monitors().map(Bar)
    },
})
