$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/supabase/cli/releases/latest' -UseBasicParsing
$asset = $release.assets | Where-Object { $_.name -match 'windows' -and ($_.name -match 'amd64' -or $_.name -match 'x64' -or $_.name -match 'x86_64') } | Select-Object -First 1
if (-not $asset) { Write-Error 'No Windows asset found'; exit 1 }
$toolsDir = 'C:\Users\Administrator\UniQuest\tools'
$out = Join-Path $toolsDir 'supabase.zip'
New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
Write-Output "Downloading $($asset.name) to $out"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $out
Write-Output 'Expanding archive'
$dest = Join-Path $toolsDir 'supabase'
New-Item -ItemType Directory -Path $dest -Force | Out-Null
if ($asset.name -match '\.zip$') {
	Expand-Archive -Path $out -DestinationPath $dest -Force
} elseif ($asset.name -match '\.tar\.gz$' -or $asset.name -match '\.tgz$') {
	# Use tar if available
	if (Get-Command tar -ErrorAction SilentlyContinue) {
		# Run tar with working directory to avoid Windows path issues
		Start-Process -FilePath tar -ArgumentList ('-xzf', (Convert-Path $out)) -NoNewWindow -Wait -WorkingDirectory (Convert-Path $dest)
	} else {
		Write-Error 'tar not available to extract .tar.gz archive'
		exit 1
	}
} else {
	Write-Error "Unknown archive format: $($asset.name)"
	exit 1
}
Remove-Item $out
$exe = Get-ChildItem -Path (Join-Path $toolsDir 'supabase') -Filter 'supabase.exe' -Recurse | Select-Object -First 1
if (-not $exe) { Write-Error 'supabase.exe not found after extraction'; exit 1 }
Write-Output "Supabase CLI placed at: $($exe.FullName)"
& $exe.FullName --version
