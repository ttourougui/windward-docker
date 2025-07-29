```sh
docker rm apryse-javarestful & docker build -t apryse-javarestful . && docker run -it --name apryse-javarestful -p 8080:8080 apryse-javarestful
```
```ps1
# Remove the container if it exists
if (docker ps -a -q -f name=apryse-javarestful) {
    docker rm apryse-javarestful
}

# Build the Docker image
docker build -t apryse-javarestful .

# Run the container
docker run -it --name apryse-javarestful -p 8080:8080  apryse-javarestful

```
```sh
curl -X 'POST' \
  'http://localhost:8080/v2/document' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "Callback": null,
  "OutputFormat": "pdf",
  "Data": null,
  "ConnectionString": "https://fluent-sample-templates.s3.amazonaws.com/Fluent_Financial_Report_Template.docx",
  "Format": "docx",
  "Properties": null,
  "Parameters": null,
  "Datasources": [
    {
      "Name": "WRFINANCIAL",
      "Type": "xml",
      "ClassName": null,
      "ConnectionString": "https://fluent-sample-templates.s3.amazonaws.com/Fluent_Financial_Data.xml",
      "SchemaConnectionString": null,
      "Data": null,
      "SchemaData": null
    }
  ],
  "Tag": null,
  "TrackImports": false,
  "TrackErrors": 3,
  "MainPrinter": null,
  "FirstPagePrinter": null,
  "PrinterJobName": null,
  "PrintCopies": 0,
  "PrintDuplex": null
}'
```

```powershell
$headers = @{
    "accept" = "application/json"
    "Content-Type" = "application/json"
}

$body = @{
    Callback = $null
    OutputFormat = "pdf"
    Data = $null
    ConnectionString = "https://github.com/ttourougui/windward-docker/blob/main/KID_Template_TEM713553743_Jupiter.docx"
    Format = "docx"
    Properties = $null
    Parameters = $null
    Datasources = @(
        @{
            Name = "WRFINANCIAL"
            Type = "json"
            ClassName = $null
            ConnectionString = "https://github.com/ttourougui/windward-docker/blob/main/KID_PRIIPs_LU1981107367_fr_CH.json"
            SchemaConnectionString = $null
            Data = $null
            SchemaData = $null
        }
    )
    Tag = $null
    TrackImports = $false
    TrackErrors = 3
    MainPrinter = $null
    FirstPagePrinter = $null
    PrinterJobName = $null
    PrintCopies = 0
    PrintDuplex = $null
}

Invoke-RestMethod `
    -Uri "http://localhost:8080/v2/document" `
    -Method POST `
    -Headers $headers `
    -Body ($body | ConvertTo-Json -Depth 5) `
    -ContentType "application/json"

```
```
2025-07-28 10:29:45 INFO  net.windward.xmlreport.ProcessReport:[] - Using properties: file:/C:/Tomcat/webapps/ROOT/WEB-INF/classes/WindwardReports.properties
* Using properties: file:/C:/Tomcat/webapps/ROOT/WEB-INF/classes/WindwardReports.properties
```

```

Get-CimInstance -ClassName Win32_DCOMApplication | Where-Object { $_.Name -like "*Word*" } | Select-Object Name, AppID

Name    AppID
----    -----
Wordpad {fd6c8b29-e936-4a61-8da6-b0c12ad3ba00}

$AppId = "{fd6c8b29-e936-4a61-8da6-b0c12ad3ba00}"
$keypath = "HKLM:\SOFTWARE\Classes\AppID\$AppId"
Set-ItemProperty -Path $keypath -Name RunAs -Value "ContainerAdministrator"

```