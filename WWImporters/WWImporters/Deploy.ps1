param(
    $Server = "LOCALHOST",
    $DatabaseName = "WideWorldImporters-Dev",
	$Address = '3 High Street'
)
  
# Install-Module SQLServer
Import-Module SQLServer


# Statics
$Dacpac = "bin\debug\WWImporters.dacpac"
$PubProfile = "WWImporters.publish.xml"

Set-Location $PSScriptRoot

if ((Test-Path $Dacpac) -eq $false){
    throw "dacpac not found"}

# Deploy Database using SQLPackage.exe
$SQLPackage = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\130\sqlpackage.exe"

if ((Test-Path $SQLPackage) -eq $false){
    throw "SQLPackage.exe not found"}
&$SQLPackage /Action:Publish /TargetServerName:$Server /TargetDatabaseName:$DatabaseName /SourceFile:$Dacpac /Profile:$PubProfile /Variables:Address=$Address



$cmdvars = "DatabaseName=$DatabaseName"

# Deploy Folder of scripts (testing if they have already been run)
$Folder = 'Scripts\Jobs'
$fileNames = Get-ChildItem -Path $Folder -Recurse -Include *.sql
foreach ($Script in $fileNames){
    $CheckSQL = "SELECT COUNT(*) FROM common.ScriptLog WHERE ScriptName = '"+$Script.Name+"'"
    $LogSQL = "INSERT INTO common.ScriptLog (ScriptName) VALUES ('"+$Script.Name+"')"

    $Completed = (Invoke-Sqlcmd -ServerInstance $Server -Database $DatabaseName -Query $CheckSQL).Item("Column1")
    If ($Completed -eq 0){
       Invoke-Sqlcmd -ServerInstance $Server -Database $DatabaseName -InputFile $Script -Variable $cmdvars
       Invoke-Sqlcmd -ServerInstance $Server -Database $DatabaseName -Query $LogSQL
    }
}
