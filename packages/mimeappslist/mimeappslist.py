#!/usr/bin/env python3

from gi.repository import Gio
import sys

if len(sys.argv) != 2:
    print('Error: Exactly one command line argument needed')
    sys.exit(1)

for app in Gio.app_info_get_all_for_type(sys.argv[1]):
    print(app.get_id())
