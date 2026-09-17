Connect-ExchangeOnline

$Mailboxes = import-csv '.\downloads\HALO - Enabled Shared Mailboxes - 18.8.2026.csv'

Foreach ($M in $Mailboxes){

    try {
        
        Get-Mailbox -SoftDeletedMailbox $M.userprincipalname -ErrorAction Stop,SilentlyContinue | Out-Null
        Undo-SoftDeletedMailbox $M.UserPrincipalName
    }

    Catch {
        Write-Host "Cannot find" $M.userprincipalname -ForegroundColor Red -BackgroundColor Yellow
    }


}