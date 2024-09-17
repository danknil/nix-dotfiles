import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

export const SimpleToggleButton = ({
    name,
    child,
    toggle,
    connection: [service, condition],
}) => Widget.Button({
    class_names: ['toggle-button', name],
    setup: self => self.hook(service, () => {
        self.toggleClassName('active', condition());
    }),
    child,
    on_clicked: toggle,
});
