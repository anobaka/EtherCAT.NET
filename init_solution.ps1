Write-Host "Updating Git submodule."
git submodule update --init --recursive --quiet

# x86
Write-Host "Creating native x86 project."
$path = "$($PSScriptRoot)/artifacts/bin32"
New-Item -Force -ItemType directory -Path $path
Set-Location -Path $path

if ($IsWindows)
{
	cmake ./../../native -DCMAKE_CONFIGURATION_TYPES:STRING="Debug;Release" -G "Visual Studio 17 2022" -A "Win32"
}
elseif ($IsLinux)
{
    cmake ./../../native -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32 -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
}
elseif ($IsMacOS)
{
    # The i386 architecture is deprecated for macOS
    throw [System.PlatformNotSupportedException]
}
else 
{
    throw [System.PlatformNotSupportedException]
}

# x64
Write-Host "Creating native x64 project."
$path = "$($PSScriptRoot)/artifacts/bin64"
New-Item -Force -ItemType directory -Path $path
Set-Location -Path $path

if ($IsWindows)
{
	cmake ./../../native -DCMAKE_CONFIGURATION_TYPES:STRING="Debug;Release" -G "Visual Studio 17 2022" -A "x64"
}
elseif ($IsLinux -or $IsMacOS)
{
    cmake ./../../native -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64
}
else 
{
    throw [System.PlatformNotSupportedException]
}

# return
Set-Location -Path $PSScriptRoot
