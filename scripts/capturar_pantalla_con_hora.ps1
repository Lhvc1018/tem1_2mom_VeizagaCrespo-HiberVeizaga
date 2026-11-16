param([Parameter(Mandatory=$true)][string]$Output)

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class TaskbarVisible {
    [StructLayout(LayoutKind.Sequential)]
    public struct Point { public int X; public int Y; }
    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out Point point);
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern IntPtr FindWindow(string className, string windowName);
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr window, int command);
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr window, IntPtr after, int x, int y, int width, int height, uint flags);
}
'@
[TaskbarVisible]::SetProcessDPIAware() | Out-Null
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = [System.Drawing.Bitmap]::new($bounds.Width, $bounds.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$cursor = [TaskbarVisible+Point]::new()
$hasCursor = [TaskbarVisible]::GetCursorPos([ref]$cursor)
try {
    $taskbar = [TaskbarVisible]::FindWindow('Shell_TrayWnd', $null)
    if ($taskbar -ne [IntPtr]::Zero) {
        [TaskbarVisible]::ShowWindow($taskbar, 5) | Out-Null
        [TaskbarVisible]::SetWindowPos($taskbar, [IntPtr]::new(-1), 0, 0, 0, 0, 0x0043) | Out-Null
    }
    # Move off taskbar buttons so Windows Terminal's thumbnail closes before capture.
    [TaskbarVisible]::SetCursorPos($bounds.Right - 80, $bounds.Top + 150) | Out-Null
    Start-Sleep -Milliseconds 1000
    $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    $bitmap.Save($Output, [System.Drawing.Imaging.ImageFormat]::Png)
} finally {
    if ($hasCursor) {
        [TaskbarVisible]::SetCursorPos($cursor.X, $cursor.Y) | Out-Null
    }
    $graphics.Dispose()
    $bitmap.Dispose()
}
