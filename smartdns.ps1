# 下载 easylistchina.txt
$fileUrl = "https://raw.githubusercontent.com/easylist/easylistchina/master/easylistchina.txt"
$inputFile = "easylistchina.txt"

Invoke-WebRequest -Uri $fileUrl -OutFile $inputFile

# 输出文件
$outputFile = "easylist-smartdns.conf"

# 只保留纯域名规则并转换为 SmartDNS 格式
$rules = Get-Content $inputFile |
Where-Object {
    $_ -match '^\|\|[a-zA-Z0-9.-]+\^?$'
} |
ForEach-Object {

    $domain = $_ -replace '^\|\|', ''
    $domain = $domain -replace '\^$', ''

    "address /$domain/#"
} |
Sort-Object -Unique

# 当前日期
$currentDate = Get-Date -Format "yyyy-MM-dd"

# 文件头
$header = @"
# Title: easylistchina-smartdns
# TimeUpdated: $currentDate
# Description: EasyList China Lite for SmartDNS

"@

# 写入文件
$header | Set-Content $outputFile -Encoding UTF8
$rules | Add-Content $outputFile -Encoding UTF8

Write-Host "生成完成: $outputFile"
Write-Host "规则数量: $($rules.Count)"
