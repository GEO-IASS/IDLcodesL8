PRO test1
;; Launch the application
;e = ENVI()
; 
;; Open a file
;file = FILEPATH('LC80160302013118LGN00_B1.TIF', ROOT_DIR='/Users/javier/Desktop/Javier/PHD_RIT/LDCM/LDCMimages/LC80160302013118LGN00/')
;raster = e.OpenRaster(file)
; 
;; Display the data
;view = e.GetView()
;layer = view.CreateLayer(raster)
; 
;; Close the dataset and remove it from the display
;raster.Close

file_name ='LC80170302013082LGN00'
strMTL = '/Users/javier/Desktop/Javier/PHD_RIT/LDCM/LDCMimages/'+file_name+'/'+file_name+'_MTL.txt
OPENR,lun,strMTL,/GET_LUN
header = STRARR(144)
READF, lun, header
;PRINT, header

rows = 22
data = STRARR(rows)
READF, lun, data
data = REFORM(data)
print,data[1]
status = execute(data[1])
;PRINT, RADIANCE_MULT_BAND_2
help, data

mul = data[0:10]
bias = data[11:21]

print, mul

print, 'NEXT'
print, bias
END ;orp