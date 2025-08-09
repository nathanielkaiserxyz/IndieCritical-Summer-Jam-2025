# Set your new name and email
NEW_NAME="Nathaniel Kaiser"
NEW_EMAIL="kaisernathaniel@gmail.com"

# Start an interactive rebase with autosquash disabled
git rebase -i --exec "git commit --amend --no-edit --author=\"$NEW_NAME <$NEW_EMAIL>\"" HEAD~7
