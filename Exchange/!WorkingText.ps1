#A Place to work on short one-liners without having to use the console
#Do not sync this one

Start-Transcript -Path "C:\users\Evan\Downloads\FINSA_Contacts_Male.txt" -NoClobber
Connect-ExchangeOnline

$RoomLists = Import-Csv .\RoomLists.csv
$Rooms = @()
Foreach ($RoomList in $RoomLists){

    $Rooms += Get-DistributionGroupMember $RoomList.Alias | Get-User | Select-Object WindowsEmailAddress,DisplayName,City,PostalCode,IsDirSynced
}

$Changes = Import-Csv .\AllRooms.csv

Foreach ($Change in $Changes){

    Set-Mailbox $Change.WindowsEmailAddress -DisplayName $Change.NewName
    #Get-Mailbox $Change.WindowsEmailAddress | Select DisplayName
}

$users = import-csv '.\Copy of MailboxType.csv'

$csvfilename = ".\SharedMailboxReport_$((Get-Date -format dd-MM-yy).ToString()).csv"
New-Item $csvfilename -type file -force
Add-Content $csvfilename "UPN,Name,Status"
Foreach ($User in $Users){
    $UPN = $user.UPN
    Try {
        $Mailbox = Get-mailbox $UPN -ErrorAction stop,SilentlyContinue | Select-Object Name,RecipientTypeDetails
        $Name = $Mailbox.Name
        $Status = $Mailbox.RecipientTypeDetails
    }
    Catch{
        $Name = $User.UPN
        $Status= "no mailbox"
    }
    Add-Content $csvfilename "$UPN,$Name,$Status"
}

$mailboxes = Import-Csv .\Book1.csv
Foreach ($M in $Mailboxes){

    Get-Recipient $M.UPN
}


