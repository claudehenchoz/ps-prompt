function Test-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# Set Prompt
function prompt{
    if(Test-IsAdmin){
        Write-Host "  " -NoNewline -BackgroundColor Black -ForegroundColor red
        write-host "" -NoNewline -ForegroundColor Black -BackgroundColor Green
    }

    write-host ("  " + $env:USERNAME.ToUpper() + " ") -foregroundcolor black -BackgroundColor Green -NONEWLINE
    write-host "" -ForegroundColor Green -BackgroundColor Yellow -NoNewline
    write-host ("  " + $env:COMPUTERNAME.ToUpper() + " ") -foregroundcolor black -BackgroundColor Yellow -NoNewline
    write-host "" -ForegroundColor Yellow -BackgroundColor Cyan -NoNewline
    write-host ("  " + (Get-Location | Get-Item).Name + " ") -ForegroundColor black -BackgroundColor Cyan -NoNewline
    write-host "" -ForegroundColor Cyan -BackgroundColor DarkCyan -NoNewline

    Write-Host "  " -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host $(Get-Date -Format d)"" -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host "   " -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host $(Get-Date -Format t)"" -ForegroundColor white -BackgroundColor DarkCyan -NoNewline
    Write-Host " " -ForegroundColor DarkCyan -NoNewline

    if(get-gitdirectory){
        write-host " "
        $gitStatus = Get-Location | Get-Item | Get-Gitstatus
        $gitBranch = $gitStatus.Branch
        $gitUpstream = $gitStatus.Upstream
        $gitAhead = $gitStatus.Aheadby
        $gitBehind = $gitStatus.Behindby
        $gitWorking = $gitStatus.Working
        $gitIndex = $gitStatus.Index
        $primaryColor = "darkgray"


        write-host "  " -BackgroundColor $primaryColor -ForegroundColor white -NoNewline
        write-host "$gitBranch  " -BackgroundColor $primaryColor -ForegroundColor White -NoNewline
        if($gitUpstream -ne $null){
            write-host "  $gitUpstream " -BackgroundColor $primaryColor -ForegroundColor White -NoNewline
        }

        $AllStatus = @()

        if($gitStatus.hasWorking -eq $True){
            $workingProp = @{total=$($gitWorking.length);color="DarkRed";symbol="";name="Unstaged:"}
            $Working = new-object -TypeName PSObject -Property $workingProp
            $Allstatus += $Working
        }

        if($gitStatus.hasIndex -eq $True){
            $indexProp = @{total=$($gitIndex.length);color="DarkGreen";symbol="";name="Staged:"}
            $Index = new-object -TypeName PSObject -Property $indexProp
            $Allstatus += $Index
        }

        if($gitAhead -gt 0){
            $aheadProp = @{total=$gitAhead;color="DarkGreen";symbol="";name="Ahead:"}
            $Ahead = new-object -TypeName PSObject -Property $aheadProp
            $Allstatus += $Ahead
        }

        if($gitBehind -gt 0){
            $behindProp = @{total=$gitBehind;color="DarkRed";symbol="";name="Behind:"}
            $Behind = new-object -TypeName PSObject -Property $behindProp
            $Allstatus += $Behind
        }
        if($allstatus.length -ne 0){
            for($g=0; $g -lt $allstatus.length; $g++){
                $curItem = $allstatus[$g]
                $nextItem = $allstatus[$g + 1]
                $preItem = $allstatus[$g - 1]
                if($g -eq 0){
                    write-host " " -ForegroundColor DarkGray -BackgroundColor $curitem.color -NoNewline
                } else {
                    write-host " " -ForegroundColor $preitem.color -BackgroundColor $curitem.color -NoNewline
                }
                write-host " $($curitem.symbol) $($curitem.name) $($curitem.total) " -BackgroundColor $curitem.color -nonewline
                if($($g+1) -eq $allstatus.length){
                    write-host " " -ForegroundColor $curitem.color -NoNewline
                }
            }
        } else {
            write-host " " -ForegroundColor DarkGray -NoNewline
        }
    } 
    write-host " "
    Return "PS> "
}