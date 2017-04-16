#!/bin/bash

load "$(pwd)"/test_helper/helper.bash

first_vault="myfirstveravault"
second_vault="mysecondveravault"
volume_folder="$HOME/tmp"
mount_folder="$HOME/mount_vera"
extension=".vault"
password=$(cat /dev/urandom | base64 | tr -dc "A-Za-z0-9_" | head -c25)
pim="50"
random320=$(cat /dev/urandom | base64 | tr -dc "A-Za-z0-9_" | head -c320)

function setup() {
  my crypt install veracrypt >/dev/null 2>&1 || true
  [ ! -d "$volume_folder" ] || rm -rf "$volume_folder"
  veracrypt -d
  if [ -d "$mount_folder" ]; then
    sudo rm -rf "$mount_folder"
  fi
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
}

function teardown() {
  [ ! -d "$volume_folder" ] || rm -rf "$volume_folder"
  veracrypt -d
  if [ -d "$mount_folder" ]; then
    sudo rm -rf "$mount_folder"
  fi
  [ ! -f ~/.myconfig ] || rm ~/.myconfig
}

function create_new {
  printf "veracrypt\n${volume_folder}\n${password}\n${password}\n${pim}\n${random320}\n" | run my crypt create "$1"
}

function open_new {
  printf "${mount_folder}\n${password}\n${pim}" | my crypt open "$1"
}

function assert_vault_file {
  assert [ -f "${volume_folder}/$1${extension}" ]
}

function assert_mounted {
  assert_vault_file "$1"
  assert [ -d "$mount_folder/$1" ]
}

@test "crypt(veracrypt) - create new vault" {
  create_new "$first_vault" && assert_success
  assert_vault_file "$first_vault"
}

@test "crypt(veracrypt) - try to create existent volume" {
  create_new "$first_vault" && assert_success
  run my crypt create "$first_vault" && assert_failure
  assert_output "Volume $first_vault already exist."
}

@test "crypt(veracrypt) - create two vaults in same folder" {
  create_new "$first_vault" && assert_success
  create_new "$second_vault" && assert_success
}

@test "crypt(veracrypt) - create two vaults in different folders" {
  other_folder="$HOME/tmp2"
  create_new "$first_vault" && assert_success
  printf "veracrypt\n${other_folder}\n${password}\n${password}\n${pim}\n${random320}\n" | run my crypt create "$second_vault"
  assert_success
  rm -rf $other_folder
}

@test "crypt(veracrypt) - create vault without name" {
  printf "newveraname\nveracrypt\n${volume_folder}\n${password}\n${password}\n${pim}\n${random320}\n" | run my crypt create
  assert_success
  assert [ -f "$volume_folder/newveraname${extension}" ]
}

@test "crypt(veracrypt) - create and open vault without passing name" {
  vault_name="newveraname"
  printf "${vault_name}\nveracrypt\n${volume_folder}\n${password}\n${password}\n${pim}\n${random320}\n" | run my crypt create
  open_new "${vault_name}"
  assert_success
  assert_mounted "${vault_name}"
}

@test "crypt(veracrypt) - open not created vault" {
  run my crypt open "$first_vault" && assert_failure
  assert_output "Any volume configuration for ${first_vault} is wrong. Please recreate it."
}

@test "crypt(veracrypt) - try to open without a named vault" {
  run my crypt open && assert_failure
  assert_output "No volume name passed."
}

@test "crypt(veracrypt) - open vault without mount folder argument" {
  create_new "$first_vault"
  open_new "$first_vault"
  assert_success
  assert_mounted "$first_vault"
}

@test "crypt(veracrypt) - open vault with mount folder argument" {
  create_new "$first_vault"
  printf "${password}\n${pim}\n" | run my crypt open "$first_vault" "$mount_folder"
  assert_success
  assert_mounted "$first_vault"
}

@test "crypt(veracrypt) - reopen a mounted vault" {
  create_new "$first_vault"
  open_new "$first_vault"
  assert_mounted "$first_vault"
  run my crypt open "$first_vault" && assert_failure
  assert_output "$first_vault is already mounted."
  # confirm everything continue existing.
  assert_mounted "$first_vault"
}

@test "crypt(veracrypt) - open using default configuration" {
  printf "veracrypt\n\n${password}\n${password}\n${pim}\n${random320}\n" | my crypt create "$first_vault"
  printf "\n${password}\n${pim}\n" | run my crypt open "$first_vault"
  assert_success
  assert [ -f ~/.myvaults/"${first_vault}${extension}" ]
  assert [ -d ~/myvaults/$first_vault ]
}

@test "crypt(veracrypt) - mount two different vaults in same folder" {
  create_new "$first_vault"
  open_new "$first_vault"
  create_new "$second_vault"
  open_new "$second_vault"
  assert_success
  assert_mounted "$first_vault"
  assert_mounted "$second_vault"
}

@test "crypt(encfs) - mount different vaults in different folders" {
  create_new "$first_vault"
  open_new "$first_vault"
  printf "veracrypt\n\n${password}\n${password}\n${pim}\n${random320}\n" | my crypt create "$second_vault"
  printf "\n${password}\n${pim}\n" | run my crypt open "$second_vault"
  assert_success
  assert_mounted "$first_vault"
  assert [ -f ~/.myvaults/${second_vault}${extension} ]
  assert [ -d ~/myvaults/$second_vault ]
}

@test "crypt(veracrypt) - close vault without argument" {
  run my crypt close && assert_failure
  assert_output "No volume name passed."
}

@test "crypt(veracrypt) - close not existent vault" {
  run my crypt close not_a_vault && assert_failure
  assert_output "Any volume configuration is wrong. Please recreate it."
}

@test "crypt(encfs) - close vault" {
  create_new "$first_vault"
  open_new "$first_vault"
  run my crypt close "$first_vault" && assert_success
  assert [ -f "${volume_folder}/${first_vault}${extension}" ]
  assert [ -d "${mount_folder}/${first_vault}" ]
}

@test "crypt(encfs) - try to close an already closed vault" {
  create_new "$first_vault"
  open_new "$first_vault"
  my crypt close "$first_vault"
  run my crypt close "$first_vault" && assert_failure
  assert_output "$first_vault is already closed."
}

@test "crypt(encfs) - full test" {
  create_new "$first_vault"
  open_new "$first_vault"
  #create file in mounted location
  touch "${mount_folder}/$first_vault/test_file"
  echo "my first content" >> "${mount_folder}/$first_vault/test_file"
  # check if file exists
  assert [ -f "${mount_folder}/$first_vault/test_file" ]
  my crypt close "$first_vault"
  #after close check if file is gone.
  assert [ ! -f "${mount_folder}/$first_vault/test_file" ]
  #mount volume again
  printf "${password}\n${pim}" | my crypt open "$first_vault"
  assert_success
  #check if file exists and has the previous content
  assert [ -f "${mount_folder}/$first_vault/test_file" ]
  run cat "${mount_folder}/$first_vault/test_file"
  assert_output "my first content"
}
