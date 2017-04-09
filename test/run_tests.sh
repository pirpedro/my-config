#/bin/bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1

run_test(){
  vagrant ssh -c "cd /usr/local/my-config/test; bats $2" "$1"
}

files=${1:-$(ls -p . | grep -v / | grep .bats | grep -v *install_* )}

run_install_arr=()

for i in ubuntu; do
  vagrant up "$i"
  for file in $files; do
    if [ -e "install_$file" ]; then
      run_install_arr+=("install_$file")
    fi
    run_test "$i" "$file"
    if [[ -d "$i" && -e "$i/$file" ]]; then
      run_test "$i" "$i/$file"
    fi
  done

  vagrant destroy "$i"; vagrant up "$i"
  for file in "${run_install_arr[@]}"; do
    run_test "$i" "$file"
  done
done
