# Set Tomcat and Java environment variables
Write-Host "Setting Tomcat and Java environment variables..."
$TOMCAT_HOME = "C:\Tomcat"
$env:JAVA_HOME = "C:\Java\jdk-17.0.15+6"
$env:CATALINA_HOME = "C:\Tomcat"

# Optionally search elsewhere if not found
Write-Host "Checking if Tomcat is installed at $TOMCAT_HOME..."
if (!(Test-Path "$TOMCAT_HOME\bin\catalina.bat")) {
    Write-Error "Tomcat not found at $TOMCAT_HOME\bin\catalina.bat"
    exit 1
}

$CONFIG_FILE = "$TOMCAT_HOME\webapps\ROOT\WEB-INF\classes\WindwardReports.properties"
$LICENSE_LINE = "license=6a1ec2b7-1db4-4336-a181-658d06c00601"

# Start Tomcat in the background (equivalent to catalina.bat run)
Write-Host "Starting Tomcat in background using 'run' mode..."
Start-Process -FilePath "$TOMCAT_HOME\bin\catalina.bat" -ArgumentList "run" -WindowStyle Hidden

# Wait for Tomcat to deploy the application
Write-Host "Waiting 60 seconds for ROOT.war to deploy..."
Start-Sleep -Seconds 120

$timeout = 5
Write-Host "Waiting for $CONFIG_FILE to appear (timeout: $timeout seconds)..."
while (!(Test-Path $CONFIG_FILE) -and ($timeout -gt 0)) {
    Start-Sleep -Seconds 1
    $timeout--
    Write-Host "  Still waiting... ($timeout seconds remaining)"
}

Write-Host "Stopping Tomcat after deployment..."
& "$TOMCAT_HOME\bin\catalina.bat" stop
Write-Host "Tomcat stopped. Waiting 120 seconds for shutdown..."
Start-Sleep -Seconds 5

Write-Host "Moving OfficeToPdf.exe to Tomcat webapps lib folder..."
Move-Item C:\OfficeToPdf.exe C:\Tomcat\webapps\ROOT\WEB-INF\lib\OfficeToPDF.exe

if (Test-Path $CONFIG_FILE) {
    Write-Host "WindwardReports.properties found: $CONFIG_FILE"
    $content = Get-Content $CONFIG_FILE

    if ($content -match '^license=') {
        Write-Host "Replacing existing license entry..."
        $content = $content -replace '^license=.*', $LICENSE_LINE
        Set-Content $CONFIG_FILE $content
        Write-Host "Adding setting: use.external.output.builder=true"
        Add-Content $CONFIG_FILE 'use.external.output.builder=true'
        # Write-Host "Add OfficeToPdf mapping if needed."
        # Add-Content $CONFIG_FILE "OfficeToPdf.exe=C:\OfficeToPdf.exe"
    } else {
        Write-Host "Appending license line (license key not found in file)..."
        Add-Content $CONFIG_FILE $LICENSE_LINE
    }
} else {
    Write-Host "WindwardReports.properties not found; creating and adding license line..."
    Set-Content $CONFIG_FILE $LICENSE_LINE
}

Write-Host "Restarting Tomcat..."
& "$TOMCAT_HOME\bin\catalina.bat" run
