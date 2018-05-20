project('YourDebrid', 'd', 'cpp',
    version: 'ALPHA-0',
    license: 'AGPLv3')

xmlrpccd_dep = dependency('xmlrpcc-d',
                            version: '>=0.2.1',
                            method: 'dub')

subdir('source')
subdir('assets')
subdir('test')

dub_sources = []
foreach path : ydlib_sources
    dub_sources += join_paths('source', path)
endforeach

dub = import('dub')
dub.generate_dub_file(meson.project_name().to_lower(), meson.source_root(),
                        authors: 'Filipe Laíns',
                        description: 'YourDebrid is a fully open-source debrid service written in D-lang',
                        copyright: 'Copyright © 2018, Filipe Laíns',
                        license: 'AGPLv3',
                        sourceFiles: dub_sources,
                        libs: 'curl'
)