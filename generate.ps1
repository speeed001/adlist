# 下载 easylistchina.txt 文件（不需要代理，GitHub Actions 有公网出口）
$fileUrl = "https://raw.githubusercontent.com/easylist/easylistchina/master/easylistchina.txt"
$outputFile = "easylistchina.txt"

Invoke-WebRequest -Uri $fileUrl -OutFile $outputFile

# 过滤内容
$inputFile = "easylistchina.txt"
$outputFilteredFile = "2.txt"

Get-Content $inputFile | Where-Object {
    ($_ -notmatch '(/|@@|#|!|_|\$|=|\[|\^\*|\*\.js|\*\.gif|\*\.htm|\*\.html|:|\|\|sax\*\.sina\.)') -and ($_ -match '^\|\|')
} | Set-Content $outputFilteredFile

# 获取当前日期
$currentDate = Get-Date -Format "yyyy-MM-dd"

# 定义文件头内容
$headerContent = @"
! Title: easylistchinalite
! TimeUpdated: $currentDate
! Title:
"@

# 合并头部和内容
$fileContent = Get-Content -Path $outputFilteredFile
$newContent = $headerContent + "`n" + ($fileContent -join "`n")

# 写入最终文件
$newContent | Set-Content -Path $outputFilteredFile
