##bash.exe
# Collect data.

# Fix the PATH so we can find our binaries.
PATH=./bin:$PATH

# Where should we store the data?
savedir=$1
[[ -n $savedir ]] || (
  echo -n "Directory to store data: "
  read savedir
  [[ -d $savedir ]] || mkdir "$savedir" || (
    echo "Not a valid directory."
    exit 1
    ) || exit 1
  ) || exit 1

 # Create directory structure.
saveto="$savedir/$(hostname)-$(date +%Y.%m.%d-%H.%M.%S)"
mkdir "$saveto"
logfile="$saveto/log.txt"

log() {
  echo -n "$(date +"%b %d %H:%M:%S") $(hostname) irscript: $1" | tee -a "$logfile"
}

# Start the log.
echo -n > "$logfile"
log "# Incident response volatile data collection script."
log "# Starting data collection..."

# 1. Acquire a full memory dump.
log "# Starting Mandiant Memoryze to dump system memory..."
memfile="$saveto/memdump-$(hostname)-windows.dd"
log "$bin/memoryze/MemoryDD.bat --output '$memfile'"
"$bin/memoryze/MemoryDD.bat" --output "$memfile" 
log "# Memoryze finished."

# 1.5. Grab the prefetch files, so we don't overwrite evidence.
log "# Copying Windows Prefetch files..."
log "cp -pr 'C:\Windows\Prefetch\' '$saveto/prefetch/'"
cp -pr 'C:\Windows\Prefetch\' "$saveto/prefetch/"

# 2. Collect network information.
log "# Collecting network information..."
log "netstat -ab > $saveto/network.txt 2>&1"
netstat -ab > "$saveto/network.txt" 2>&1
log "netstat -esr >> saveto/network.txt 2>&1"
netstat -esr >> "$saveto/network.txt" 2>&1
             
# 3. Collect information about opened files and running processes.
log "# Collecting information about opened files and running processes."
log "tasklist -V > '$saveto/tasklist.txt' 2>&1"
tasklist -V > "$saveto/tasklist.txt" 2>&1

# 4. Collect user/system information.
log "# Collecting user/system information."
log "whoami /all > '$saveto/users_whoami.txt' 2>&1"
whoami /all > "$saveto/users_whoami.txt" 2>&1

# 5. Collect device information.
log "# Collecting information about currently mounted devices."
log "diskpart /s '$bin/list.diskpart' > '$saveto/mounted_devices.txt' 2>&1"
diskpart /s "$bin/list.diskpart" > "$saveto/mounted_devices.txt" 2>&1

# Create checksums for all files
log "# Creating checksums (sha256sum) for all files."
log "sha256deep $saveto/* > $saveto/sha256sums.txt"
sha256deep "$saveto/"* > "$saveto/sha256sums.txt"
log "$bin/sed 's/^.*sha256sums.txt.*$//; s/^.*log.txt.*$//' $saveto/sha256sums.txt"
sed 's/^.*sha256sums.txt.*$//; s/^.*log.txt.*$//' "$saveto/sha256sums.txt"

log "# All tasks completed. Exiting."
