Connect-exchangeonline

<#The purpose of this script is to locate users with specific criteria who do not have Archive, Auto-Expanding Archive, or a proper MRM Policy assigned
and enable/apply those items. Adjust the filters as needed to match the conditions we are trying to target.
#>

#We cannot filter based on Archives/Policy anymore, thanks Microsoft for breaking that... 
#We can filter by country, no need to store the entire user base.
$Users = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited -Filter 'UsageLocation -eq "Bolivia" -or UsageLocation -eq "Uruguay"'

$NoArchives = $Users | Where-Object {$_.ArchiveStatus -ne "Active"}
Write-Host "There are currently" $NoArchives.count "user mailboxes in this batch with no archives."
Write-Host "Correcting this issue..."

Foreach ($N in $NoArchives){

    Enable-Mailbox $N.WindowsLiveID -Archive | Out-Null
}


$NoAutoExpanding =  $Users | Where-Object {$_.AutoExpandingArchiveEnabled -like "False"}
Write-Host "There are currently" $NoAutoExpanding.count "user mailboxes in this batch without auto-expanding archives."
Write-Host "Correcting this issue..."

Foreach ($NA in $NoAutoExpanding){

    Enable-Mailbox $NA.WindowsLiveID -AutoExpandingArchive | Out-Null
}

$NoMRMPolicy = $Users | Where-Object {$_.RetentionPolicy -eq "Default MRM Policy"}
Write-Host "There are currently" $NoMRMPolicy.count "user mailboxes in this batch without a proper MRM Policy."
Write-Host "Applying our 1-year policy to these mailboxes..."

Foreach ($NM in $NoMRMPolicy){

    Set-Mailbox $NM.WindowsLiveID -RetentionPolicy "Global Policy (recoverable+1yr msgs to archive)"
}

Write-host "All actions have been completed. Here is a summary:"
Write-host $NoArchives.count "mailboxes had their archives enabled." (($NoArchives.count/$Users.count)*100)"%"
Write-host $NoAutoExpanding.count "mailboxes had the auto-expanding archive enabled." (($NoAutoExpanding.count/$Users.count)*100)"%"
Write-host $NoMRMPolicy.count "mailboxes had the 1-year auto-archiving policy assigned." (($NoMRMPolicy.count/$Users.count)*100)"%"