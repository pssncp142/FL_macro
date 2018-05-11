
# Use the 2nd Config
SETCONFIG 2

# Macro Config
#-- Target Surface
target_lens = 27
num_shfts = 10
shft_step = 0.5
#-- Field options
field_dims = 9
angle_steps = 0.005
#-- Through Focus Options
nom_focus = 0.3
step_foc = 0.1
num_foc = 9
#-- Misc
work_dir$ = "\\10.0.2.2\public\Flamingso\ZPL_Test\Results\"


# Set Working Dir
CALLSETSTR 1, work_dir$
CALLSETDBL 1, field_dims
CALLSETDBL 2, angle_steps
CALLSETDBL 6, target_lens

low_foc = nom_focus-step_foc*(num_foc-1)/2
FORMAT "%#03i" LIT
surface_dir$ = "Surface" + $STR(target_lens) + "\"
crnt_dir$ = work_dir$ + surface_dir$
MAKEFOLDER crnt_dir$

FOR k, 1, num_shfts, 1

	FOR j, 1, num_shfts, 1

		dec_x = (k-1)*shft_step
		dec_y = (j-1)*shft_step

		FORMAT .1
		dec_dir$ = "Decx" + $STR(dec_x) + "_Decy" + $STR(dec_y) + "/"

		IF (j <= k)

			FOR i, 1, num_foc, 1
				
				crnt_dir$ = work_dir$ + surface_dir$ + dec_dir$
				MAKEFOLDER crnt_dir$
				CALLSETDBL 3, (i-1)*step_foc+low_foc # Set current focus
				CALLSETDBL 4, dec_x
				CALLSETDBL 5, dec_y
				CALLSETSTR 2, crnt_dir$
				PRINT crnt_dir$
				CALLMACRO SET_CRNT_CFG.ZPL
				CALLMACRO GET_PSF.ZPL
			
			NEXT i
	
		ENDIF

	NEXT j
NEXT k
