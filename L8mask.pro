Pro L8mask
;  filename = 'LC80160302013262LGN00'
  
  filename = 'LC80170302013269LGN00'
  dirpath = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L8images/'+filename+'/'
  
  
  ;Image Result
  datatype = 12; UINT
  ;Opening bands
  ;BQA Band -------------------------------
  BQAPath = FILEPATH(filename+'_BQA.TIF',$
    ROOT_DIR = dirpath)
    
  ;B2 Band -------------------------------- 
  B2Path = FILEPATH(filename+'_B2.TIF',$
    ROOT_DIR = dirpath)
  ;B3 Band --------------------------------
  B3Path = FILEPATH(filename+'_B3.TIF',$
    ROOT_DIR = dirpath)  
  ;B4 Band --------------------------------
  B4Path = FILEPATH(filename+'_B4.TIF',$
    ROOT_DIR = dirpath)
    
;----------------------------------------------------------------------------------------------    
;  e = ENVI()
;  ;ENVI procedures
;  
;  raster1 = e.OpenRaster(BQAPath)
; 
  
  
  
 ;---------------------------------------------------------------------------------------------- 
    
    
    
  ok = QUERY_IMAGE(BQAPath,info)
  HELP, info,/STRUCTURE
  
  data_variable = READ_TIFF(B2Path,GEOTIFF=GeoKeys)
  HELP, GeoKeys,/STRUCTURE 
  PRINT, info.POSITION
  PRINT, info.RESOLUTION
  
  dims = [info.dimensions[0],info.dimensions[1]]
  im=fltarr(dims[0], dims[1],3)
  imRGB=fltarr(dims[0], dims[1],3)
  
  imBQA = READ_BINARY(BQAPath, DATA_DIMS=dims, DATA_TYPE=datatype)
  
  
  
  
  
  
  im[*,*,2] = READ_BINARY(B2Path, DATA_DIMS=dims, DATA_TYPE=datatype)
  im[*,*,1] = READ_BINARY(B3Path, DATA_DIMS=dims, DATA_TYPE=datatype)
  im[*,*,0] = READ_BINARY(B4Path, DATA_DIMS=dims, DATA_TYPE=datatype)
  
;  xwidth = 1024
;  ywidth = 1024
;  x0 = (dims[0]-1)/2-xwidth
;  x1 = (dims[0]-1)/2+xwidth-1
;  y0 = (dims[1]-1)/2-ywidth
;  y1 = (dims[1]-1)/2+ywidth-1
  
  x0 = 0
  x1 = dims[0]-1
  y0 = 0
  y1 = dims[1]-1
;  
  
  
  imRGB[*,*,2] = HIST_EQUAL(im[*,*,2])
  imRGB[*,*,1] = HIST_EQUAL(im[*,*,1])
  imRGB[*,*,0] = HIST_EQUAL(im[*,*,0])
  
  imTest = imRGB[x0:x1,y0:y1,*]
  
 result =  IMAGE(imTest,/ORDER,MIN_VALUE=MIN(imTest),MAX_VALUE=MAX(imTest), $
            TITLE='RGB',GEOTIFF=GeoKeys)
             
  
  imBQATest = imBQA[x0:x1,y0:y1]
;  result =  IMAGE(imBQATest,/ORDER,MIN_VALUE=MIN(imBQATest),MAX_VALUE=MAX(imBQATest), $
;              LAYOUT=[2,2,2],/CURRENT,TITLE='BQA Band')
                          
; Cloud Mask                        
  CloudMask = imBQATest AND 49152;two most significant bits 1100000000000000
  CloudMask = ISHFT(CloudMask,-14)
  
;  result =  IMAGE(CloudMask,/ORDER,MIN_VALUE=MIN(CloudMask),MAX_VALUE=MAX(CloudMask), $
;    LAYOUT=[2,2,3],/CURRENT,TITLE='Cloud Mask')
;  ; Cirrus Mask
  CirrusMask = imBQATest AND 12288;two most significant bits 0011000000000000
  CirrusMask = ISHFT(CirrusMask,-12)
;  result =  IMAGE(CirrusMask,/ORDER,MIN_VALUE=MIN(CirrusMask),MAX_VALUE=MAX(CirrusMask), $
;    LAYOUT=[2,2,4],/CURRENT,TITLE='Cirrus Mask')
    
  ; Water Mask
  
  WaterMask = imBQATest AND 48; 0000000000110000
  WaterMask = ISHFT(WaterMask,-4)
  
;  result =  IMAGE(WaterMask,/ORDER,MIN_VALUE=MIN(WaterMask),MAX_VALUE=MAX(WaterMask), $
;    LAYOUT=[2,2,4],/CURRENT,TITLE='Water Mask') 
    
    

;----------------------------------------------------------------------------------------------    
; Cloud Mask Histogram
  result =  IMAGE(CloudMask,/ORDER,MIN_VALUE=MIN(CloudMask),MAX_VALUE=MAX(CloudMask), $
    LAYOUT=[2,3,1],TITLE='Cloud Mask',WINDOW_TITLE=filename)
    
  orig_histogram = histogram(CloudMask)
  
  hist = PLOT(orig_histogram, LAYOUT=[2,3,2], /CURRENT, $
    COLOR='red', $
    XTITLE='Pixel Value', YTITLE='Frequency', TITLE='Histogram')

