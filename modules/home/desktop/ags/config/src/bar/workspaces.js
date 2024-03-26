import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { Widget } from 'resource:///com/github/Aylur/ags/widget.js';

function isWorkspaceOccupied(/** @type number */ id) {
  return (
    // @ts-ignore
    Hyprland.workspaces.filter(ws => ws.id == id && ws.windows != 0).length != 0
  );
}

const Workspace = (/** @type number */ index) =>
  Widget.Button({
    on_clicked: () => execAsync(`hyprctl dispatch workspace ${index}`),
    css: `min-width: 30px; min-height: 30px;`,
    child: Widget.Box({
      class_name:
        'workspace-icon' +
        (Hyprland.active.workspace.id == index ? ' focused' : '') +
        (isWorkspaceOccupied(index) ? ' occupied' : ''),

      hpack: 'center',
      vpack: 'center',
    }),
  });

export const Workspaces = () =>
  Widget.Box({
    class_name: 'workspaces',
    connections: [
      [
        Hyprland.active.workspace,
        self => {
          self.children = [...Array(10).keys()].map(i => Workspace(i + 1));
        },
      ],
    ],
  });
