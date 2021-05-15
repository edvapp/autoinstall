#!/usr/bin/python3

## short import of all components
## from tkinter import *

## with full import list :-(
## from tkinter import Tk, Frame, Button, LEFT

## use an alias
## all tkinter imports must be prefixed with tk.
## example: Button as tk.Button
import tkinter as tk
import subprocess

## CONSTANTS

LABEL_ROOT = "Change Password"

LABEL_TEXT_COLOR = "blue"

LABEL_USER = "USER NAME:"
LABEL_OLD_PASSWORD = "OLD PASSWORD:"
LABEL_NEW_PASSWORD = "NEW PASSWORD:"
LABEL_RETYPED_PASSWORD = "RETYPED PASSWORD:"

BUTTON_CHANGE_PASSWORD = "SET PASSWORD"

ERROR_MESSAGE_PASSWORD_DIFFERS = "New password differs from retyped password"

class App():


    def __init__(self, rootWindow):
        self.__createLayout(rootWindow)
        self.__fillLayout()


    def __createLayout(self, rootWindow):
        self.rootWindow = rootWindow
        ## Frame, to show all things
        frame = tk.Frame(self.rootWindow)
        frame.pack()
        self.f = frame

        tk.Label(frame, text=LABEL_USER, foreground=LABEL_TEXT_COLOR).grid(row=0, column=0, sticky="w")
        self.userName = tk.Entry(frame)
        self.userName.grid(row=0, column=1)

        tk.Label(frame, text=LABEL_OLD_PASSWORD, foreground=LABEL_TEXT_COLOR).grid(row=1, column=0, sticky="w")
        self.oldPassword = tk.Entry(frame, show='*')
        self.oldPassword.grid(row=1, column=1)

        tk.Label(frame, text=LABEL_NEW_PASSWORD, foreground=LABEL_TEXT_COLOR).grid(row=2, column=0, sticky="w")
        self.newPassword = tk.Entry(frame, show='*')
        self.newPassword.grid(row=2, column=1)

        tk.Label(frame, text=LABEL_RETYPED_PASSWORD, foreground=LABEL_TEXT_COLOR).grid(row=3, column=0, sticky="w")
        self.retypedNewPassword = tk.Entry(frame, show='*')
        self.retypedNewPassword.grid(row=3, column=1)

        self.changePassword = tk.Button(frame, text=BUTTON_CHANGE_PASSWORD, foreground=LABEL_TEXT_COLOR, command=self.change_password)
        self.changePassword.grid(row=4, column=1, sticky="e")

        self.errorMessage = tk.Text(frame, height=10, width=60)
        self.errorMessage.grid(row=5, column=0, columnspan=2)


    def __fillLayout(self): 
        whoami = subprocess.Popen(['whoami'], stdout=subprocess.PIPE)
        ## [0] -> stdout [1] -> stderr
        ## [0][0:-1] removes \n at the end of the string
        ## str(..., 'utf-8) needed to convert to UTF-8 String
        username = str(whoami.communicate()[0][0:-1], 'utf-8')

        if username != "user":
            self.userName.insert(tk.INSERT,username)
            self.oldPassword.focus_set()
        else:
            self.userName.focus_set()
   

    def change_password(self):
        self.errorMessage.delete('1.0', tk.END)
        if self.newPassword.get() != self.retypedNewPassword.get():
            self.print_message(ERROR_MESSAGE_PASSWORD_DIFFERS)
        else:
            smbpasswd = subprocess.Popen(['smbpasswd', '-s', '-r', 'smb01', '-U', self.userName.get()],
                                         stdin=subprocess.PIPE, 
                                         stdout=subprocess.PIPE,
                                         stderr=subprocess.STDOUT, 
                                         universal_newlines=True)
#            message = smbpasswd.communicate('\n'.join((self.oldPassword.get(), 
#														self.newPassword.get(),
#														self.retypedNewPassword.get())))[0]
            message = smbpasswd.communicate(self.oldPassword.get() + '\n' + self.newPassword.get() + '\n' + self.retypedNewPassword.get())[0]
            self.print_message(message)

            
    def print_message(self, message):
        self.errorMessage.insert(tk.INSERT,message)
    
    
    def center(self):
        ## rootWindow.update_idletasks() needed to pack() frame to calculate width & height
        self.rootWindow.update_idletasks()
        self.rootWindow.geometry('{0}x{1}+{2}+{3}'
                .format(self.rootWindow.winfo_reqwidth(),
                        self.rootWindow.winfo_reqheight(),
                        int(self.rootWindow.winfo_screenwidth()/2 - 
                            self.rootWindow.winfo_reqwidth()/2),
                        int(self.rootWindow.winfo_screenheight()/2 - 
                            self.rootWindow.winfo_reqheight()/2)))

   

## main
## creates an empty 200x200 pixel window
rootWindow = tk.Tk()
rootWindow.title(LABEL_ROOT)
## places our App() on/in rootWindow
app = App(rootWindow)
app.center()
## start rootWindow event-loop
rootWindow.mainloop()
