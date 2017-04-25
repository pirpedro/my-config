# my config

A set of useful shell script tools to aid in configuring environments.
Works in debian-like distros (ubuntu, etc.) and OSX distros.

## Safely Synchronizing

Many times you want to keep your configuration (probably your home directory configuration files) in a cloud solution to make it easily to "deploy" in a new environment.

It's not an easy solution because some contents, like __ssh__ and __gpg__ keys are not recommended to be exposed in a file structure without a robust permission policy in files.  

Thinking about it, we are going to show a useful combination of `my crypt` and `my sync` commands.
Feel free to make your own strategy.

### Getting started

We are going to use __dropbox__ to keep our files synchronized throw different OSs and computers.
Also, we are using __encfs__ to disk encryption because the encrypted folder has a file to each decrypted file. So, if you change a single file, your drobox needs to synchronize only one file, not an entire disk volume.

Let's install encfs:
```
my crypt install encfs
```

Now, create a new __vault__. When it prompt to choose volume folder, choose your dropbox folder (probably __~/Dropbox__):
```
my crypt create vault
```

Now let's try to open it
```
my crypt open vault
```
When prompt to choose mount point, use __~/decrypted__. __encfs__ will prompt for some configurations, choose `p` for pre-configured mode and create the password for your encrypted folder.

After that, you have empty folders __~/Dropbox/vault__ and __~/decrypted/vault__. Everything you create in __~/decrypted/vault__ will be synchronized as an encrypted file in your dropbox. Check it out now!

### Keeping configuration safe
Now let's create a an alias to our new created mount point:
```
my sync alias $HOME ~/decrypted/vault/  
```

For each file or folder that you want to sync, as example __~/.ssh__, do this:
```
my sync ~/.ssh
```

Thanks to the alias create above, it's the same as
```
my sync ~/decrypted/vault/.ssh ~/.ssh
```

### Conclusion

When you close your vault using:
```
my crypt close vault
```
All your configuration files are maintained encrypted in your __Dropbox__ folder and no one will use your keys as the symbolic links are broken.

To keep everything working again, open your vault with your previously selected password.

Go back to [readme](../README.md) for installation steps and usage examples. 
