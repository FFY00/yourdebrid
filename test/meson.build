# Test library
test_sources = [
    'source_imp.d'
    ]
testlib = shared_library('tests',
                            test_sources,
                            include_directories : inc,
                            link_with: ydlib,
                            install : false)

# Test source - show
executable('test-source-show', 'source_show.d',
    include_directories : inc,
    link_with: [ydlibtest, testlib]
)

# Test source - movie
executable('test-source-movie', 'source_movie.d',
    include_directories : inc,
    link_with: [ydlibtest, testlib]
)

run_target('run-tests',
  command : '../scripts/run-tests.sh')