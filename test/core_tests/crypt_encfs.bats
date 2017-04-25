#!/bin/bash

load "$(pwd)"/test_helper/helper.bash

first_vault="myfirstvault"
second_vault="mysecondvault"
volume_folder="$HOME/tmp"
mount_folder="$HOME/mount_encfs"
password="password"

function setup() {
  my crypt install encfs >/dev/null 2>&1 || true
  [ ! -d "$volume_folder" ] || rm -rf "$volume_folder"
  if [ -d "$mount_folder" ]; then
    if mount | grep "$mount_folder/$first_vault" > /dev/null; then
      fusermount -u "$mount_folder/$first_vault"
    fi
    if mount | grep "$mount_folder/$second_vault" > /dev/null; then
      fusermount -u "$mount_folder/$second_vault"
    fi
    rm -rf "$mount_folder"
  fi
  [ ! -d ~/.myconfig ] || rm -rf ~/.myconfig
}

function teardown() {
  [ ! -d "$volume_folder" ] || rm -rf "$volume_folder"
  if [ -d "$mount_folder" ]; then
    if mount | grep "$mount_folder/$first_vault" > /dev/null; then
      fusermount -u "$mount_folder/$first_vault"
    fi
    if mount | grep "$mount_folder/$second_vault" > /dev/null; then
      fusermount -u "$mount_folder/$second_vault"
    fi
    rm -rf "$mount_folder"
  fi
  [ ! -d ~/.myconfig ] || rm -rf ~/.myconfig
}

@test "crypt(encfs) - create new vault" {
  printf "encfs\n${volume_folder}\n" | run my crypt create "$first_vault"
  assert_success
}

@test "crypt(encfs) - try to create existent volume" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  run my crypt create "$first_vault"
  assert_failure
  assert_output "Volume $first_vault already exist."
}

@test "crypt(encfs) - create two vaults in same folder" {
  printf "encfs\n${volume_folder}\n" | run my crypt create "$first_vault"
  printf "encfs\n${volume_folder}\n" | run my crypt create "$second_vault"
  assert_success
}

@test "crypt(encfs) - create two vaults in different folders" {
  printf "encfs\n${volume_folder}\n" | run my crypt create "$first_vault"
  printf "encfs\n~\n" | run my crypt create "$second_vault"
  assert_success
}

@test "crypt(encfs) - create vault without name" {
  run printf "newname\nencfs\n${volume_folder}\n" | run my crypt create
  assert_success
}

@test "crypt(encfs) - create and open vault without passing name" {
  vault_name="newname"
  printf "${vault_name}\nencfs\n${volume_folder}\n" | run my crypt create
  printf "${mount_folder}\ny\n${password}\n" | run my crypt open "${vault_name}" -s
  assert_success
  assert [ -d "${volume_folder}/$vault_name" ]
  assert [ -d "${mount_folder}/$vault_name" ]
  run my crypt close "$vault_name" && assert_success
}

@test "crypt(encfs) - open not created vault" {
  run my crypt open "$first_vault" && assert_failure
  assert_output "Any volume configuration for ${first_vault} is wrong. Please recreate it."
}

@test "crypt(encfs) - try to open without a named vault" {
  run my crypt open && assert_failure
  assert_output "No volume name passed."
}

@test "crypt(encfs) - open vault without mount folder argument" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | run my crypt open "$first_vault" -s
  assert_success
  assert [ -d "${volume_folder}/$first_vault" ]
  assert [ -d "${mount_folder}/$first_vault" ]
}

@test "crypt(encfs) - open vault with mount folder argument" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "y\n${password}\n" | run my crypt open "$first_vault" "$mount_folder" -s
  assert_success
  assert [ -d "${volume_folder}/${first_vault}" ]
  assert [ -d "${mount_folder}/$first_vault" ]
}

@test "crypt(encfs) - reopen a mounted vault" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | my crypt open "$first_vault" -s
  assert [ -d "${volume_folder}/${first_vault}" ]
  assert [ -d "${mount_folder}/$first_vault" ]
  run my crypt open "$first_vault" && assert_failure
  assert_output "$first_vault is already mounted."
  assert [ -d "${volume_folder}/${first_vault}" ]
  assert [ -d "${mount_folder}/$first_vault" ]
}

@test "crypt(encfs) - open using default configuration" {
  printf "encfs\n\n" | my crypt create "$first_vault"
  printf "\ny\n${password}\n" | run my crypt open "$first_vault" -s
  assert_success
  assert [ -d ~/.myvaults/$first_vault ]
  assert [ -d ~/myvaults/$first_vault ]
  run my crypt close "$first_vault"
}

@test "crypt(encfs) - mount two different vaults in same folder" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | run my crypt open "$first_vault" -s
  printf "encfs\n${volume_folder}\n" | my crypt create "$second_vault"
  printf "${mount_folder}\ny\n${password}\n" | run my crypt open "$second_vault" -s
  assert_success
  assert [ -d "${volume_folder}/$first_vault" ]
  assert [ -d "${mount_folder}/$first_vault" ]
  assert [ -d "${volume_folder}/$second_vault" ]
  assert [ -d "${mount_folder}/$second_vault" ]
}

@test "crypt(encfs) - mount two different vaults in different folders" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | run my crypt open "$first_vault" -s
  printf "encfs\n\n" | my crypt create "$second_vault"
  printf "\ny\n${password}\n" | run my crypt open "$second_vault" -s
  assert_success
  assert [ -d "${volume_folder}/$first_vault" ]
  assert [ -d "${mount_folder}/$first_vault" ]
  assert [ -d ~/.myvaults/$second_vault ]
  assert [ -d ~/myvaults/$second_vault ]
  run my crypt close "$second_vault"
}

@test "crypt(encfs) - close vault without argument" {
  run my crypt close && assert_failure
  assert_output "No volume name passed."
}

@test "crypt(encfs) - close not existent vault" {
  run my crypt close not_a_vault && assert_failure
  assert_output "Any volume configuration is wrong. Please recreate it."
}

@test "crypt(encfs) - close vault" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | my crypt open "$first_vault" -s
  run my crypt close "$first_vault" && assert_success
  assert [ -d "${volume_folder}/$first_vault" ]
  assert [ -d "${mount_folder}/$first_vault" ]
}

@test "crypt(encfs) - try to close an already closed vault" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | my crypt open "$first_vault" -s
  my crypt close "$first_vault"
  run my crypt close "$first_vault" && assert_failure
  assert_output "$first_vault is already closed."
}

@test "crypt(encfs) - full test" {
  printf "encfs\n${volume_folder}\n" | my crypt create "$first_vault"
  printf "${mount_folder}\ny\n${password}\n" | my crypt open "$first_vault" -s
  #create file in mounted location
  touch "${mount_folder}/$first_vault/test_file"
  echo "my first content" >> "${mount_folder}/$first_vault/test_file"
  # check if file exists
  assert [ -f "${mount_folder}/$first_vault/test_file" ]
  my crypt close "$first_vault"
  #after close check if file is gone.
  assert [ ! -f "${mount_folder}/$first_vault/test_file" ]
  #mount volume again
  printf "${password}\n" | run my crypt open "$first_vault" -s
  assert_success
  #check if file exists and has the previous content
  assert [ -f "${mount_folder}/$first_vault/test_file" ]
  run cat "${mount_folder}/$first_vault/test_file"
  assert_output "my first content"
}

@test "dummy test - because crypt tests lock in the last real test" {
  assert_success
}
