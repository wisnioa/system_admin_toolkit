read -p "Enter username: " name
read -sp "Enter user password: " password
echo
read -sp "Confirm password: " password_confirm

result_perm="u=" 

if [ "$password" == "$password_confirm" ]; then
  echo
  echo "Passwords match."
  read -p "Do you want to allow read access? (y/n) " read_perm
  if [[ $read_perm == "y" ]]; then
    result_perm+="r"
  fi
  read -p "Do you want to allow write access? (y/n) " write_perm
  if [[ $write_perm == "y" ]]; then
    result_perm+="w"
  fi
  read -p "Do you want to allow execute access? (y/n) " exec_perm
  if [[ $exec_perm == "y" ]]; then
    result_perm+="x"
  fi
  echo "Permissions: $result_perm"
 
  sudo adduser "$name"
  sleep 1
  sudo chown -R "$name:$name" "/home/$name"
  sudo chmod -R "$result_perm" "/home/$name"
  echo "Permissions applied to /home/$name."
else
  echo
  echo "Passwords do not match. Please try again."
  read -sp "Enter user password: " password
  echo
  read -sp "Confirm password: " password_confirm
fi