$PublicFolderServer="ExchangeServerHostName"

$resultsarray=@()
$PublicFolders=Get-PublicFolder -Server $PublicFolderServer -Recurse

ForEach($PublicFolder in $PublicFolders)
{
$PFObject = new-object PSObject

$PFData=Get-PublicFolderStatistics -Server $PublicFolderServer -Identity $PublicFolder

$PFObject | add-member -membertype NoteProperty -name "PFName" -Value $PublicFolder.Identity
$PFObject | add-member -membertype NoteProperty -name "CreatedDate" -Value $PFData.CreationTime
$PFObject | add-member -membertype NoteProperty -name "LastUserAccess" -Value $PFData.LastUserAccessTime
$PFObject | add-member -membertype NoteProperty -name "LastUserModification" -Value $PFData.LastUserModificationTime
$PFObject | add-member -membertype NoteProperty -name "MailEnabled" -Value $PublicFolder.MailEnabled
$PFObject | add-member -membertype NoteProperty -name "ItemCount" -Value $PFData.ItemCount
$PFObject | add-member -membertype NoteProperty -name "TotalItemSize(MB)" -Value $PFData.TotalItemSize.value.toMB()

$resultsarray += $PFObject
}

$resultsarray | Export-csv PublicFolderReport.csv