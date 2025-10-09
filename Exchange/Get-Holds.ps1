#The purpose of this script to to answer the question "Are there any holds on these mailboxes?"

Connect-ExchangeOnline

$Mailboxes = @(
    "mailbox1@example.com",
    "mailbox2@example.com",
    "mailbox3@example.com"
)

# Clean tracking variables
$litigationHolds = @()
$retentionHolds = @()
$inPlaceHolds = @()

#Loop through and document mailboxes that do have holds
Foreach ($M in $Mailboxes){

    $Mailbox = Get-mailbox $M -ErrorAction SilentlyContinue
    if ($mailbx){
        #Check for Lit Hold
        if ($mailbox.LitigationHoldEnabled){
            $litigationHolds += $M
        }
        if ($mailbox.RetentionHoldEnabled){
            $retentionHolds += $M
        }
        if ($mailbox.InPlaceHolds -gt 0){
            $inPlaceHolds += $M
        }
    
    }
    else {
        Write-Host "Mailbox not found: $M" -ForegroundColor Black -BackgroundColor Red
    }

}

# Output summary
Write-Host "`n$($litigationHolds.Count) mailboxes have Litigation Holds:`n$($litigationHolds -join ', ')"
Write-Host "`n$($retentionHolds.Count) mailboxes have Retention Holds:`n$($retentionHolds -join ', ')"
Write-Host "`n$($inPlaceHolds.Count) mailboxes have In-Place Holds:`n$($inPlaceHolds -join ', ')"
