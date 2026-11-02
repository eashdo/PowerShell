<#
    This script is designed to locate users in the province of BC and migrate their calendar bookings from Pacific Standard Time to Pacific BC Time.
    We will also update their mailbox regional configuration and working hours timezone to British Columbia Standard Time in case the user has not updated their timezone yet.

    This script uses the new Invoke-CalendarEventMigration cmdlet which is still in v1 and only works for single instance meetings (as of writing, Nov 2).
#>

Connect-ExchangeOnline

$BCUsers = get-user -Filter "StateOrProvince -eq 'British Columbia' -and CountryOrRegion -eq 'Canada'" -RecipientTypeDetails UserMailbox -ResultSize Unlimited | Select-object DisplayName,WindowsLiveID

Foreach ($User in $BCUsers) {

    #Update the user's timezone to British Columbia Standard Time
    Write-Host "Updating timezone for user: $($User.DisplayName)"
    Set-MailboxRegionalConfiguration -Identity $User.WindowsLiveID -TimeZone "British Columbia Standard Time" -Confirm:$false
    
    #Update the user's working hours time zone to British Columbia Standard Time
    Write-Host "Updating working hours timezone for user: $($User.DisplayName)"
    Set-MailboxCalendarConfiguration -Identity $User.WindowsLiveID -WorkingHoursTimeZone "British Columbia Standard Time" -Confirm:$false
    
    #Update the calendar events for the user from Pacific Standard Time to British Columbia Standard Time
    Write-Host "Migrating calendar events for user: $($User.DisplayName)"
    Invoke-CalendarEventMigration -Identity $User.WindowsLiveID -SourceTimeZone "Pacific Standard Time" -DestinationTimeZone "British Columbia Standard Time" -QueryStartDate 2026-11-01 -QueryWindowInDays 365 -Confirm:$false
}

