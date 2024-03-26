// importing
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { Workspaces } from './workspaces.js';
import { Icons } from './quick_settings/icons.js';

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, just make it a function
// then you can use it by calling simply calling it

const Clock = () =>
  Widget.Label({
    class_name: 'clock',
    connections: [
      // this is what you should do
      [
        1000,
        self =>
          execAsync(['date', '+%H:%M'])
            .then(date => (self.label = date))
            .catch(console.error),
      ],
    ],
  });

// layout of the bar
const Left = () =>
  Widget.Box({
    class_name: 'start',
    hpack: 'start',
    children: [Workspaces()],
  });

const Center = () =>
  Widget.Box({
    class_name: 'center',
    hpack: 'center',
    children: [
      Clock(),
      // Media(),
      // Notification(),
    ],
  });

const Right = () =>
  Widget.Box({
    class_name: 'end',
    hpack: 'end',
    children: [
      Icons(),
      // Volume(),
      // BatteryLabel(),
      // SysTray(),
    ],
  });

export const Bar = ({ monitor } = { monitor: 0 }) =>
  Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    margins: [5, 30, 0],
    child: Widget.CenterBox({
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });
