Pro L8Test

  ;file_name = 'LC80160302013262LGN00'
  ;;Create Strings
  ;filepath = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L8images/'
  ;B2name = filepath+file_name+'/'+file_name+'_B2.TIF'
  ;B3name = filepath+file_name+'/'+file_name+'_B3.TIF'
  ;B4name = filepath+file_name+'/'+file_name+'_B4.TIF'
  ;strleft =filepath+file_name+'/'+file_name+'_B'
  ;strright ='.TIF'
  ;
  ;bands = [2,3,4]
  ;
  ;img_file=filepath+file_name+'/'+file_name+'_B1.TIF'
  ;
  ;;ENVI procedures
  ;ENVI_OPEN_FILE,img_file,r_fid=fid
  ;if (fid eq -1) then begin
  ;  print, 'Error when opening file ',img_file
  ;  return
  ;endif
  ;
  ;;read the image
  ;ENVI_FILE_QUERY, fid, dims=dims, NB=NB, NL=NL, NS=NS
  ;
  ;map_info=envi_get_map_info(fid=fid)
  ;
  ;imagen=fltarr(NS, NL, size(bands,/N_ELEMENTS))
  ;
  ;FOR i=0, size(bands,/N_ELEMENTS)-1 DO BEGIN
  ;  filename = strleft+STRTRIM(string(bands[i]), 1)+strright
  ;
  ; ;ENVI procedures
  ;  ENVI_OPEN_FILE,filename,r_fid=fid
  ;  if (fid eq -1) then begin
  ;      print, 'Error when opening file ',img_file
  ;      return
  ;  endif
  ;
  ;    ; read the image
  ;  ENVI_FILE_QUERY, fid, dims=dims
  ;  ; and store it in an array
  ;  Bn = ENVI_GET_DATA(fid=fid, dims=dims, pos=0)
  ;
  ;  ; scale image
  ;  imagen[*,*,2-i]= bytscl(Bn)
  ;
  ;
  ;
  ;ENDFOR
  ;
  ;; plot image
  ;b = image(imagen,rgb_table=36)
  ;
  ;cgMinMax, b
  ;
  ;b.ROTATE, -180
  ;STRETCH, 0, 70
  
  ;OPENR, 1, FILEPATH('LC80170302013301LGN00_B2.TIF',$
  ;  ROOT_DIR = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L8images/IDLcodes/')
  ;
  ;;blueband = BYTARR(7641,7781, /NOZERO)
  ;READ, 1, blueband
  ;CLOSE, 1
  ;
  ;blueband = CONGRID(blueband, 512,512)
  ;
  ;PRINT, SIZE(blueband, /TNAME)
  
  dirpath = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L8images/LC80170302013269LGN00/'
  filename = 'LC80170302013269LGN00'
  
  ;Image Result
  

 
  
  datatype = 12; UINT
  
  rot = 7;Direction Option for ROTATE: Transposed and 270 degrees
  ;Opening bands
  ;Blue Band -------------------------------
  dataFilePath = FILEPATH(filename+'_B2.TIF',$
    ROOT_DIR = dirpath)
    
  ok = QUERY_IMAGE(dataFilePath,info)
  help,info,/STRUCTURE
  
  dims = [info.dimensions[0],info.dimensions[1]]
  imagen=fltarr(dims[0], dims[1], 3)
  
  
  imBBIN = READ_BINARY(dataFilePath, DATA_DIMS=dims, DATA_TYPE=datatype)
  
  PRINT, SIZE(imBBIN)
  
;  imBBIN = ROTATE(imBBIN, rot)
  equ_imBBIN = HIST_EQUAL(imBBIN)
  imagen[*,*,2] = equ_imBBIN
  
  
  
  
  
  
  ;
  ;Green Band -------------------------------
  dataFilePath = FILEPATH(filename+'_B3.TIF',$
    ROOT_DIR = dirpath)
  imGBIN = READ_BINARY(dataFilePath, DATA_DIMS=dims, DATA_TYPE=datatype)
;  imGBIN = ROTATE(imGBIN, rot)
  equ_imGBIN = HIST_EQUAL(imGBIN)
  imagen[*,*,1] = equ_imGBIN
  
  ;Red Band ---------------------------------
  ; Read in an image from a file and display it with IMAGE
  dataFilePath = FILEPATH(filename+'_B4.TIF',$
    ROOT_DIR = dirpath)
    
  imRBIN = READ_BINARY(dataFilePath, DATA_DIMS=dims, DATA_TYPE=datatype)
;  imRBIN = ROTATE(imRBIN, rot)
  
  PRINT, TYPENAME(imRBIN)
  PRINT, MAX(imRBIN)
  
  imRorig = IMAGE(imRBIN,LAYOUT=[2,2,1],TITLE='Original Image', $
    WINDOW_TITLE='Histogram Equalization Example')
  
  ; Calculate the histogram of the pixel values from this original image
  ; then plot the frequency of the pixel values
  orig_histogram = histogram(imRBIN)
  
  hist = PLOT(orig_histogram, LAYOUT=[2,2,2], /CURRENT, $
    COLOR='red', $
    XTITLE='Pixel Value', YTITLE='Frequency', TITLE='Histogram', $
    XRANGE=[0, MAX(imRBIN)],YRANGE=[0, MAX(orig_histogram)])
    
  ; Pass the original file through the HIST_EQUAL function
  ; then view the resulting image in the original window
  equ_imRBIN = HIST_EQUAL(imRBIN)
  imagen[*,*,0] = equ_imRBIN
  
  equ = IMAGE(equ_imRBIN, LAYOUT=[2,2,3], /CURRENT, $
    TITLE='Equalized Image')
  
  ; Calculate the histogram of the pixel values from the equalized
  ; image and plot the frequency of the pixel values
  equ_histogram = histogram(equ_imRBIN)
  equ_hist = PLOT(equ_histogram, LAYOUT=[2,2,4], /CURRENT, $
    COLOR='blue', $
    XTITLE='Pixel Value', YTITLE='Frequency')
    
  
  result = IMAGE(imagen,/ORDER)
;  result = IMAGE(imagen,/ORDER,MIN_VALUE=MIN(imagen),MAX_VALUE=MAX(imagen))
  
  
END ;orp