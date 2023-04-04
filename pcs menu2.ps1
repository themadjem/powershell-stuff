Add-Type -AssemblyName System.Windows.Forms


Function Write-Pane{
    param([string[]]$text,[Switch]$NoNewLine=$false)
    if($NoNewLine){
        $text.foreach({$textPane.AppendText("$_")})
    }else{
        $text.foreach({$textPane.AppendText("$_`n")})
    }
}

function Write-ColorText {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string[]]$InputObject,
        [System.Windows.Forms.RichTextBox]$TextBox = $textPane,
        [System.Drawing.Color]$ForegroundColor = 'White',
        [System.Drawing.Color]$BackgroundColor = 'Black',
        [switch]$NoNewLine
    )
    
    begin {
        #$TextBox.Clear()
    }
    
    process {
        $formattedText = $InputObject -join ' '
        $TextBox.SelectionStart = $TextBox.TextLength
        $TextBox.SelectionLength = 0
        $TextBox.SelectionColor = $ForegroundColor
        $TextBox.SelectionBackColor = $BackgroundColor
        $TextBox.AppendText($formattedText)
        if(!$NoNewLine) {
            $TextBox.AppendText("`r`n")
        }
        $TextBox.SelectionColor = $TextBox.ForeColor
        $TextBox.SelectionBackColor = $TextBox.BackColor
    }
    
    end {
        $TextBox.ScrollToCaret()
    }
}

Function Show-Form{
# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "My GUI"
$form.Width = 650
$form.Height = 450


$groupBox1 = New-Object System.Windows.Forms.GroupBox
$groupBox1.Location = New-Object System.Drawing.Point(0,0)
$groupBox1.Size = New-Object System.Drawing.Size(600,400)
$form.Controls.Add($groupBox1)

# Create the text pane
$textPane = New-Object System.Windows.Forms.RichTextBox
$textPane.Location = New-Object System.Drawing.Point(150, 10)
$textPane.Size = New-Object System.Drawing.Size(420, 380)
$textPane.ReadOnly = $true
$textPane.ScrollBars = "Vertical"
$textPane.BackColor = "Black"
$textPane.ForeColor = "White"
$textPane.Font = New-Object System.Drawing.Font("Lucida Console", 16, [System.Drawing.FontStyle]::Regular)


$groupBox1.Controls.Add($textPane)

# Define button size and spacing
$buttonWidth = 75
$buttonHeight = 30
$spacing = 40

# Define button click events
$handler = {
    $buttonText = $this.Text
    $buttons.Hide()
    if($buttonText -ieq "button 8"){
        for($i=0;$i -lt 50;$i++){Write-ColorText2 "$buttonText was clicked." -ForegroundColor Red;sleep -Milliseconds 10}
    }else{
        for($i=0;$i -lt 50;$i++){Write-ColorText2 "$buttonText was clicked.";sleep -Milliseconds 10}}
    $buttons.Show()
}


# Instantiate buttons

$labels = @("Today's Production", "Production Date", "Request Date",)

$buttons = 1..9 | ForEach-Object {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Button $_"
    $button.Location = New-Object System.Drawing.Point(10, (10 + $($_-1)*$spacing))
    $button.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)
    $button.add_Click($handler)
    $button
}


# Add buttons to group box
$groupBox1.Controls.AddRange($buttons)

$form.ShowDialog()
$textPane.SaveFile("U:\file.rtf", 'RichText')

}

Test-MainMenuOption([String]$option){
    Switch($option){
        
        'Button 1'
        default{Write-ColorText "Option: $option"}
    
    }   

}






Show-Form