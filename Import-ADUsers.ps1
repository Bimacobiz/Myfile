# Define the path to the CSV file in the user's Downloads folder
$csvPath = "$env:USERPROFILE\Downloads\Modified_UserAccounts.csv"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user and create the AD account
foreach ($user in $users) {
    $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force

    New-ADUser `
        -Name $user.DisplayName `
        -GivenName $user.FirstName `
        -Surname $user.LastName `
        -SamAccountName $user.Username `
        -UserPrincipalName "$($user.Username)@yourdomain.local" `
        -AccountPassword $securePassword `
        -Enabled $true `
        -DisplayName $user.DisplayName `
        -Path "OU=$($user.OU),DC=yourdomain,DC=local"

    # Add user to the group
    Add-ADGroupMember -Identity $user.Group -Members $user.Username
}
