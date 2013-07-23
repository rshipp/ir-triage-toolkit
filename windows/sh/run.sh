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
  echo -n "$(date +"%b %d %H:%M:%S") $(hostname) irscript: $1" | tee -a 
"$logfile"
}

# Start the log.
echo -n > "$logfile"
log "# Incident response volatile data collection script."
log "# Starting data collection..."

# 1. Acquire a full memory dump.
log "# Starting dc3dd to dump system memory..."
memfile="$saveto/memdump-$(hostname)-linux-$(uname -m)"
log "$bin/dc3dd if=/dev/mem hash=sha512 of='${memfile}.dd' log='${memfile}.log' 
hlog='${memfile}.sum'"
"$bin/dc3dd" if=/dev/mem hash=sha512 of="${memfile}.dd" \
             log="${memfile}.log" hlog="${memfile}.sum"
log "# dc3dd finished."

# 2. Collect network information.
log "# Collecting network information..."
log "netstat -ab > $saveto/network.txt 2>&1"
netstat -ab > "$saveto/network.txt" 2>&1
log "netstat -esr >> saveto/network.txt 2>&1"
netstat -esr >> "$saveto/network.txt" 2>&1
             
# 3. Collect information about opened files and running processes.
log "# Collecting information about opened files and running processes."


# 4. Collect user/system information.
log "# Collecting user/system information."


# 5. Collect device information.


# Create checksums for all files
log "# Creating checksums (sha512sum) for all files."
log "sha512sum $saveto/* > $saveto/sha512sums.txt"
sha512sum "$saveto/"* > "$saveto/sha512sums.txt"
log "sed 's/^.*sha512sums.txt.*$//; s/^.*log.txt.*$//' $saveto/sha512sums.txt"
sed 's/^.*sha512sums.txt.*$//; s/^.*log.txt.*$//' "$saveto/sha512sums.txt"

log "# All tasks completed. Exiting."
