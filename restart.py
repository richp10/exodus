
#     Copyright 2006, Joe Hildebrand
#
#     This file is part of Exodus.
#
#     Exodus is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     Exodus is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with Exodus; if not, write to the Free Software
#     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

import win32gui, win32api, win32process, win32con
import sys
import traceback

key = win32api.RegOpenKey(win32con.HKEY_CURRENT_USER, "Software")
key = win32api.RegOpenKey(key, "Jabber")
key = win32api.RegOpenKey(key, "Exodus")
try:
    restart = win32api.RegOpenKey(key, "Restart")
except:
    sys.exit(0)
    
try:
    keys = []
    for i in range(0, win32api.RegQueryInfoKey(restart)[0]):
        keys.append(win32api.RegEnumKey(restart, i))

    for subkey in keys:
        skey = win32api.RegOpenKey(restart, subkey)
        cmdline = win32api.RegQueryValueEx(skey, "cmdline")[0]
        cwd = win32api.RegQueryValueEx(skey, "cwd")[0]
        print cmdline
        print cwd
        sui = win32process.STARTUPINFO()
        win32process.CreateProcess(None, cmdline,
                                   None, None, False, 0, None,
                                   cwd, sui)
        win32api.RegDeleteKey(restart, subkey)

    win32api.RegCloseKey(restart)
    win32api.RegDeleteKey(key, "Restart")
except Exception, e:
    print traceback.print_exc()
    sys.exit(0) # not an error

