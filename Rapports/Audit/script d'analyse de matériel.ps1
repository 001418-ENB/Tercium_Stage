$pc = $env:COMPUTERNAME
$date = Get-Date -Format "yyyyMMdd_HHmm"
$output = "$env:USERPROFILE\Desktop\config_$pc`_$date.txt"

"=== CONFIGURATION HARDWARE POUR $pc ===" | Out-File -FilePath $output
"Date : $(Get-Date)`n" | Out-File -Append $output

# CPU
"== CPU ==" | Out-File -Append $output
Get-CimInstance Win32_Processor | ForEach-Object {
    "Nom : $($_.Name)"
    "Cœurs : $($_.NumberOfCores)"
    "Threads : $($_.NumberOfLogicalProcessors)"
    "Fréquence : $($_.MaxClockSpeed) MHz`n"
} | Out-File -Append $output

# RAM
"== RAM ==" | Out-File -Append $output
Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
    "Capacité : $([math]::Round($_.Capacity / 1GB)) Go"
    "Fabricant : $($_.Manufacturer)"
    "Modèle : $($_.PartNumber)"
    "Vitesse : $($_.Speed) MHz`n"
} | Out-File -Append $output

# Disques
"== Disques ==" | Out-File -Append $output
Get-CimInstance Win32_DiskDrive | ForEach-Object {
    "Modèle : $($_.Model)"
    "Taille : $([math]::Round($_.Size / 1GB)) Go"
    "Interface : $($_.InterfaceType)"
    "Type : $($_.MediaType)`n"
} | Out-File -Append $output

# Carte mère
"== Carte mère ==" | Out-File -Append $output
Get-CimInstance Win32_BaseBoard | ForEach-Object {
    "Fabricant : $($_.Manufacturer)"
    "Modèle : $($_.Product)"
    "Numéro de série : $($_.SerialNumber)`n"
} | Out-File -Append $output

# BIOS
"== BIOS ==" | Out-File -Append $output
Get-CimInstance Win32_BIOS | ForEach-Object {
    "Fabricant : $($_.Manufacturer)"
    "Version : $($_.SMBIOSBIOSVersion)"
    "Date : $($_.ReleaseDate)`n"
} | Out-File -Append $output

# GPU
"== Carte graphique ==" | Out-File -Append $output
Get-CimInstance Win32_VideoController | ForEach-Object {
    "Nom : $($_.Name)"
    "Driver : $($_.DriverVersion)"
    "Mémoire : $([math]::Round($_.AdapterRAM / 1MB)) Mo`n"
} | Out-File -Append $output

# Réseau
"== Interfaces réseau ==" | Out-File -Append $output
Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -notlike '*Loopback*'} | ForEach-Object {
    "Interface : $($_.InterfaceAlias) — IP : $($_.IPAddress)"
} | Out-File -Append $output

"`n=== FIN DU RAPPORT ===" | Out-File -Append $output

# Affiche le fichier généré
Write-Host "`n✅ Rapport généré : $output"
