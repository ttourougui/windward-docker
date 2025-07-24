# Use Windows Server Core as base image
FROM mcr.microsoft.com/windows/server:ltsc2022

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Tomcat and Java using Chocolatey
# Example for Tomcat 9.0.80
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Download Microsoft OpenJDK 17 for Windows (ZIP archive)
ADD https://aka.ms/download-jdk/microsoft-jdk-17.0.15-windows-x64.zip C:/openjdk.zip

# Extract OpenJDK to C:\Java
RUN powershell -Command "Expand-Archive -Path C:/openjdk.zip -DestinationPath C:/Java"

# Remove the ZIP file to save space
RUN Remove-Item C:/openjdk.zip

# Download Tomcat
ADD https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.43/bin/apache-tomcat-10.1.43-windows-x64.zip C:/apache-tomcat.zip

# Extract Tomcat
RUN Expand-Archive -Path C:/apache-tomcat.zip -DestinationPath C:/ 
RUN Remove-Item C:/apache-tomcat.zip

# Optionally rename for convenience
RUN Rename-Item -Path C:/apache-tomcat-10.1.43 -NewName C:/Tomcat
RUN Remove-Item -Recurse -Force C:\Tomcat\webapps\ROOT

# Set environment variable for Tomcat home
ENV TOMCAT_HOME="C:\\Tomcat"

# Copy your entrypoint script
COPY entrypoint.ps1 C:\\entrypoint.ps1
COPY OfficeToPdf.exe C:\\OfficeToPdf.exe
COPY RESTfulEngine/ C:/Tomcat/webapps/
# Expose Tomcat port
EXPOSE 8080

# Install MS Office Word 
WORKDIR C:\\odtsetup

ADD https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_17830-20162.exe odtsetup.exe

RUN C:\\odtsetup\\odtsetup.exe /quiet /norestart /extract:C:\\odtsetup

# Copy configuration file 
ADD Configuration.xml .

RUN C:\\odtsetup\\setup.exe /download C:\\odtsetup\\Configuration.xml

RUN C:\\odtsetup\\setup.exe /configure C:\\odtsetup\\Configuration.xml

WORKDIR /

# Remove installation directroy after install
RUN Remove-Item -Path C:\odtsetup -Recurse -Force

# Create the Desktop directory required for Office 365 to function
RUN mkdir C:\\Windows\\SysWOW64\\config\\systemprofile\\Desktop


# Set PowerShell as the entrypoint
ENTRYPOINT ["powershell.exe", "-ExecutionPolicy", "Bypass", "-File", "C:\\entrypoint.ps1"]
