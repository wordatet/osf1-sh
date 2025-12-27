#!/bin/sh
# stress.sh - Paranoid Mode Stress Test for OSF/1 Bourne Shell Port
# Tests loops, pipes, traps, heredocs, and various shell features

# Get the shell to test
TEST_SH="${1:-./sh}"
FAILURES=0

# Colors for output (if terminal supports it)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

pass() {
    echo "${GREEN}PASS${NC}: $1"
}

fail() {
    echo "${RED}FAIL${NC}: $1"
    FAILURES=$((FAILURES + 1))
}

echo "================================================"
echo "OSF/1 Shell Stress Test - Paranoid Mode"
echo "Testing: $TEST_SH"
echo "================================================"
echo ""

# Test 1: Basic echo
echo "Test 1: Basic echo..."
result=$($TEST_SH -c 'echo "Hello World"')
if [ "$result" = "Hello World" ]; then
    pass "Basic echo"
else
    fail "Basic echo (got: $result)"
fi

# Test 2: Variable assignment and expansion
echo "Test 2: Variables..."
result=$($TEST_SH -c 'x=42; echo $x')
if [ "$result" = "42" ]; then
    pass "Variable assignment"
else
    fail "Variable assignment (got: $result)"
fi

# Test 3: For loop
echo "Test 3: For loop..."
result=$($TEST_SH -c 'for i in 1 2 3; do echo $i; done' | tr '\n' ' ' | sed 's/ $//')
if [ "$result" = "1 2 3" ]; then
    pass "For loop"
else
    fail "For loop (got: $result)"
fi

# Test 4: While loop (using expr for classic Bourne sh)
echo "Test 4: While loop..."
result=$($TEST_SH -c 'i=0; while [ $i -lt 3 ]; do i=`expr $i + 1`; echo $i; done' | tr '\n' ' ' | sed 's/ $//')
if [ "$result" = "1 2 3" ]; then
    pass "While loop"
else
    fail "While loop (got: $result)"
fi

# Test 5: If-then-else
echo "Test 5: If-then-else..."
result=$($TEST_SH -c 'if [ 1 -eq 1 ]; then echo yes; else echo no; fi')
if [ "$result" = "yes" ]; then
    pass "If-then-else"
else
    fail "If-then-else (got: $result)"
fi

# Test 6: Pipeline
echo "Test 6: Pipeline..."
result=$($TEST_SH -c 'echo "hello world" | cat | cat')
if [ "$result" = "hello world" ]; then
    pass "Pipeline"
else
    fail "Pipeline (got: $result)"
fi

# Test 7: Command substitution (backticks)
echo "Test 7: Command substitution..."
result=$($TEST_SH -c 'x=`echo hello`; echo $x')
if [ "$result" = "hello" ]; then
    pass "Command substitution"
else
    fail "Command substitution (got: $result)"
fi

# Test 8: Heredoc
echo "Test 8: Heredoc..."
result=$($TEST_SH -c 'cat <<EOF
line1
line2
EOF' | tr '\n' ' ' | sed 's/ $//')
if [ "$result" = "line1 line2" ]; then
    pass "Heredoc"
else
    fail "Heredoc (got: $result)"
fi

# Test 9: Nested loops
echo "Test 9: Nested loops..."
result=$($TEST_SH -c 'for i in 1 2; do for j in a b; do echo $i$j; done; done' | tr '\n' ' ' | sed 's/ $//')
if [ "$result" = "1a 1b 2a 2b" ]; then
    pass "Nested loops"
else
    fail "Nested loops (got: $result)"
fi

# Test 10: Exit status
echo "Test 10: Exit status..."
$TEST_SH -c 'exit 42'
result=$?
if [ $result -eq 42 ]; then
    pass "Exit status"
else
    fail "Exit status (got: $result)"
fi

# Test 11: Glob expansion
echo "Test 11: Glob expansion..."
result=$($TEST_SH -c 'echo *.c 2>/dev/null | wc -w')
if [ "$result" -gt 5 ]; then
    pass "Glob expansion (found $result files)"
else
    fail "Glob expansion (got: $result files)"
fi

# Test 12: Case statement
echo "Test 12: Case statement..."
result=$($TEST_SH -c 'x=hello; case $x in hello) echo yes;; *) echo no;; esac')
if [ "$result" = "yes" ]; then
    pass "Case statement"
else
    fail "Case statement (got: $result)"
fi

# Test 13: Subshell
echo "Test 13: Subshell..."
result=$($TEST_SH -c '(x=inner; echo $x)')
if [ "$result" = "inner" ]; then
    pass "Subshell"
else
    fail "Subshell (got: $result)"
fi

# Test 14: AND/OR operators
echo "Test 14: AND/OR operators..."
result=$($TEST_SH -c 'true && echo yes || echo no')
if [ "$result" = "yes" ]; then
    pass "AND/OR operators"
else
    fail "AND/OR operators (got: $result)"
fi

# Test 15: Many iterations (memory stress) - using expr for classic Bourne sh
echo "Test 15: Loop stress (100 iterations)..."
result=$($TEST_SH -c 'i=0; while [ $i -lt 100 ]; do i=`expr $i + 1`; done; echo $i')
if [ "$result" = "100" ]; then
    pass "Loop stress"
else
    fail "Loop stress (got: $result)"
fi

# Test 16: Function definition
echo "Test 16: Function..."
result=$($TEST_SH -c 'hello() { echo "Hello from function"; }; hello')
if [ "$result" = "Hello from function" ]; then
    pass "Function"
else
    fail "Function (got: $result)"
fi

# Test 17: Trap (basic) - using signal 0 for exit trap in classic Bourne sh
echo "Test 17: Trap..."
result=$($TEST_SH -c 'trap "echo trapped" 0; exit 0' 2>&1)
if echo "$result" | grep -q "trapped"; then
    pass "Trap"
else
    fail "Trap (got: $result)"
fi

# Test 18: Long pipeline
echo "Test 18: Long pipeline..."
result=$($TEST_SH -c 'echo test | cat | cat | cat | cat | cat')
if [ "$result" = "test" ]; then
    pass "Long pipeline"
else
    fail "Long pipeline (got: $result)"
fi

# Test 19: Read command
echo "Test 19: Read command..."
result=$(echo "hello" | $TEST_SH -c 'read x; echo $x')
if [ "$result" = "hello" ]; then
    pass "Read command"
else
    fail "Read command (got: $result)"
fi

# Test 20: cd and pwd
echo "Test 20: cd and pwd..."
result=$($TEST_SH -c 'cd /tmp && pwd')
if [ "$result" = "/tmp" ]; then
    pass "cd and pwd"
else
    fail "cd and pwd (got: $result)"
fi

echo ""
echo "================================================"
echo "Results: $((20 - FAILURES))/20 tests passed"
if [ $FAILURES -eq 0 ]; then
    echo "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo "${RED}$FAILURES tests failed${NC}"
    exit 1
fi
