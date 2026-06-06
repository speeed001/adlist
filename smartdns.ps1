# 下载 easylistchina.txt
$fileUrl = "https://raw.githubusercontent.com/easylist/easylistchina/master/easylistchina.txt"
$inputFile = "easylistchina.txt"

Invoke-WebRequest -Uri $fileUrl -OutFile $inputFile

# 过滤并转换为 SmartDNS 规则
$outputFile = "easylist-smartdns.conf"

$rules = Get-Content $inputFile | Where-Object {
    ($_ -notmatch '(/|@@|#|!|_|\$|=|\[|\^\*|\*\.js|\*\.gif|\*\.htm|\*\.html|:|\|\|sax\*\.sina\.)') -and ($_ -match '^\|\|')
} | ForEach-Object {

    $domain = $_ -replace '^\|\|', ''
    $domain = $domain -replace '\^$', ''

    "address /$domain/#"
}

# 文件头
$currentDate = Get-Date -Format "yyyy-MM-dd"

$header = @"
# Title: easylistchina-smartdns
# TimeUpdated: $currentDate
# Description: easylistchina -> SmartDNS

"@

$header | Set-Content $outputFile -Encoding UTF8
$rules | Add-Content $outputFile -Encoding UTF8

Write-Host "生成完成: $outputFile"
