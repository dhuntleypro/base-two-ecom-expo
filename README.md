

# Publish




# How to active git action



# Adding SSH with Git
<!-- run: ssh-keygen -t rsa -b 4096 -C dhuntleypro@icloud.com
Open the .pud file
Paste in here : https://github.com/settings/ssh/new
Title : My SSH Key for GitHub Actions
Select : Auth Key -->


# encrpty files 
openssl aes-256-cbc -in .env.secrets -out .env.secrets.enc

# encrpty files with phrase
openssl aes-256-cbc -in ~/.ssh/id_rsa -out id_rsa.enc -pass pass:your_passphrase
