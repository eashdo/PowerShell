<#This was created for the purpose of setting up the LogiTech Sync service
    This service requires full access to every room mailbox
    Every room should be part of a room list, filtering for the specific pattern we use
#>

Connect-ExchangeOnline

$RLs = get-DistributionGroup -RecipientTypeDetails RoomList | ? {$_.displayname -like "* - *"}

Foreach ($R in $RLs){

    $Rooms = Get-DistributionGroupMember $R.Name

    Foreach ($RM in $Rooms){

        Add-MailboxPermission -Identity $RM.Name -User "USER-UPN" -AccessRights FullAccess -InheritanceType All -AutoMapping $false

    }

}