function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function prompt{
    if(Test-IsAdmin){
        Write-Host "  " -NoNewline -BackgroundColor Black -ForegroundColor red
        write-host "" -NoNewline -ForegroundColor Black -BackgroundColor Green
    }

    Write-Host ("  " + $env:USERNAME.ToUpper() + " ") -foregroundcolor black -BackgroundColor Green -NONEWLINE
    Write-Host "" -ForegroundColor Green -BackgroundColor Yellow -NoNewline
    Write-Host ("  " + $env:COMPUTERNAME.ToUpper() + " ") -foregroundcolor black -BackgroundColor Yellow -NoNewline
    Write-Host "" -ForegroundColor Yellow -BackgroundColor Cyan -NoNewline
    Write-Host ("  " + (Get-Location | Get-Item).Name + " ") -ForegroundColor black -BackgroundColor Cyan -NoNewline
    Write-Host "" -ForegroundColor Cyan -BackgroundColor DarkCyan -NoNewline

    Write-Host "  " -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host $(Get-Date -Format d)"" -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host "   " -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host $(Get-Date -Format t)"" -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host " " -ForegroundColor DarkCyan -NoNewline

    if(Get-GitDirectory){
        Write-Host " "
        $gitStatus = Get-Location | Get-Item | Get-Gitstatus
        $gitBranch = $gitStatus.Branch
        $gitUpstream = $gitStatus.Upstream
        $gitAhead = $gitStatus.Aheadby
        $gitBehind = $gitStatus.Behindby
        $gitWorking = $gitStatus.Working
        $gitIndex = $gitStatus.Index
        $primaryColor = "darkgray"


        Write-Host "  " -BackgroundColor $primaryColor -ForegroundColor white -NoNewline
        Write-Host "$gitBranch  " -BackgroundColor $primaryColor -ForegroundColor White -NoNewline
        if($gitUpstream -ne $null){
            Write-Host "  $gitUpstream " -BackgroundColor $primaryColor -ForegroundColor White -NoNewline
        }

        $AllStatus = @()

        if($gitStatus.hasWorking -eq $True){
            $workingProp = @{total=$($gitWorking.length);color="DarkRed";symbol="";name="Unstaged:"}
            $Working = New-Object -TypeName PSObject -Property $workingProp
            $Allstatus += $Working
        }

        if($gitStatus.hasIndex -eq $True){
            $indexProp = @{total=$($gitIndex.length);color="DarkGreen";symbol="";name="Staged:"}
            $Index = New-Object -TypeName PSObject -Property $indexProp
            $Allstatus += $Index
        }

        if($gitAhead -gt 0){
            $aheadProp = @{total=$gitAhead;color="DarkGreen";symbol="";name="Ahead:"}
            $Ahead = New-Object -TypeName PSObject -Property $aheadProp
            $Allstatus += $Ahead
        }

        if($gitBehind -gt 0){
            $behindProp = @{total=$gitBehind;color="DarkRed";symbol="";name="Behind:"}
            $Behind = New-Object -TypeName PSObject -Property $behindProp
            $Allstatus += $Behind
        }
        if($allstatus.length -ne 0){
            for($g=0; $g -lt $allstatus.length; $g++){
                $curItem = $allstatus[$g]
                $nextItem = $allstatus[$g + 1]
                $preItem = $allstatus[$g - 1]
                if($g -eq 0){
                    Write-Host " " -ForegroundColor DarkGray -BackgroundColor $curitem.color -NoNewline
                } else {
                    Write-Host " " -ForegroundColor $preitem.color -BackgroundColor $curitem.color -NoNewline
                }
                Write-Host " $($curitem.symbol) $($curitem.name) $($curitem.total) " -BackgroundColor $curitem.color -nonewline
                if($($g+1) -eq $allstatus.length){
                    Write-Host " " -ForegroundColor $curitem.color -NoNewline
                }
            }
        } else {
            Write-Host " " -ForegroundColor DarkGray -NoNewline
        }
    } 
    Write-Host " "
    Return "PS> "
}
