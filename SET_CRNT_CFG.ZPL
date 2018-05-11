# Macro to set options

crnt_foc = CALD(3)
dec_x = CALD(4)
dec_y = CALD(5)
surface = CALD(6)

SURP 32, 3, crnt_foc

c_surface = surface - 1 
SETSURFACEPROPERTY c_surface, 71, dec_x
SETSURFACEPROPERTY c_surface, 72, dec_y

c_surface = surface + 1
SETSURFACEPROPERTY c_surface, 71, -dec_x
SETSURFACEPROPERTY c_surface, 72, -dec_y


