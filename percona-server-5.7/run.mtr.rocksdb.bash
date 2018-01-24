engine=rocksdb

for suite in $(basename -a suite/$engine*); do
    if [ ! -f $suite.out ] ; then
        rm -rf var $suite.var
        ./mtr --suite=$suite --force --retry=0 --max-test-fail=0 --parallel=auto --no-warnings --testcase-timeout=60 --big-test >$suite.out 2>&1
        mv var $suite.var
    fi
done

for suite in funcs iuds ; do
    if [ ! -f $engine.engines.$suite.out ] ; then
        rm -rf var $engine.engines.$suite.var
        ./mtr --suite=engines/$suite --mysqld=--default-storage-engine=$engine --mysqld=--default-tmp-storage-engine=$engine --mysqld=--plugin-load=rocksdb=ha_rocksdb.so --parallel=auto --force --retry=0 --max-test-fail=0 --big-test >$engine.engines.$suite.out 2>&1
        mv var $engine.engines.$suite.var
    fi
done
