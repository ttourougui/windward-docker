```sh
docker rm apryse-javarestful & docker build -t apryse-javarestful . && docker run -it --name apryse-javarestful -p 8080:8080 -e X-WINDWARD-LICENSE="6a1ec2b7-1db4-4336-a181-658d06c00601" apryse-javarestful
```
```sh
curl -X 'POST' \
  'http://localhost:8080/v2/document' \
  -H 'accept: application/json' \
  -H 'X-WINDWARD-LICENSE: 6a1ec2b7-1db4-4336-a181-658d06c00601' \
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