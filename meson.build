project('YourDebrid', 'd', 'cpp',
            version: '0.0.1',
            license: 'AGPL3',
            meson_version: '0.48.0')

# Subdirs
subdir('source')
subdir('assets')
subdir('test')

# Handle dub compatibility
dub_sources = []
foreach path : ydlib_sources
    dub_sources += join_paths('source', path)
endforeach

dlang = import('dlang')
dlang.generate_dub_file(meson.project_name().to_lower(), meson.source_root(),
                        authors: ['Filipe Laíns'],
                        description: 'YourDebrid is a fully open-source debrid service written in D-lang',
                        copyright: 'Copyright © 2018, Filipe Laíns',
                        license: 'AGPLv3',
                        sourceFiles: dub_sources)
