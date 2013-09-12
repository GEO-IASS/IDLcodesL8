; Script to convert L7 image in Digital Counts (DC) to Radiance. 
; Input: name of the file. Ex: LE71720432002309SGS00 (w/o extension)
; Output: Bands in a image cube (layer stack)
; By Javier A. Concha (jxc4005@rit.edu)
; Rochester Institute of Technology
; June, 2013
; Info about IDL: http://www.exelisvis.com/docs/home.html

PRO L7cal
;envi, /restore_base_save_files
;envi_batch_init, log_file='batch.log'

file_name ="
read, file_name, PROMPT = 'Enter File Name: '
;print, file_name
     
    wl1 = 0.485
    wl2 = 0.560
    wl3 = 0.660
    wl4 = 0.830
    wl5 = 1.650
    wl7 = 2.200
    
    
bands = [1, 2, 3, 4, 5, 7]    

;Create Strings
filepath = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L7images/'
img_file=filepath+file_name+'/'+file_name+'_B1.TIF'
strleft =filepath+file_name+'/'+file_name+'_B'
strright ='.TIF'
strout = filepath+file_name+'/'+file_name+'rad.TIF'
strMTL = filepath+file_name+'/'+file_name+'_MTL.txt

PRINT, "Starting Radiometric Calibration for L7 image..."

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

FOR i=0, size(bands,/N_ELEMENTS)-1 DO BEGIN

  strin = strleft+STRTRIM(string(bands[i]), 1)+strright 
  strRadMul = 'RADIANCE_MULT_BAND_'+STRTRIM(string(bands[i]), 1)
  strRadAdd = 'RADIANCE_ADD_BAND_'+STRTRIM(string(bands[i]), 1)

  spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep -a "'+strRadMul+' =" ',lineout1
  spawn, 'cat '+filepath+file_name+'/'+file_name+'_MTL.txt|grep -a "'+strRadAdd+' =" ',lineout2
;   help, lineout1[0]
;   help, lineout2[0]
  
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
    descrip = 'L7 calibrated bands', $
    map_info = map_info, $
    WAVELENGTH_UNITS = 0L, $
    WL = [wl1, wl2, wl3, wl4, wl5, wl7], $
    BNAMES =  ['band 1', 'band 2', 'band 3', 'band 4', 'band 5', 'band 7'], $
    OUT_NAME = strout


PRINT, "Finished..."
END ;orp