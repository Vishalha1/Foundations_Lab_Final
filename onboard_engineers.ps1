Import-Module ActiveDirectory

$OUPath = "OU=Engineering,DC=Titian,DC=local"
$DefaultPassword = ConvertTo-SecureString "testingha1@" -AsPlainText -Force

for ($i = 1; $i -le 5; $i++) {
    $Username = "Eng_User$i"

    New-ADUser -Name $Username `
        -SamAccountName $Username `
        -AccountPassword $DefaultPassword `
        -Enabled $true `
        -Path $OUPath `
        -ChangePasswordAtLogon $true
}
