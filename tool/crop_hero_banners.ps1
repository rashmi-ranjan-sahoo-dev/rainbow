Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\rinku\.gemini\antigravity-ide\brain\edbd5780-00a6-4229-8551-56b9d18485aa\.user_uploaded\media_1788335107527.jpg"
$destDir = "C:\Users\rinku\OneDrive\Desktop\flutter_projects\rainbow\assets\images"
$buildDestDir = "C:\Users\rinku\OneDrive\Desktop\flutter_projects\rainbow\build\web\assets\assets\images"

$srcImage = [System.Drawing.Bitmap]::FromFile($srcPath)
$totalW = $srcImage.Width
$totalH = $srcImage.Height

# Banner coordinates (trimming outer frames/borders if any)
$slices = @(
    @{ Top = 0; Height = 142 },
    @{ Top = 144; Height = 142 },
    @{ Top = 288; Height = 142 },
    @{ Top = 432; Height = 142 }
)

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 98)

for ($i = 0; $i -lt 4; $i++) {
    $slideNum = $i + 1
    $top = $slices[$i].Top
    $h = $slices[$i].Height
    
    $cropRect = New-Object System.Drawing.Rectangle(0, $top, $totalW, $h)
    $cropped = New-Object System.Drawing.Bitmap($totalW, $h)
    $graphics = [System.Drawing.Graphics]::FromImage($cropped)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.DrawImage($srcImage, (New-Object System.Drawing.Rectangle(0, 0, $totalW, $h)), $cropRect, [System.Drawing.GraphicsUnit]::Pixel)
    
    $outPath = Join-Path $destDir "hero_slide_$slideNum.jpg"
    $cropped.Save($outPath, $codec, $encoderParams)
    
    if (Test-Path $buildDestDir) {
        $buildOutPath = Join-Path $buildDestDir "hero_slide_$slideNum.jpg"
        $cropped.Save($buildOutPath, $codec, $encoderParams)
    }
    
    $graphics.Dispose()
    $cropped.Dispose()
    
    Write-Host "Exported hero_slide_$slideNum.jpg ($totalW x $h)"
}

$srcImage.Dispose()
Write-Host "All 4 hero slides cleanly extracted and synchronized!"
