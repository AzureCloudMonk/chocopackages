﻿$ErrorActionPreference = 'Stop';

if ($PSVersionTable.BuildVersion -lt 6.1) { throw 'Windows 7 and newer required.'}

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url = 'https://s3.amazonaws.com/parsec-build/package/parsec-windows32.exe'
$url64 = 'https://s3.amazonaws.com/parsec-build/package/parsec-windows.exe'
$pp = Get-PackageParameters
$installDriver = $pp['InstallControllerDriver'] -eq 'true'
New-Item -Path $toolsDir -Name 'parsec-windows32.exe.gui', 'parsec-windows.exe.gui' -ItemType File -Force -ErrorAction SilentlyContinue

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'EXE'
    url            = $url
    url64bit       = $url64
    softwareName   = 'parsec*'
    checksum       = '1ef14507af49b87c01c740905b3e7f0fc08170c92e06db5a6a5af3b3f0496585'
    checksumType   = 'sha256'
    checksum64     = '405a79d5827969a6adf284d6c229e3e27c8bb1e0fd8f3c12f1dfed4029dd49f4'
    checksumType64 = 'sha256'
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    validExitCodes = @(0)
}

$ahkExe = 'AutoHotKey'
$ahkFile = Join-Path $toolsDir "installParsec.ahk"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkFile,$installDriver.ToString() -PassThru
 
Install-ChocolateyPackage @packageArgs
