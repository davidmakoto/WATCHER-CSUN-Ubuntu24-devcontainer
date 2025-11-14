# Setting Up GUI Applications (Gazebo) in Devcontainer on Windows

This guide explains how to run GUI applications like Gazebo Simulator (`gz sim`) from your devcontainer on Windows.

## Problem
You're getting this error when running `gz sim`:
```
qt.qpa.xcb: could not connect to display
```

This happens because GUI applications need a display server, and containers don't have direct access to your Windows display.

## Solution Overview
There are two approaches for Windows:

### Option 1: WSLg (Recommended - Built into Windows 11)
Windows 11 and recent Windows 10 updates include WSLg (Windows Subsystem for Linux GUI), which automatically handles GUI forwarding.

### Option 2: External X Server (VcXsrv/X410)
Use a third-party X server application.

---

## Option 1: Using WSLg (Windows 11 / Recent Windows 10)

### Prerequisites
- Windows 11 or Windows 10 build 19044+ (Run `winver` to check)
- WSL2 must be up to date

### Step 1: Update WSL
Open PowerShell as Administrator and run:
```powershell
wsl --update
wsl --shutdown
```

### Step 2: Verify WSLg is Working
In WSL, check if the display socket exists:
```bash
ls -la /mnt/wslg/
echo $DISPLAY
```

You should see a `WAYLAND_DISPLAY` and other files. `$DISPLAY` should show something like `:0`.

### Step 3: Rebuild Your Devcontainer
The devcontainer.json has been updated to support GUI apps. Rebuild the container:
```bash
devcontainer up --workspace-folder . --remove-existing-container
```

### Step 4: Test X11 in the Container
```bash
devcontainer exec --workspace-folder . bash
# Inside the container:
xeyes  # Should open a window with eyes that follow your cursor
```

### Step 5: Run Gazebo
```bash
devcontainer exec --workspace-folder . gz sim
```

---

## Option 2: Using VcXsrv (Alternative Method)

### Step 1: Install VcXsrv
1. Download from: https://sourceforge.net/projects/vcxsrv/
2. Install the application
3. Launch XLaunch

### Step 2: Configure XLaunch
When starting VcXsrv:
1. **Display settings**: Choose "Multiple windows"
2. **Client startup**: Choose "Start no client"
3. **Extra settings**:
   - ✅ Check "Disable access control" (important!)
   - ✅ Check "Native opengl"
   - ✅ Check "Clipboard"
4. Save configuration for future use

### Step 3: Get Your Windows IP Address
In PowerShell:
```powershell
# Get your Windows IP address on the WSL network
(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "*WSL*").IPAddress
```

Or in WSL:
```bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
echo $DISPLAY
```

### Step 4: Set DISPLAY Variable in WSL
Add to your `~/.bashrc` in WSL:
```bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
```

### Step 5: Rebuild Container and Test
```bash
devcontainer up --workspace-folder . --remove-existing-container
devcontainer exec --workspace-folder . bash
# Test with:
xeyes
gz sim
```

---

## Troubleshooting

### Issue: "could not connect to display"
**Solution 1**: Check if display variable is set
```bash
devcontainer exec --workspace-folder . bash -c "echo \$DISPLAY"
```

**Solution 2**: Manually set DISPLAY when running commands
```bash
devcontainer exec --workspace-folder . bash -c "export DISPLAY=:0 && gz sim"
```

### Issue: "authorization required"
**Solution**: If using VcXsrv, make sure "Disable access control" is checked in XLaunch settings.

### Issue: WSLg not working
**Solution**: 
1. Update WSL: `wsl --update`
2. Restart WSL: `wsl --shutdown` then start again
3. Check Windows version: You need Windows 11 or Windows 10 19044+

### Issue: Black screen or frozen GUI
**Solution**: Try adding these to your environment:
```bash
export LIBGL_ALWAYS_INDIRECT=0
export QT_X11_NO_MITSHM=1
```

### Issue: GPU acceleration not working
**Solution**: Make sure you have:
1. NVIDIA drivers installed on Windows
2. NVIDIA Container Toolkit installed in WSL
3. The `--gpus=all` flag in runArgs (already in updated devcontainer.json)

---

## Quick Test Commands

After setup, test with these commands:

```bash
# Test 1: Check if X11 display is accessible
devcontainer exec --workspace-folder . bash -c "echo \$DISPLAY"

# Test 2: Run simple X11 app
devcontainer exec --workspace-folder . bash -c "xeyes"

# Test 3: Check OpenGL
devcontainer exec --workspace-folder . bash -c "glxinfo | grep OpenGL"

# Test 4: Run Gazebo
devcontainer exec --workspace-folder . gz sim
```

---

## What Changed in devcontainer.json

The updated configuration includes:

1. **Environment Variables**: Set DISPLAY and other X11-related variables
2. **Mounts**: Mount X11 socket and WSLg directories into container
3. **Run Args**: Enable GPU support and networking needed for display forwarding

These changes allow the container to access your Windows display through WSL2.

---

## Additional Resources

- [WSLg Documentation](https://github.com/microsoft/wslg)
- [VcXsrv Documentation](https://sourceforge.net/projects/vcxsrv/)
- [Gazebo Documentation](https://gazebosim.org/docs)
- [Devcontainer Specification](https://containers.dev/)






