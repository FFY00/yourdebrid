inc = include_directories('.')

ydlib_sources = [
    # Main
    #'yourdebrid/database.d',
    #'yourdebrid/webserver.d',
    # Util
    'yourdebrid/util/config.d',
    'yourdebrid/util/http.d',
    'yourdebrid/util/rpc.d',
    'yourdebrid/util/structs.d',
    # Model
    'yourdebrid/model/client.d',
    'yourdebrid/model/host.d',
    'yourdebrid/model/source.d',
    # Clients
    #'yourdebrid/connection/clients/deluge.d',
    # Sources
    'yourdebrid/connection/sources/eztv.d',
    'yourdebrid/connection/sources/rarbg.d',
    #'yourdebrid/connection/sources/yts.d',
    # Hosts
    'yourdebrid/connection/hosts/openload.d',
    #'yourdebrid/connection/hosts/thevideo.d',
    'yourdebrid/connection/hosts/vidlox.d',
    ]
ydlib = static_library('yourdebrid',
                        ydlib_sources,
                        include_directories: inc,
                        d_args: '-g', # debug
                        install: true)

# ydlib with unittest enabled
ydlibtest = static_library('yourdebridtest',
                            ydlib_sources,
                            include_directories: inc,
                            d_args: '-unittest',
                            install: false)

#executable('yourdebridd', 'deamon.d')
#executable('yourdebridctl', 'ctl.d')
