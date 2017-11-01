
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
import sys, time


def isDelphi(pid):
    h = win32api.OpenProcess(win32con.PROCESS_ALL_ACCESS, 0, pid)
    for mod in [win32process.GetModuleFileNameEx(h, x) for x in
                win32process.EnumProcessModules(h)]:
        if 'delphi32.exe' in  mod:
            return True
    return False

# clean up old restart records
key = win32api.RegOpenKey(win32con.HKEY_CURRENT_USER, "Software")
key = win32api.RegOpenKey(key, "Jabber")
key = win32api.RegOpenKey(key, "Exodus")
try:
    restart = win32api.RegOpenKey(key, "Restart")

    keys = []
    for i in range(0, win32api.RegQueryInfoKey(restart)[0]):
        keys.append(win32api.RegEnumKey(restart, i))
    for subkey in keys:
        win32api.RegDeleteKey(restart, subkey)

    win32api.RegCloseKey(restart)
    win32api.RegDeleteKey(key, "Restart")
except:
    pass

count = 0
while True:
    if count > 10:
        print "Could not shut down an Exodus instance"
        sys.exit(1)
    wins = []
    last = 0
    while True:
        try:
            win = win32gui.FindWindowEx(0, last, "TFrmExodus", None)
        except:
            sys.exit(0)
        if win == 0:
            break
        pid = win32process.GetWindowThreadProcessId(win)[1]
        if not isDelphi(pid):
            wins.append(win)
        last = win

    if len(wins) == 0:
        sys.exit(0)

    if count > 0:
        time.sleep(1)
        
    for win in wins:
        win32gui.SendMessage(win, 6374, 0, 0)
    count += 1
