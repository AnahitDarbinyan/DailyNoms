import tkinter as tk
from PIL import Image, ImageTk
import os

CELL_SIZE = 50
GRID_SIZE = 10

# Central ship information
SHIP_NAMES = ['Battleship', 'Cruiser', 'Submarine', 'Destroyer']
SHIP_COUNTS = {'Battleship': 1, 'Cruiser': 2, 'Submarine': 3, 'Destroyer': 4}

class BattleshipGUI:
    def init(self, root):
        self.root = root
        self.root.title("Battleship Game")

        # Load images into a dictionary
        self.images = {}
        self.load_images()

        # Create canvas for grid + ships
        canvas_height = CELL_SIZE * GRID_SIZE + 120
        self.canvas = tk.Canvas(self.root, width=CELL_SIZE * GRID_SIZE, height=canvas_height)
        self.canvas.pack()

        self.draw_grid()
        self.draw_ships_below()

    def load_images(self):
        try:
            # Load water background image
            self.images['water'] = ImageTk.PhotoImage(Image.open("water.png").resize((CELL_SIZE, CELL_SIZE)))

            # Load each ship image
            for ship in SHIP_NAMES:
                self.images[ship] = ImageTk.PhotoImage(Image.open(f"{ship}.png").resize((80, 30)))
        except Exception as e:
            print("Error loading images:", e)
            self.root.destroy()

    def draw_grid(self):
        for row in range(GRID_SIZE):
            for col in range(GRID_SIZE):
                x = col * CELL_SIZE
                y = row * CELL_SIZE
                self.canvas.create_image(x, y, anchor='nw', image=self.images['water'])
                self.canvas.create_rectangle(x, y, x + CELL_SIZE, y + CELL_SIZE, outline="black")

    def draw_ships_below(self):
        start_y = CELL_SIZE * GRID_SIZE + 10
        for i, name in enumerate(SHIP_NAMES):
            x = i * (CELL_SIZE * 2.5) + 10
            y = start_y + 10
            self.canvas.create_image(x, y, anchor='nw', image=self.images[name])
            self.canvas.create_text(x + 40, y + 40, text=f"{name} x{SHIP_COUNTS[name]}", font=('Arial', 10))

# ✅ Correct script entry point
if __name__ == "main":
    root = tk.Tk()
    app = BattleshipGUI(root)
    root.mainloop()
