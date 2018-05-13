#requests_dep = dependency('requests', fallback: ['requests', 'requests_dep'])

inc = include_directories('.')

ydlib_sources = [
    #'yourdebrid/database.d',
    #'yourdebrid/webserver.d',
    'yourdebrid/util/config.d',
    'yourdebrid/util/http.d',
    'yourdebrid/util/util.d',
    'yourdebrid/external/sources/source.d',
    'yourdebrid/external/sources/eztv.d',
    'yourdebrid/external/sources/rarbg.d',
    #'yourdebrid/external/sources/yts.d',
    'yourdebrid/external/hosts/host.d',
    'yourdebrid/external/hosts/openload.d',
    'yourdebrid/external/hosts/streamango.d',
    #'yourdebrid/external/hosts/thevideo.d',
    'yourdebrid/external/hosts/vidlox.d'
    #'yourdebrid/external/hosts/vidup.d',
    ]
ydlib = static_library('yourdebrid',
                        ydlib_sources,
                        include_directories: inc,
                        install : true)

# ydlist with unittest enabled
ydlibtest = static_library('yourdebridtest',
                            ydlib_sources,
                            include_directories: inc,
                            d_args : '-unittest',
                            install : false)

#executable('yourdebridd', 'deamon.d')
#executable('yourdebridctl', 'ctl.d')