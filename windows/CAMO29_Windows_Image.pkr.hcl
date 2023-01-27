source "azure-arm" "windows_2019" {
  azure_tags = {
    task = "CAMO-29"
    base-image = "${var.image_publisher}:${var.image_offer}:${var.image_sku}"
    ExcludeMdeAutoProvisioning = "true"
  }
  
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  image_offer                       = var.image_offer
  image_publisher                   = var.image_publisher
  image_sku                         = var.image_sku
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  managed_image_resource_group_name = var.resource_group_name
  location                          = "East US"
  managed_image_name                = "CAMO29-Windows2019-Image"
  os_type                           = "Windows"
  communicator                      = "winrm"
  vm_size                           = "Standard_D2_v2"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

build {
  sources = ["source.azure-arm.windows_2019"]

  provisioner "powershell" {
    inline = [
      "Add-WindowsFeature Web-Server", 
      "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { Write-Output $imageState.ImageState; break } }"
      ]
  }

}
