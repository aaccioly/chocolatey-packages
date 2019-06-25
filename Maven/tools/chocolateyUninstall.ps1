[Environment]::SetEnvironmentVariable('M2_HOME', $null, "Machine")

#Using registry method prevents expansion (and loss) of environment variables (whether the target of the removal or not)
#To avoid bad situations - does not use substring matching or regular expressions
#Removes duplicates of the target removal path, Cleans up double ";", Handles ending "\"
$pathToRemove = '%M2_HOME%\bin'
$unexpandedPath = (Get-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames') 

foreach ($path in "$unexpandedPath".split(';')) {
    If ($path -ine "$pathToRemove" -And $path -ine "$pathToRemove\") {
        [string[]]$newpath += "$path"
    }
}
$assembledNewPath = ($newpath -join (';')).trimend(';')

[Environment]::SetEnvironmentVariable("PATH", $assembledNewPath, "Machine")