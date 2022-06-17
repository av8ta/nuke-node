#!/bin/bash

# destructive as fuck. be careful

nuke_nvm="n"
nuke_globals="n"
nuke_it_all="n"

# ================================= nvm =======================================

echo
ls $NVM_DIR ~/.npm ~/.bower 2>/dev/null
echo
echo "nvm installation: you want to delete all of this? (y/n)"
read nuke_nvm

# ================================= node globals ==============================

node_globals=$(npm config get prefix)
[ node_globals ]
have_globals=$(($?))
if [[ $(($have_globals)) == 0 && ! $node_globals == "undefined" ]]; then
  echo
  echo $node_globals
  echo
  echo "node globals path: you want to delete this? (y/n)"
  read nuke_globals
fi

# ================================= everything ================================

echo
ls ~/local ~/lib ~/include ~/node* ~/npm ~/.npm* /usr/local/lib/node* /usr/local/include/node* /usr/local/bin/node /usr/local/bin/npm /usr/local/share/man/man1/node.1 /usr/local/lib/dtrace/node.d 2>/dev/null
echo
echo "node installation: you want to delete all of this? (y/n)"
read nuke_it_all

# ================================= do it ? ===================================

if [[ $nuke_nvm == "y" || $nuke_globals == "y" || $nuke_it_all == "y" ]]; then

  echo
  echo "you can still back out..."
  echo
  echo "really delete ? (y/n)"
  read yup

  if [[ $yup == "y" ]]; then
    echo
    echo "okay then..."
    echo
  else
    exit 1

  fi

  # ================================= nvm =======================================
  # ================================= profiles ==================================

  delete_from_profile() {
    echo
    echo "looking in $1 for NVM..."
    catted=$(cat $1 | grep NVM)
    if [ $? == 0 ] 2>/dev/null; then
      cp $1 "$1.backup"
      echo "backed up $1 to $1.nuke_backup"
      grep -v "NVM" $1 >"$1.temp" && mv "$1.temp" $1
    fi
  }

  if [[ $nuke_nvm == "y" ]]; then
    echo
    echo "deleting nvm..."
    echo

    rm -rf $NVM_DIR ~/.npm ~/.bower

    delete_from_profile ~/.profile
    delete_from_profile ~/.bashrc
    delete_from_profile ~/.bash_profile
    delete_from_profile ~/.zshrc

  fi

  # ================================= node globals ==============================

  if [[ $nuke_globals == "y" ]]; then
    echo
    echo "deleting node globals..."
    echo
    rm -rf $node_globals

  fi

  # ================================= everything ================================

  if [[ $nuke_it_all == "y" ]]; then
    echo
    echo "deleting a lot..."

    # https://github.com/brock/node-reinstall
    rm -rf ~/local
    rm -rf ~/lib
    rm -rf ~/include
    rm -rf ~/node*
    rm -rf ~/npm
    rm -rf ~/.npm*
    sudo rm -rf /usr/local/lib/node*
    sudo rm -rf /usr/local/include/node*
    sudo rm -rf /usr/local/bin/node
    sudo rm -rf /usr/local/bin/npm
    sudo rm -rf /usr/local/share/man/man1/node.1*
    sudo rm -rf /usr/local/lib/dtrace/node.d

    sudo rm -rf /usr/bin/node
    sudo rm -rf /usr/include/node
    sudo rm -rf /usr/share/man/man1/node.1*

  fi

  echo
  echo "done. good luck."
  echo

  echo "incidentally, you want to install volta to manage your tools? (y/n)"
  echo "https://docs.volta.sh/guide/#why-volta"
  echo
  read volta

  if [[ $volta == "y" ]]; then
    echo "installing volta"
    curl https://get.volta.sh | bash && echo
    echo "volta installed. see https://docs.volta.sh/guide/getting-started"
    echo
  else

    echo
    echo "okay then, have a lovely day :)"
    echo
  fi

else

  echo
  echo "nothing to do :)"
  exit 0
fi
