@echo off
echo Computer Name: %COMPUTERNAME% > HWID_info.txt
wmic computersystem get manufacturer,model /value | findstr /C:"Manufacturer" /C:"Model" >> HWID_info.txt

powershell.exe -noprofile -command "$keyboard = Get-WmiObject Win32_Keyboard | Select-Object -ExpandProperty Description; $mouse = Get-WmiObject Win32_PointingDevice | Select-Object -ExpandProperty Description; $headphones = Get-WmiObject Win32_SoundDevice | Where-Object { $_.ProductName -like '*headphone*' } | Select-Object -ExpandProperty Description; $processor = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name; $disk = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq 'C:' }; $diskGB = [math]::Round($disk.Size / 1GB); $ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory; $ramGB = [math]::Round($ram / 1GB); Add-Content -Path HWID_info.txt -Value ('processor: ' + $processor); Add-Content -Path HWID_info.txt -Value ('Disc Size (GB): ' + $diskGB); Add-Content -Path HWID_info.txt -Value ('RAM (GB): ' + $ramGB); Add-Content -Path HWID_info.txt -Value ('Keyboard: ' + $keyboard); Add-Content -Path HWID_info.txt -Value ('Mouse: ' + $mouse); Add-Content -Path HWID_info.txt -Value ('headphones: ' + $headphones);

powershell.exe -noprofile -command "$ethernet = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetConnectionID -like '*Ethernet*' -and $_.MACAddress -ne $null } | Select-Object -First 1 -ExpandProperty MACAddress; $wifi = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetConnectionID -like '*Wi-Fi*' -and $_.MACAddress -ne $null } | Select-Object -ExpandProperty MACAddress; Add-Content -Path HWID_info.txt -Value ('Ethernet MAC Address: ' + $ethernet); Add-Content -Path HWID_info.txt -Value ('WIFI MAC Address: ' + $wifi);

powershell.exe -noprofile -command "$serialNumber = Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SerialNumber; Add-Content -Path HWID_info.txt -Value ('Serial Number: ' + $serialNumber)"

powershell.exe -noprofile -command "$os = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty InstallDate; $installDate = [Management.ManagementDateTimeConverter]::ToDateTime($os).ToString('MM-dd-yyyy'); Add-Content -Path HWID_info.txt -Value ('Windows Installation Date: ' + $installDate)"
