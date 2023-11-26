function Get-AZ-CLI() {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
    Remove-Item .\AzureCLI.msi
}

function Get-AWS-CLI() {
    Start-Process msiexec.exe -Wait -ArgumentList '/i https://awscli.amazonaws.com/AWSCLIV2.msi /qn'
}

function Get-AZ-Modules() {
    Install-PackageProvider NuGet -Force
    Set-PSRepository PSGallery -InstallationPolicy Trusted
    Install-Module AzureAD -Repository PSGallery
    Install-Module Az -Repository PSGallery
    Install-Module AWS.Tools.Installer -Repository PSGallery
}

# Download the package
function Get-Arc-Download() {$ProgressPreference="SilentlyContinue"; Invoke-WebRequest -Uri https://aka.ms/AzureConnectedMachineAgent -OutFile AzureConnectedMachineAgent.msi}
download

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Get-Arc-Download
Get-AZ-CLI
Get-AWS-CLI
Get-AZ-Modules
