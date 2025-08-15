# load .env
$envFile = ".env"
if (-Not (Test-Path $envFile)) {
    Write-Error "error: environment file $envFile not found."
    exit 1
}

Get-Content $envFile | ForEach-Object {
    if ($_ -match "^\s*#") { return } # skip comments
    if ($_ -match "^\s*$") { return } # skip empty lines
    $name, $value = $_ -split '=', 2
    Set-Item -Path "env:$name" -Value $value
}

if (-not $env:SWARM_MANAGER_ADDR -or -not $env:SWARM_WORKER_TOKEN) {
    Write-Error "error: missing SWARM_MANAGER_ADDR or SWARM_WORKER_TOKEN in .env"
    exit 1
}

# Join the swarm
docker swarm join --token $env:SWARM_WORKER_TOKEN "$($env:SWARM_MANAGER_ADDR):2377"