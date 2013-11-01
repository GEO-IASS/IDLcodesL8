Pro L8mask
  filename = 'LC80160302013262LGN00'
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
    
  ok = QUERY_IMAGE(BQAPath,info)
  help,info,/STRUCTURE
  
  dims = [info.dimensions[0],info.dimensions[1]]
  im=fltarr(dims[0], dims[1],3)
  imRGB=fltarr(dims[0], dims[1],3)
  
  imBQA = READ_BINARY(BQAPath, DATA_DIMS=dims, DATA_TYPE=datatype)
  
  im[*,*,2] = READ_BINARY(B2Path, DATA_DIMS=dims, DATA_TYPE=datatype)
  im[*,*,1] = READ_BINARY(B3Path, DATA_DIMS=dims, DATA_TYPE=datatype)
  im[*,*,0] = READ_BINARY(B4Path, DATA_DIMS=dims, DATA_TYPE=datatype)
;  tvscl, im, /ord

;  help, im
;  result = IMAGE(im,/ORDER,MIN_VALUE=MIN(im),MAX_VALUE=MAX(im))
  
  PRINT,imBQA((dims[0]-1)/2,(dims[1]-1)/2),FORMAT='(B016)'
  
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
  
  
  
  imRGB[*,*,2] = HIST_EQUAL(im[*,*,2])
  imRGB[*,*,1] = HIST_EQUAL(im[*,*,1])
  imRGB[*,*,0] = HIST_EQUAL(im[*,*,0])
  
  imTest = imRGB[x0:x1,y0:y1,*]
  
  result =  IMAGE(imTest,/ORDER,MIN_VALUE=MIN(imTest),MAX_VALUE=MAX(imTest), $
              LAYOUT=[2,2,1],TITLE='RGB')
             
  
  imBQATest = imBQA[x0:x1,y0:y1]
  result =  IMAGE(imBQATest,/ORDER,MIN_VALUE=MIN(imBQATest),MAX_VALUE=MAX(imBQATest), $
              LAYOUT=[2,2,2],/CURRENT,TITLE='BQA Band')
                          
  ; Cloud Mask                        
  CloudMask = imBQATest AND 49152;two most significant bits 1100000000000000
  result =  IMAGE(CloudMask,/ORDER,MIN_VALUE=MIN(CloudMask),MAX_VALUE=MAX(CloudMask), $
    LAYOUT=[2,2,3],/CURRENT,TITLE='Cloud Mask')
;  ; Cirrus Mask
;  CirrusMask = imBQATest AND 12288;two most significant bits 0011000000000000
;  result =  IMAGE(CirrusMask,/ORDER,MIN_VALUE=MIN(CirrusMask),MAX_VALUE=MAX(CirrusMask), $
;    LAYOUT=[2,2,4],/CURRENT,TITLE='Cirrus Mask')
    
  ; Water Mask
  WaterMask = imBQATest AND 48;two most significant bits 0011000000000000
  result =  IMAGE(WaterMask,/ORDER,MIN_VALUE=MIN(WaterMask),MAX_VALUE=MAX(WaterMask), $
    LAYOUT=[2,2,4],/CURRENT,TITLE='Water Mask') 
  
  
  
  
END ;orp