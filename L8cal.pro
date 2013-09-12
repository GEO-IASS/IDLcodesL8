; Script to convert L8 image in Digital Counts (DC) to Radiance. 
; Input: name of the file. Ex: LC80170302013082LGN00 (w/o extension)
; Output: Bands in a image cube (layer stack)
; By Javier A. Concha (jxc4005@rit.edu)
; Rochester Institute of Technology
; May, 2013
; Info about IDL: http://www.exelisvis.com/docs/home.html

PRO L8cal
;envi, /restore_base_save_files
;envi_batch_init, log_file='batch.log'

file_name ="
read, file_name, PROMPT = 'Enter File Name: '
;print, file_name
     
    wl1 = 0.4430
    wl2 = 0.4826
    wl3 = 0.5613
    wl4 = 0.6546
    wl5 = 0.8646
    wl6 = 1.6090
    wl7 = 2.2010
    
    
bands = [1, 2, 3, 4, 5, 6, 7]    

;Create Strings
filepath = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/LDCMimages/'
img_file=filepath+file_name+'/'+file_name+'_B1.TIF'
strleft =filepath+file_name+'/'+file_name+'_B'
strright ='.TIF'
strout = filepath+file_name+'/'+file_name+'rad.TIF'
strMTL = filepath+file_name+'/'+file_name+'_MTL.txt

PRINT, "Starting Radiometric Calibration for L8 image..."

;ENVI procedures
ENVI_OPEN_FILE,img_file,r_fid=fid
  if (fid eq -1) then begin
      print, 'Error when opening file ',img_file
      return
  endif 

;read the image
ENVI_FILE_QUERY, fid, dims=dims, NB=NB, NL=NL, NS=NS

map_info=envi_get_map_info(fid=fid)

imagen=fltarr(NS, NL, size(bands,/N_ELEMENTS))

; to include in the description file
date = ''
time = ''
azim = ''
elev = ''
spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep "DATE_ACQUIRED" ',date
spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep "SCENE_CENTER_TIME" ',time
spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep "SUN_AZIMUTH" ',azim
spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep "SUN_ELEVATION" ',elev







FOR i=0, size(bands,/N_ELEMENTS)-1 DO BEGIN

  strin = strleft+STRTRIM(string(bands[i]), 1)+strright 
  strRadMul = 'RADIANCE_MULT_BAND_'+STRTRIM(string(bands[i]), 1)
  strRadAdd = 'RADIANCE_ADD_BAND_'+STRTRIM(string(bands[i]), 1)
  
  spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep "'+strRadMul+' =" ',lineout1
  spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep "'+strRadAdd+' =" ',lineout2
;  help, lineout1[0]
;  help, lineout2[0]
  
  status = execute(lineout1[0])
  status = execute(lineout2[0])

  ;ENVI procedures
  ENVI_OPEN_FILE,strin,r_fid=fid
  if (fid eq -1) then begin
      print, 'Error when opening file ',img_file
      return
  endif
  
    ; read the image
  ENVI_FILE_QUERY, fid, dims=dims
  ; and store it in an array
  Bn = ENVI_GET_DATA(fid=fid, dims=dims, pos=0)
  
  status = execute('Bncal='+strRadMul+'*Bn'+'+'+strRadAdd)

  ;add band to image
  imagen[*,*,i] = Bncal

ENDFOR
;
ENVI_WRITE_ENVI_FILE, imagen, data_type=4, $
    descrip = 'L8 calibrated bands. '+date+'. '+time+'. '+azim+'. '+elev+'.', $
    map_info = map_info, $
    WAVELENGTH_UNITS = 0L, $
    WL = [wl1, wl2, wl3, wl4, wl5, wl6, wl7], $
    OUT_NAME = strout, $
    DEF_BANDS = [3, 2, 1]


PRINT, "Finished..."
END ;orp