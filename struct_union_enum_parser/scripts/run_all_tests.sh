#!/bin/bash

echo "========== Test 1: Simple variable definition =========="
./parser simple_test.c

echo ""
echo "========== Test 2: Struct, Union, Enum, Typedef =========="
./parser test2.c

echo ""
echo "========== Test 3: Pointer array =========="
./parser test_ptr_array.c

echo ""
echo "========== Test 4: Array pointer =========="
./parser test_array_ptr.c

echo ""
echo "========== Test 5: Comprehensive test =========="
./parser comprehensive_test.c

echo ""
echo "========== All tests completed =========="

