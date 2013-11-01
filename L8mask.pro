Pro L8mask

 dirpath = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L8images/LC80170302013269LGN00/'
  filename = 'LC80170302013269LGN00'
  
  ;Image Result
  datatype = 12; UINT
  ;Opening bands
  ;BQA Band -------------------------------
  BQAPath = FILEPATH(filename+'_BQA.TIF',$
    ROOT_DIR = dirpath)
    
  ;B1 Band -------------------------------- 
  B1Path = FILEPATH(filename+'_B1.TIF',$
    ROOT_DIR = dirpath)
    
  ok = QUERY_IMAGE(BQAPath,info)
  help,info,/STRUCTURE
  
  dims = [info.dimensions[0],info.dimensions[1]]
  im=fltarr(dims[0], dims[1])
  
  imBQA = READ_BINARY(BQAPath, DATA_DIMS=dims, DATA_TYPE=datatype)
  
  imB1 = READ_BINARY(B1Path, DATA_DIMS=dims, DATA_TYPE=datatype)
;  tvscl, im, /ord

;  help, im
;  result = IMAGE(im,/ORDER,MIN_VALUE=MIN(im),MAX_VALUE=MAX(im))
  
  PRINT,imBQA((dims[0]-1)/2,(dims[1]-1)/2),FORMAT='(B016)'
  
  xwidth = 256
  ywidth = 256
  
  imB1Test = imB1[(dims[0]-1)/2-xwidth:(dims[0]-1)/2+xwidth-1,(dims[1]-1)/2-ywidth:(dims[1]-1)/2+ywidth-1]
  imB1TestEq = HIST_EQUAL(imB1Test)
  result =  IMAGE(imB1TestEq,/ORDER,MIN_VALUE=MIN(imB1TestEq),MAX_VALUE=MAX(imB1TestEq), $
              LAYOUT=[2,2,1])
             
  
  imBQATest = imBQA[(dims[0]-1)/2-xwidth:(dims[0]-1)/2+xwidth-1,(dims[1]-1)/2-ywidth:(dims[1]-1)/2+ywidth-1]
  result =  IMAGE(imBQATest,/ORDER,MIN_VALUE=MIN(imBQATest),MAX_VALUE=MAX(imBQATest), $
              LAYOUT=[2,2,2],/CURRENT)
 
  
  
END ;orp