#Create BASE64 tag of selected image
#Script by ditiswat.stijnziet.nl
#Idea by RooieDokus.nl
#28-3-24

# Load Windows Forms and drawing assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create and configure OpenFileDialog
$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.filter = "Image files (*.jpeg;*.jpg;*.png)|*.jpeg;*.jpg;*.png"
$openFileDialog.Title = "Select an Image"

# Show the OpenFileDialog
$result = $openFileDialog.ShowDialog()

# Proceed if a file was selected
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $imagePath = $openFileDialog.FileName
    
    # Load the image
    $image = [System.Drawing.Image]::FromFile($imagePath)
    
    # Convert to base64
    $imageStream = New-Object System.IO.MemoryStream
    $image.Save($imageStream, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $base64 = [Convert]::ToBase64String($imageStream.ToArray())
    
    # Generate HTML img tag
    $htmlImgTag = "<img src=`"data:image/jpeg;base64,$base64`">"
    
    # Determine path for the HTML file
    $htmlFilePath = [System.IO.Path]::ChangeExtension($imagePath, 'html')
    
    # Write HTML content to file
    $htmlImgTag | Out-File -FilePath $htmlFilePath
    
    Write-Host "---HTML below--"
    Write-Output $htmlImgTag

    Write-Output "---HTML file has been saved to: $htmlFilePath ---"
    # Optionally, you can open the generated HTML file in your default web browser:
    # Start-Process $htmlFilePath
}
