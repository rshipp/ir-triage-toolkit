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

 