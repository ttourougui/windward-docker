# Dynamically find Tomcat installation if needed
# Set to your known install path
$TOMCAT_HOME = "C:\Tomcat"
$env:JAVA_HOME = "C:\Java\jdk-17.0.15+6"
$env:CATALINA_HOME = "C:\Tomcat"



# Optionally search elsewhere if not found
if (!(Test-Path "$TOMCAT_HOME\bin\catalina.bat")) {
    Write-Error "Tomcat not found at $TOMCAT_HOME\bin\catalina.bat"
    exit 1
}


$CONFIG_FILE = "$TOMCAT_HOME\webapps\ROOT\WEB-INF\classes\WindwardReports.properties"
$LICENSE_LINE = "license=6a1ec2b7-1db4-4336-a181-658d06c00601"

& "$TOMCAT_HOME\bin\catalina.bat" run
Start-Sleep -Seconds 60

$timeout = 5
while (!(Test-Path $CONFIG_FILE) -and ($timeout -gt 0)) {
    Start-Sleep -Seconds 1
    $timeout--
}

if (Test-Path $CONFIG_FILE) {
    $content = Get-Content $CONFIG_FILE
    if ($content -match '^license=') {
        $content = $content -replace '^license=.*', $LICENSE_LINE
        Set-Content $CONFIG_FILE $content
        Add-Content $CONFIG_FILE 'use.external.output.builder=true'
        Add-Content $CONFIG_FILE "OfficeToPdf.exe=C:\OfficeToPdf.exe"
    } else {
        Add-Content $CONFIG_FILE $LICENSE_LINE
    }
} else {
    Set-Content $CONFIG_FILE $LICENSE_LINE
}

& "$TOMCAT_HOME\bin\catalina.bat" stop
Start-Sleep -Seconds 30

& "$TOMCAT_HOME\bin\catalina.bat" run
