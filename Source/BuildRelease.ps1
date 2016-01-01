﻿if ($PSVersionTable.PSVersion.Major -lt 3)
{
    throw "PowerShell 3 is required.`nhttp://www.microsoft.com/en-us/download/details.aspx?id=40855"
}

Import-Module "$PSScriptRoot\Scripts\BuildHelpers.psm1"

Initialize-BuildVariables
Invoke-NugetRestore "$PSScriptRoot\TimesheetParser.sln"

$env:HVChangeset = (git 'rev-parse' 'HEAD').SubString(0, 7)

Invoke-SolutionBuild "$PSScriptRoot\TimesheetParser.sln" 'Release'

$homePath = $env:homedrive + $env:homepath
$pluginsPath = "$PSScriptRoot\TimesheetParser\bin\Release\Plugins"

if (!(Test-Path $pluginsPath))
{
    New-Item $pluginsPath -ItemType directory
}

# Copy JiraApi dependencies for WPF project.
Copy-Item -Verbose "$homePath\.nuget\packages\FubarCoder.RestSharp.Portable.Core\3.1.0\lib\portable-net45+win+wpa81+wp80+MonoAndroid10+MonoTouch10+Xamarin.iOS10\RestSharp.Portable.Core.dll" $pluginsPath
Copy-Item -Verbose "$homePath\.nuget\packages\FubarCoder.RestSharp.Portable.HttpClient\3.1.0\lib\net45\RestSharp.Portable.HttpClient.dll" $pluginsPath
