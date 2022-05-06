function Get-Input{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Data Entry Form'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'
    $form.ControlBox = $False
    $form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedToolWindow
    
    $okButton0 = New-Object System.Windows.Forms.Button
    $okButton0.Location = New-Object System.Drawing.Point(75,120)
    $okButton0.Size = New-Object System.Drawing.Size(75,23)
    $okButton0.Text = 'OK'
    $okButton0.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton0
    $form.Controls.Add($okButton0)
    
    $cancelButton0 = New-Object System.Windows.Forms.Button
    $cancelButton0.Location = New-Object System.Drawing.Point(150,120)
    $cancelButton0.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton0.Text = 'Cancel'
    $cancelButton0.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton0
    $form.Controls.Add($cancelButton0)
    
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Please enter alphanumeric characters only:'
    $form.Controls.Add($label)
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)
    
    $form.Topmost = $true
    
    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $x = $textBox.Text
        $x
    }
}

function Edit-List{

    param(
        [Parameter(Mandatory=$True)]
        [string[]]
        $inputList
    ,
        [string]
        $Title = "List Editor"
    )


[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$listLength = $inputList.Count
$initialList = @(1..$listLength)
$inputList.CopyTo($initialList,0)

$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = $Title
$objForm.Size = New-Object System.Drawing.Size(350,200)
$objForm.StartPosition = "CenterScreen"
#$objForm.Resize = $false
$objform.ControlBox = $False
$objform.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedDialog

$objForm.KeyPreview = $True
#$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
#    {}})
#$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
#    {}})


$objListBox = New-Object System.Windows.Forms.ListBox
$objListBox.Location = New-Object System.Drawing.Size(10,10)
$objListBox.Size = New-Object System.Drawing.Size(260,20)
$objListBox.Height = 110
$objListBox.Items.AddRange($inputList)

$objForm.Controls.Add($objListBox)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(20,130)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "Save"
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$objform.AcceptButton = $okButton
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(100,130)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$objform.CancelButton = $cancelButton
#$CancelButton.Add_Click({})
$objForm.Controls.Add($CancelButton)

$tooltip1 = New-Object System.Windows.Forms.ToolTip
$ShowHelp={
	switch ($this.Name) {
		"Add"  {$tip = "Add new grouping"}
		"Up" {$tip = "Move selected grouping up in the list"}
        "Down" {$tip = "Move selected grouping down in the list"}
        "Remove" {$tip = "Remove selected queue from the list"}
	}
	$tooltip1.SetToolTip($this,$tip)
}

$addAction = {
    [string]$temp = get-input
    $temp = $temp.Trim()
    if(($temp.Length -gt 0) -and ($temp -notmatch "[\s:]")){
        $objListBox.Items.Add($temp.ToUpper())
    }
}

$upAction = {
    $list = $objListBox.Items #for easy reference
    $selectedIndex = $objListBox.SelectedIndex
    $selectedItem = $objListBox.SelectedItem
    $ignore = $selectedIndex -eq -1

    $listLength = $list.Count
    $lastIndex = $listLength-1
    $tempList = @(1..$listLength)
    
    $exchangeIndex = $selectedIndex-1

    if(!$ignore){
        switch($exchangeIndex){
            -1{ #currently selected top option, moving up moves it to the bottom of the list
                #remove and add
                $objListBox.Items.RemoveAt($selectedIndex)
                $objListBox.Items.Add($selectedItem)
            }
            
            default{ #currently anywhere else in list, moving up.
                $exchangeItem = $list[$exchangeIndex]
                $tempList.clear()
                for($counter = 0; $counter -lt $listLength; $counter++){
                    switch($counter){
                        $selectedIndex{$tempList[$counter]=$exchangeItem}
                        $exchangeIndex{$tempList[$counter]=$selectedItem}
                        default{$tempList[$counter]=$list[$counter]}
                    }
                }
                $list.clear()
                $list.AddRange($tempList)
            }
        }
        if($exchangeIndex -eq -1){$exchangeIndex = $lastIndex}
        $objListBox.SetSelected($exchangeIndex,$true)
    }
}

$downAction = {
    $list = $objListBox.Items #for easy reference
    $selectedIndex = $objListBox.SelectedIndex
    $selectedItem = $objListBox.SelectedItem
    $ignore = $selectedIndex -eq -1

    $listLength = $list.Count
    $lastIndex = $listLength-1
    $tempList = @(1..$listLength)
    
    $exchangeIndex = $selectedIndex+1
    
    if(!$ignore){
        switch($exchangeIndex){
            $lastIndex{ #currently second to last, moving down to last
                #remove from where it is and add to the end
                $list.RemoveAt($selectedIndex)
                $list.Add($selectedItem)
                break
            }
    
            $listLength{ #currently last, moving down to wrap around to top of list
                #put at begining of list
                $list.RemoveAt($selectedIndex)
                $tempList[0] = ($selectedItem)
                $list.CopyTo($tempList,1)
                $list.Add("")
                $list.clear()
                $list.addrange($tempList)
            }
    
            default{ #currently anywhere else in list, moving down.
                #before, exchange, selected, after
                $exchangeItem = $list[$exchangeIndex]
                $tempList.clear()
                for($counter = 0; $counter -lt $listLength; $counter++){
                    switch($counter){
                        $selectedIndex{$tempList[$counter]=$exchangeItem}
                        $exchangeIndex{$tempList[$counter]=$selectedItem}
                        default{$tempList[$counter]=$list[$counter]}
                    }
                }
                $list.clear()
                $list.AddRange($tempList)
            
            }
        }
        if($exchangeIndex -gt $lastIndex){$exchangeIndex = 0}
        $objListBox.SetSelected($exchangeIndex,$true)
    }
    <#If selected index is the last in the list, moving down brings it to the top of the list#>
    
}

$removeAction = {
    if($objListBox.SelectedItem -ne $null){$objListBox.Items.RemoveAt($objListBox.SelectedIndex)}
}


<#
Side Buttons
$addButton
$upButton
$downButton
$removeButton
#>

$addButton = New-Object System.Windows.Forms.Button
$upButton = New-Object System.Windows.Forms.Button
$downButton = New-Object System.Windows.Forms.Button
$removeButton = New-Object System.Windows.Forms.Button

$addButton.Name = 'Add'
$upButton.Name = 'Up'
$downButton.Name = 'Down'
$removeButton.Name = 'Remove'

$addButton.Size = New-Object System.Drawing.Size(40,23)
$upButton.Size = New-Object System.Drawing.Size(40,23)
$downButton.Size = New-Object System.Drawing.Size(40,23)
$removeButton.Size = New-Object System.Drawing.Size(40,23)

$addButton.Location = New-Object System.Drawing.Size(280,10)
$upButton.Location = New-Object System.Drawing.Size(280,38)
$downButton.Location = New-Object System.Drawing.Size(280,66)
$removeButton.Location = New-Object System.Drawing.Size(280,94)

$addButton.Text = "+"
$upButton.Text = "↑"
$downButton.Text = "↓"
$removeButton.Text = "-"

$addButton.Add_Click($addAction)
$upButton.Add_Click($upAction)
$downButton.Add_Click($downAction)
$removeButton.Add_Click($removeAction)

$addButton.add_MouseHover($ShowHelp)
$upButton.add_MouseHover($ShowHelp)
$downButton.add_MouseHover($ShowHelp)
$removeButton.add_MouseHover($ShowHelp)

$objForm.Controls.Add($addButton)
$objForm.Controls.Add($upButton)
$objForm.Controls.Add($downButton)
$objForm.Controls.Add($removeButton)

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
$result = $objForm.ShowDialog()

if($result -eq [System.Windows.Forms.DialogResult]::OK){
    return $objListBox.Items
}else{
    return $initialList
}

}

$test = @("M1M0","M1M3","M1M5","M1M6")
Edit-List $test