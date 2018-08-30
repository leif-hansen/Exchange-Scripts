#This Report returns info for all mailboxes and archive mailboxes. 

$resultsarray =@()
$Mailboxes=Get-Mailbox -ResultSize Unlimited

ForEach($Mailbox in $Mailboxes)

{
$MailboxObject = new-object PSObject


$ADdata=Get-Mailbox $Mailbox

$MailboxObject | add-member -membertype NoteProperty -name "UserName" -Value $ADdata.SamAccountName
$MailboxObject | add-member -membertype NoteProperty -name "DisplayName" -Value $ADdata.DisplayName
$MailboxObject | add-member -membertype NoteProperty -name "EmailAddress" -Value $ADdata.PrimarySMTPAddress
$MailboxObject | add-member -membertype NoteProperty -name "OrganizationalUnit" -Value $ADdata.OrganizationalUnit
$MailboxObject | add-member -membertype NoteProperty -name "Office" -Value $ADdata.Office
$MailboxObject | add-member -membertype NoteProperty -name "LitigationHoldEnabled" -Value $ADdata.LitigationHoldEnabled
$MailboxObject | add-member -membertype NoteProperty -name "Database" -Value $ADdata.Database
$MailboxObject | add-member -membertype NoteProperty -name "DateCreated" -Value $ADdata.WhenCreated
$MailboxObject | add-member -membertype NoteProperty -name "DateChanged" -Value $ADdata.WhenChanged
$MailboxObject | add-member -membertype NoteProperty -name "ArchiveDatabase" -Value $ADdata.ArchiveDatabase


$StatData=Get-MailboxStatistics $Mailbox

$MailboxObject | add-member -membertype NoteProperty -name "ItemCount" -Value $StatData.ItemCount
$MailboxObject | add-member -membertype NoteProperty -name "TotalMailboxSizeMB" -Value $StatData.TotalItemSize.value.toMB()
$MailboxObject | add-member -membertype NoteProperty -name "TotalDeletedItemSizeMB" -Value $StatData.TotalDeletedItemSize.value.toMB()
$MailboxObject | add-member -membertype NoteProperty -name "LastLogonTime" -Value $StatData.LastLogonTime
$MailboxObject | add-member -membertype NoteProperty -name "LastLoggedOnUserAccount" -Value $StatData.LastLoggedOnUserAccount


$StatArchiveData=Get-MailboxStatistics $Mailbox -Archive

$MailboxObject | add-member -membertype NoteProperty -name "ArchiveItemCount" -Value $StatArchiveData.ItemCount
$MailboxObject | add-member -membertype NoteProperty -name "TotalArchiveMailboxSizeMB" -Value $StatArchiveData.TotalItemSize.value.toMB()
$MailboxObject | add-member -membertype NoteProperty -name "TotalArchiveDeletedItemSizeMB" -Value $StatArchiveData.TotalDeletedItemSize.value.toMB()

$resultsarray += $MailboxObject

}

$resultsarray | Sort-Object ArchiveDatabase –Descending | Export-csv Mailbox-ArchiveReport.csv
