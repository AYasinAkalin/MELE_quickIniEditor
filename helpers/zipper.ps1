$compress = @{
    Path = ".\Temp\z\*"
    DestinationPath = $ENV:_path_zipFile
    CompressionLevel = "Fastest"
}
Compress-Archive @compress -Force