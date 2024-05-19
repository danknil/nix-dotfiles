import { Widget } from "resource:///com/github/Aylur/ags/widget.js";

export default ( { name, child, ...rest } ) => Widget.Window({
  ...rest,
  name,
  class_names: ['popup-window', name],
  visible: false,
  popup: true,
  focusable: true,
  setup: self => self.child.toggleClassName('window-content'),
  child: Widget.Box({
    class_names: ['popup-window', name, 'background'],
    child,
  })
});
