
# Pre-reqs ----------------------------------------------------------------

setwd("~/git/ECStations/reports/demo/")

library(sp)

# Precip stations ---------------------------------------------------------

# Station shorthand names
stations <- c('YVR','YYJ','YQQ','YZT','YKA','YYE','YYF','YXJ','YXX','YXT',
              'YWL','YXC','YYD','YXS','YAZ','YZP','YQZ','YCD','WKV','YPR',
              'YXY','YRV','WAE','WSK')
# Station names in Climate Manager
snames <- c('VANCOUVER INT\'L A',
            'VICTORIA INT\'L A',
            'COMOX A',
            'PORT HARDY A',
            'KAMLOOPS A',
            'FORT NELSON A',
            'PENTICTON A',
            'FORT ST JOHN A',
            'ABBOTSFORD A',
            'TERRACE A',
            'WILLIAMS LAKE A',
            'CRANBROOK A',
            'SMITHERS A',
            'PRINCE GEORGE A',
            'TOFINO A',
            'SANDSPIT A',
            'QUESNEL A',
            'NANAIMO A',
            'HOPE SLIDE',
            'PRINCE RUPERT A',
            'WHITEHORSE A',
            'REVELSTOKE A',
            'WHISTLER',
            'SQUAMISH')

# Station IDs
sid <- c('1108447','1018620','1021830','1026270','1163780','1192940','1126150',
         '1183000','1100030','1068130','1098940','1152102','1077500','1096450',
         '1038205','1057050','1096630','1025370','1113581','1066481','2101300',
         '1176749','1048898','10476F0')

# Longitudes and latitudes
lats <- c(49.2,48.63,49.7,50.68,50.7,58.83,49.45,56.23,49.03,54.47,
          52.18,49.62,54.82,53.88,49.07,53.25,53.02,49.05,49.28,
          54.28,60.72,50.97,50.13,49.78)
lons <- c(-123.17,-123.42,-124.88,-127.37,-120.43,-122.6,-119.6,-120.73,
          -122.37,-128.57,-122.05,-115.78,-127.18,-122.68,-125.77,-131.8,-122.5,
          -123.87,-121.23,-130.45,-135.07,-118.18,-122.95,-123.17)

# From Google Earth, using meta data from kmz files from 
# \\PYRVANFP07\PWCusers\Common\PUBLIC_Program\PUBLIC_Program_ABase\Community Forecast\
regions <- c('Greater Vancouver',
             'Greater Victoria',
             'East Vancouver Island',
             'North Vancouver Island',
             'South Thompson',
             'Fort Nelson',
             'Okanagan Valley',
             'B.C. Peace River',
             'Fraser Valley',
             'North Coast - inland sections',
             'Cariboo',
             'East Kootenay',
             'Bulkley Valley and The Lakes',
             'Prince George',
             'West Vancouver Island',
             'Queen Charlottes',
             'Cariboo',
             'East Vancouver Island',
             'Similkameen',
             'North Coast - coastal sections',
             'Whitehorse',
             'West Columbia',
             'Whistler',
             'Howe Sound')

# Set the spatial attributes for the stations
sdata <- data.frame(station=stations, lat=lats, lon=lons, region=regions, cm_names=snames)
coordinates(sdata) <- ~lon+lat
proj4string(sdata) <- CRS("+proj=longlat +datum=WGS84")

# Save
write.csv(file="data/station_meta_data_df.csv", row.names=FALSE,
          data.frame(Name=snames, Station=stations, StationId=sid,
                     Longitude=lons, Latitude=lats, Region=regions))
saveRDS(sdata, "data/station_meta_data_sp.rds")