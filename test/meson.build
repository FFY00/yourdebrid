# Test library
test_sources = [
    'source_imp.d'
    ]
testlib = shared_library('tests',
                            test_sources,
                            include_directories : inc,
                            link_with: ydlib,
                            install : false)

# Test source
executable('test-source', 'source.d',
    include_directories : inc,
    link_with: [ydlibtest, testlib]
)

run_target('run-tests',
  command : '../scripts/run-tests.sh')