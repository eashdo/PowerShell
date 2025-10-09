#The purpose of this script to to answer the question "Are there any holds on these mailboxes?"
<#Adjust the list of mailboxes below as required. If the list is long, a CSV might make sense. In that case, use this:
  
    $csvPath = "C:\Path\To\mailboxes.csv
    $Mailboxes = Get-Content -Path $csvPath

#>
$Mailboxes = @(
    "Mailbox1@example.com",
    "Mailbox2@example.com",
    "Mailbox3@example.com"
)

# Clean tracking variables
$litigationHolds = @()
$retentionHolds = @()
$inPlaceHolds = @()

#Loop through and document mailboxes that do have holds
Foreach ($M in $Mailboxes){

    $Mailbox = Get-mailbox $M -ErrorAction SilentlyContinue
    if ($mailbox){
        #Check for Lit Hold
        if ($mailbox.LitigationHoldEnabled){
            $litigationHolds += $M
        }
        #Check for Retention Hold
        if ($mailbox.RetentionHoldEnabled){
            $retentionHolds += $M
        }
        #Check for In-Place (eDiscovery) Holds
        if ($mailbox.InPlaceHolds -gt 0){
            $inPlaceHolds += $M
        }
    
    }
    else {
        #Catch for mailboxes that are not proper in the list
        Write-Host "Mailbox not found: $M" -ForegroundColor Black -BackgroundColor Red
    }

}

# Output summary
Write-Host "`n$($litigationHolds.Count) mailboxes have Litigation Holds:`n$($litigationHolds -join ', ')"
Write-Host "`n$($retentionHolds.Count) mailboxes have Retention Holds:`n$($retentionHolds -join ', ')"
Write-host "Our Global Retention Policy does not appear in this report, all mailboxes have a global 7-year policy applied" -BackgroundColor yellow -ForegroundColor black
Write-Host "`n$($inPlaceHolds.Count) mailboxes have In-Place Holds:`n$($inPlaceHolds -join ', ')"
