# Test library
test_sources = [
    'source_imp.d'
    ]
testlib = static_library('tests',
                            test_sources,
                            include_directories : inc,
                            link_with: ydlib,
                            install : false)

# Test sources
test_source_exe = executable('test-source', 'source.d',
                                include_directories : inc,
                                link_with: [ydlibtest, testlib])

# Test hosts
test_host_exe = executable('test-host', 'host.d',
                            include_directories : inc,
                            link_with: [ydlibtest, testlib])

# Test full
#test_full_exe = executable('test-full', 'full.d',
#                            include_directories : inc,
#                            link_with: [ydlib, testlib],
#                            d_args: '-g') # debug

test('source test', test_source_exe)
test('host_test', test_host_exe, timeout:360) # 2min for each host seems fine

run_target('run-tests',
            command : '../scripts/run-tests.sh')
