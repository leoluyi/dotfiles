# Ubuntu xRDP - Custom Installation Script

http://c-nergy.be/blog/?p=12562

| version Supported     | Ubuntu Version | Features                                   |
|:----------------------|:---------------|:-------------------------------------------|
| install-xrdp-3.0.sh   | 18.04/18.10/19.04   | Added U18.10 and Yaru theme support        |
| install-xrdp-1.9.2.sh | 16.04.x        | cleanup code, multiple user session config |

### Usage

```
chmod +x  ~/Downloads/install-xrdp-3.0.sh
```

### Enabling Sound redirection 

To enable sound redirection features within your remote desktop session,  it's possible to pass the -s parameter to the script.  In other words, in order to enable sound redirection at installation time, you will need to execute the following syntax

```
./install-xrdp-3.0.sh -s yes
```

### Test your configuration 

After a good reboot, you should be able to test your configuration.  Using your favourite remote desktop client, perform a connection.  You will be presented with the green login page from xRDP.  Provide your credentials and if everything is working as expected, you should see your Ubuntu Desktop interface loading and you are ready to go and perform your work on the remote machine. 

As a reminder, the same user can be connected either on the local machine or on the remote machine, not both at the same time.  If a user is locally connected, and the same user tries to perform a remote desktop connection, the process will fail...If you disconnect from your remote session, you can reconnect to the same session and proceed with your work.... 

