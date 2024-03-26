import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

/**
 * @param {string} layoutName
 */
function parseLayout(layoutName) {
  if (layoutName.includes("English")) return "En";
  if (layoutName.includes("Russian")) return "Ru";
  return "";
}

async function getLayout() {
  const layout = await Hyprland.sendMessage("j/devices");
  return parseLayout(
    JSON.parse(layout).keyboards.filter((k) => k.layout === "us,ru")[0]
      .active_keymap,
  );
}

const Layout = () =>
  Widget.Label({
    class_name: "icons layout",
    hpack: "center",
    vpack: "center",
    label: "",
    setup: (self) => getLayout().then((l) => (self.label = l)),
    connections: [
      [
        Hyprland,
        (self, _, layoutName) => {
          if (layoutName === undefined) return;
          // @ts-ignore
          self.label = parseLayout(layoutName);
        },
        "keyboard-layout",
      ],
    ],
  });

const WifiIndicator = () =>
  Widget.Icon({
    // @ts-ignore
    icon: Network.wifi.bind("icon-name"),
  });

const WiredIndicator = () =>
  Widget.Icon({
    // @ts-ignore
    icon: Network.wired.bind("icon-name"),
  });

const NetworkIndicator = () =>
  Widget.Stack({
    items: [
      ["wifi", WifiIndicator()],
      ["wired", WiredIndicator()],
    ],
    shown: Network.bind("primary").transform((p) => p || "wired"),
    class_name: "icons network",
    hpack: "center",
    vpack: "center",
  });

const BatteryInfo = () =>
  Widget.Box({
    visible: Battery.bind("available"),
    class_name: "icons battery",
    hpack: "center",
    vpack: "center",
    children: [
      // Widget.Label({
      //   label: Battery.bind("percent").transform((p) =>
      //     p > 0 ? `${Battery.percent}%` : "",
      //   ),
      // }),
      Widget.CircularProgress({
        value: Battery.bind("percent").transform((p) => (p > 0 ? p / 100 : 0)),
        start_at: 0.75,
        class_name: Battery.bind("charging").transform((ch) =>
          ch ? "battery-icon charging" : "battery-icon",
        ),
      }),
    ],
  });
const Volume = () =>
  Widget.Button({
    // @ts-ignore
    onClicked: () => (Audio.speaker.is_muted = !Audio.speaker.is_muted),
    class_name: "icons volume",
    hpack: "center",
    vpack: "center",
    child: Widget.Icon().hook(
      Audio,
      (self) => {
        if (!Audio.speaker) return;

        const vol = Audio.speaker.volume * 100;
        const icon = [
          [101, "overamplified"],
          [67, "high"],
          [34, "medium"],
          [1, "low"],
          [0, "muted"],
        ].find(([threshold]) => threshold <= vol)[1];

        self.icon = `audio-volume-${icon}-symbolic`;
      },
      "speaker-changed",
    ),
  });

export const Icons = () =>
  Widget.Box({
    spacing: 5,
    homogeneous: true,
    class_name: "icons-box",
    hpack: "center",
    vpack: "center",
    setup: (self) => {
      self.children = [NetworkIndicator(), Volume(), Layout(), BatteryInfo()];
    },
  });
