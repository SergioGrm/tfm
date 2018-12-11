from tkinter import *
#from PIL import Image, ImageTk

class App:

    def __init__(self, master):
        print("Init")
        
        #Keep master for later
        self.master = master
        
        self.button_image = PhotoImage(file="xubuntulogo.png")
        b_width = self.button_image.width()
        b_height = self.button_image.height()
        
        self.canvas = Canvas(master, width=b_width, height=600)
        self.canvas.pack()
        self.canvas.create_line(0, 0, 200, 100)
        self.canvas.create_line(0, 100, 200, 0, fill="red", dash=(4, 4))
        self.canvas.create_rectangle(50, 25, 150, 75, fill="blue")
        
        self.hi_there = Button(self.canvas, image=self.button_image, command=self.say_hi)
        self.canvas.create_window(0, 100, window=self.hi_there, anchor=NW, width=400, height=400)


    def say_hi(self):
        print ("hi there, everyone!")
        self.master.destroy()

root = Tk()

#Este es el que quita los bordes y todo eso.
root.wm_attributes('-type', 'splash')

app = App(root)

root.mainloop()

print("Exiting...")
