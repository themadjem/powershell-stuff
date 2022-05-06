function Select-ItemFromList
{

    param(
        [Parameter(Mandatory = $True)]
        [string[]]
        $inputList
    ,
        [switch]
        $ReturnIndex
    ,
        [string]
        $Title = "Select an Item"
    ,
        [string]
        $Message = "Please select an item below"
    )

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $objForm = New-Object System.Windows.Forms.Form
    $objForm.Text = $Title
    $objForm.Size = New-Object System.Drawing.Size(300, 200)
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    #$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
    #    {$x=$objListBox.SelectedItem;$objForm.Close()}})
    #$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
    #    {$objForm.Close()}})

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10, 20)
    $objLabel.Size = New-Object System.Drawing.Size(280, 20)
    $objLabel.Text = $Message
    $objForm.Controls.Add($objLabel)

    $objListBox = New-Object System.Windows.Forms.ListBox
    $objListBox.Location = New-Object System.Drawing.Size(10, 40)
    $objListBox.Size = New-Object System.Drawing.Size(260, 20)
    $objListBox.Height = 80

    [void] $objListBox.Items.AddRange($inputList)

    $objForm.Controls.Add($objListBox)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75, 120)
    $OKButton.Size = New-Object System.Drawing.Size(75, 23)
    $OKButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150, 120)
    $CancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $CancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    #$CancelButton.Add_Click({})
    $objForm.Controls.Add($CancelButton)





    $objForm.Topmost = $True

    $objForm.Add_Shown({ $objForm.Activate() })
    $result = $objForm.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $x = if ($ReturnIndex)
        {
            $objListBox.SelectedIndex
        }
        else
        {
            $objListBox.SelectedItem
        }
    }
    else
    {
        $x = $null
    }
    return $x

}