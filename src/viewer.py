from tkinter import *


class viewer(Tk):
    def __init__(self, heightP, widthP):
        super(viewer, self).__init__()
        self.title("Proyecto Individual 1 - Nickolas Rodriguez")
        # self.minsize(100, 100)
        self.fname = Canvas(height=heightP, width=widthP)
        self.widthP = widthP
        self.heightP = heightP
        self.nor = PhotoImage(file="normal.png")
        self.sharp = PhotoImage(file="sharpening.png")
        self.oversharp = PhotoImage(file="oversharpening.png")
        self.image = self.fname.create_image(
            0, 0, anchor=NW, image=self.nor)
        self.var = IntVar()
        self.R1 = Radiobutton(self, text="Normal",
                              variable=self.var, value=1, command=self.norPic)
        self.R1.pack(anchor=W)
        self.R2 = Radiobutton(self, text="Sharpened",
                              variable=self.var, value=2, command=self.sharpPic)
        self.R2.pack(anchor=W)
        self.R3 = Radiobutton(self, text="Oversharpened",
                              variable=self.var, value=3, command=self.oversharpPic)
        self.R3.pack(anchor=W)
        self.fname.pack()

    def norPic(self):
        self.image = self.fname.create_image(
            0, 0, anchor=NW, image=self.nor)

    def sharpPic(self):
        self.image = self.fname.create_image(
            0, 0, anchor=NW, image=self.sharp)

    def oversharpPic(self):
        self.image = self.fname.create_image(
            0, 0, anchor=NW, image=self.oversharp)