; Cirrus Mask Histogram
  result =  IMAGE(CirrusMask,/ORDER,MIN_VALUE=MIN(CirrusMask),MAX_VALUE=MAX(CirrusMask), $
    LAYOUT=[2,3,3],TITLE='Cirrus Mask',WINDOW_TITLE=filename,/CURRENT)
    
  orig_histogram = histogram(CirrusMask)
  
  hist = PLOT(orig_histogram, LAYOUT=[2,3,4], /CURRENT, $
    COLOR='red', $
    XTITLE='Pixel Value', YTITLE='Frequency', TITLE='Histogram')
    
  ; Water Mask Histogram
  result =  IMAGE(WaterMask,/ORDER,MIN_VALUE=MIN(WaterMask),MAX_VALUE=MAX(WaterMask), $
    LAYOUT=[2,3,5],TITLE='Water Mask',WINDOW_TITLE=filename,/CURRENT)
    
  orig_histogram = histogram(WaterMask)
  
  hist = PLOT(orig_histogram, LAYOUT=[2,3,6], /CURRENT, $
    COLOR='red', $
    XTITLE='Pixel Value', YTITLE='Frequency', TITLE='Histogram')    
    
;----------------------------------------------------------------------------------------------    
  ; Cloud Mask
  CloudMask00 = CloudMask EQ 0
  result =  IMAGE(CloudMask00,/ORDER,MIN_VALUE=MIN(CloudMask00),MAX_VALUE=MAX(CloudMask00), $
    LAYOUT=[2,2,1],TITLE='00',WINDOW_TITLE=filename + 'Cloud Mask')   
  CloudMask01 = CloudMask EQ 1
  result =  IMAGE(CloudMask01,/ORDER,MIN_VALUE=MIN(CloudMask01),MAX_VALUE=MAX(CloudMask01), $
    LAYOUT=[2,2,2],TITLE='01',/CURRENT)  
  CloudMask10 = CloudMask EQ 2
  result =  IMAGE(CloudMask10,/ORDER,MIN_VALUE=MIN(CloudMask10),MAX_VALUE=MAX(CloudMask10), $
    LAYOUT=[2,2,3],TITLE='10',/CURRENT) 
  CloudMask11 = CloudMask EQ 3
  result =  IMAGE(CloudMask11,/ORDER,MIN_VALUE=MIN(CloudMask11),MAX_VALUE=MAX(CloudMask11), $
    LAYOUT=[2,2,4],TITLE='11',/CURRENT)  
;----------------------------------------------------------------------------------------------
  ; Cirrus Mask
  CirrusMask00 = CirrusMask EQ 0
  result =  IMAGE(CirrusMask00,/ORDER,MIN_VALUE=MIN(CirrusMask00),MAX_VALUE=MAX(CirrusMask00), $
    LAYOUT=[2,2,1],TITLE='00',WINDOW_TITLE=filename + 'Cirrus Mask')   
  CirrusMask01 = CirrusMask EQ 1
  result =  IMAGE(CirrusMask01,/ORDER,MIN_VALUE=MIN(CirrusMask01),MAX_VALUE=MAX(CirrusMask01), $
    LAYOUT=[2,2,2],TITLE='01',/CURRENT)  
  CirrusMask10 = CirrusMask EQ 2
  result =  IMAGE(CirrusMask10,/ORDER,MIN_VALUE=MIN(CirrusMask10),MAX_VALUE=MAX(CirrusMask10), $
    LAYOUT=[2,2,3],TITLE='10',/CURRENT) 
  CirrusMask11 = CirrusMask EQ 3
  result =  IMAGE(CirrusMask11,/ORDER,MIN_VALUE=MIN(CirrusMask11),MAX_VALUE=MAX(CirrusMask11), $
    LAYOUT=[2,2,4],TITLE='11',/CURRENT)
;----------------------------------------------------------------------------------------------
  ; Water Mask
  WaterMask00 = WaterMask EQ 0
  result =  IMAGE(WaterMask00,/ORDER,MIN_VALUE=MIN(WaterMask00),MAX_VALUE=MAX(WaterMask00), $
    LAYOUT=[2,2,1],TITLE='00',WINDOW_TITLE=filename + 'Water Mask')   
  WaterMask01 = WaterMask EQ 1
  result =  IMAGE(WaterMask01,/ORDER,MIN_VALUE=MIN(WaterMask01),MAX_VALUE=MAX(WaterMask01), $
    LAYOUT=[2,2,2],TITLE='01',/CURRENT)  
  WaterMask10 = WaterMask EQ 2
  result =  IMAGE(WaterMask10,/ORDER,MIN_VALUE=MIN(WaterMask10),MAX_VALUE=MAX(WaterMask10), $
    LAYOUT=[2,2,3],TITLE='10',/CURRENT) 
  WaterMask11 = WaterMask EQ 3
  result =  IMAGE(WaterMask11,/ORDER,MIN_VALUE=MIN(WaterMask11),MAX_VALUE=MAX(WaterMask11), $
    LAYOUT=[2,2,4],TITLE='11',/CURRENT)
;----------------------------------------------------------------------------------------------   
    
    
  
END ;orp