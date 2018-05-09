project('YourDebrid', 'd',
    version: 'ALPHA-0',
    license: 'AGPLv3')

inc = include_directories('.')

ydlib_sources = [
    #'yourdebrid/database.d',
    'yourdebrid/util.d',
    #'yourdebrid/webserver.d',
    'yourdebrid/external/sources/source.d',
    'yourdebrid/external/sources/eztv.d',
    'yourdebrid/external/sources/rarbg.d',
    #'yourdebrid/external/sources/yts.d',
    #'yourdebrid/external/hosts/vidzi.d'
    ]
ydlib = shared_library('yourdebrid',
                        ydlib_sources,
                        include_directories: inc,
                        install : true)

#executable('yourdebridd', 'deamon.d')
#executable('yourdebridctl', 'ctl.d')

subdir('test')
