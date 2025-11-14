#!/bin/bash

# Quick test script for GUI support in devcontainer
# Run this from the HOST (not inside container)

echo "========================================="
echo "GUI Support Test for Devcontainer"
echo "========================================="
echo ""

echo "Test 1: Check DISPLAY variable in container"
echo "-------------------------------------------"
devcontainer exec --workspace-folder . bash -c 'echo "DISPLAY=$DISPLAY"'
echo ""

echo "Test 2: Check if X11 libraries are available"
echo "--------------------------------------------"
devcontainer exec --workspace-folder . bash -c 'ldconfig -p | grep libX11 | head -n 1'
echo ""

echo "Test 3: Try to run a simple X11 app (xeyes)"
echo "--------------------------------------------"
echo "If this works, you should see a window with eyes."
echo "Press Ctrl+C to continue after the window appears..."
devcontainer exec --workspace-folder . bash -c 'xeyes 2>&1' &
XEYES_PID=$!
sleep 3
kill $XEYES_PID 2>/dev/null
echo ""

echo "Test 4: Check OpenGL support"
echo "-------------------------------------------"
devcontainer exec --workspace-folder . bash -c 'glxinfo 2>/dev/null | grep "OpenGL version" || echo "OpenGL not available"'
echo ""

echo "========================================="
echo "If all tests passed, try running Gazebo:"
echo "  devcontainer exec --workspace-folder . gz sim"
echo ""
echo "If tests failed, see X11_SETUP_GUIDE.md for troubleshooting"
echo "========================================="






