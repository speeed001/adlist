# 下载 easylistchina.txt 文件
$fileUrl = "https://raw.githubusercontent.com/easylist/easylistchina/master/easylistchina.txt"
$outputFile = "easylistchina.txt"

Invoke-WebRequest -Uri $fileUrl -OutFile $outputFile

# 过滤内容
$inputFile = "easylistchina.txt"
$outputFilteredFile = "easylist.txt"

$rules = Get-Content $inputFile | Where-Object {
    ($_ -notmatch '(/|@@|#|!|_|\$|=|\[|\^\*|\*\.js|\*\.gif|\*\.htm|\*\.html|:|\|\|sax\*\.sina\.)') -and
    ($_ -match '^\|\|')
} | Sort-Object -Unique

# 规则数量
$ruleCount = $rules.Count

# 获取当前日期
$currentDate = Get-Date -Format "yyyy-MM-dd"

# 文件头
$headerContent = @"
! Title: easylistchinalite-dns
! TimeUpdated: $currentDate
! 规则数量: $ruleCount
! Description: easylistchina精简

"@

# 写入最终文件
$headerContent | Set-Content -Path $outputFilteredFile -Encoding UTF8
$rules | Add-Content -Path $outputFilteredFile -Encoding UTF8

Write-Host "生成完成: $outputFilteredFile"
Write-Host "规则数量: $ruleCount"
