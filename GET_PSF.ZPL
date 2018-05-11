! Get the full field PSF for the given configuration

SETVECSIZE 20000

field_dims = CALD(1)
angle_steps = CALD(2)
crnt_focus = CALD(3)
dec_x = CALD(4)
dec_y = CALD(5)
surface = CALD(6)

work_dir$ = $CALLSTR(1)
crnt_dir$ = $CALLSTR(2)

crop_dim = 16
sampl_dim = 64 # 2 sample

num_fields = field_dims*field_dims
low_field = -angle_steps*(field_dims-1)/2

SYSP 101, 1

DECLARE full_psf, float, 2, crop_dim*2*field_dims, crop_dim*2*field_dims

FOR i, 1, field_dims, 1
	FOR j, 1, field_dims, 1
	
		! Set field
		SYSP 102, 1, low_field+(j-1)*angle_steps
		SYSP 103, 1, low_field+(i-1)*angle_steps
		PRINT "Field set to: X  ", low_field+(j-1)*angle_steps, " Y  ", low_field+(i-1)*angle_steps
		
		! Get PSF
		GETPSF 1, 1, 2, 1, 1, 0, 0
		np = vec1(0)

		! Check for exceptions
		IF (np == 0)
			PRINT "PSF Computation aborted."
			GOTO 1
		ENDIF
		IF (np == -1)
			PRINT "SETVECSIZE too small for PSF data."
			GOTO 1
		ENDIF
		IF (np == -2)
			PRINT "Not enough system RAM for PSF data."
			GOTO 1
		ENDIF
		
		PRINT sqrt(np)
		
		ndxst = sampl_dim-crop_dim+1
		ndend = sampl_dim+crop_dim

		x_off = crop_dim*(field_dims-j)*2
		y_off = crop_dim*(field_dims-i)*2
		
		FOR k, ndxst, ndend, 1
			FOR m, ndxst, ndend, 1
				full_psf(m-ndxst+1+x_off,k-ndxst+1+y_off) = vec1((k-1)*sampl_dim*2+m)
			NEXT k
		NEXT l
		
		LABEL 1

	NEXT j
NEXT i

MAKEFOLDER crnt_dir$
gr_ext$ = ".png"
IF (crnt_focus < 0)
	f_name$ = "Focus_m" + $STR(-crnt_focus) 
ELSE
	f_name$ = "Focus_p" + $STR(crnt_focus)
ENDIF

full_name$ = crnt_dir$ + f_name$ + gr_ext$

PLOT2D NEW
PLOT2D DATA, full_psf
comm$ = "Current focus is at " + $STR(crnt_focus)
PLOT2D COMM1, comm$
FORMAT 2 INT
comm$ = "Surface : " + $STR(surface)
FORMAT .3
comm$ = comm$ + ", Decx : " + $STR(dec_x) + ", Decy : " + $STR(dec_y)
PLOT2D COMM2, comm$
PLOT2D GO

EXPORTJPG 2, full_name$
CLOSEWINDOW 2


