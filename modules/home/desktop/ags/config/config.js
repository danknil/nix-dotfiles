// importing
import App from 'resource:///com/github/Aylur/ags/app.js';
import { Bar } from './src/bar/bar.js';

// exporting the config so ags can manage the windows
export default {
  style: App.configDir + '/src/style.css',
  windows: [
    Bar({ monitor: 0 }),

    // you can call it, for each monitor
    // Bar({ monitor: 0 }),
    // Bar({ monitor: 1 })
  ],
};
