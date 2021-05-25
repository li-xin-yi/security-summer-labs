# Lab 7: Developing Mobile Malware

## Set-up

Install [Metasploit](https://www.metasploit.com/) Module


```sh
$ curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
$ chmod 755 msfinstall
$ ./msfinstall
```

Install [Keytool]()

```
$ msfconsole
msf >  search type:payload platform:android
```

## Explore Metasploits [^ex]

[^ex]: https://www.hackers-arise.com/post/2018/07/06/metasploit-basics-part-13-exploiting-android-mobile-devices

