#Add this script as a scheduled task on a server with the Exchange management shell installed. I ran this every half hour. 
#An out of band email, using a gmail account, will be sent if any mailbox copy has a status other then Healthy or Mounted. 

#change the next line if you are using a newer version of Exchange
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010
$CopyStatus=Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus | Where-Object {(($_.Status -ne "Healthy") -and ($_.Status -ne "Mounted"))}

IF ($CopyStatus -eq $NULL)
{
Write-Host "All copies healthy"
}
Else
{

$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<title>
Title of my Report
</title>
"@
$Body = $CopyStatus|Select Name,Status,CopyQueueLength | ConvertTo-HTML -Head $Header

#change the next two variables with your gmail address and application password
$GmailAddress="user@gmail.com"
$GmailAppPassword="appPassword"

$EmailTo = $GmailAddress
$EmailFrom = $GmailAddress
$Subject = "Exchange Database Copy Status" 

$SMTPServer = "smtp.gmail.com" 
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPMessage.IsBodyHTML = $true
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($GmailAddress,$GmailAppPassword); 
$SMTPClient.Send($SMTPMessage)


}