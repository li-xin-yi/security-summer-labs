# Lab 6: Behavior-based Mobile Malware Analysis and Detection

A collection of malware `apk`s: [android-malware](https://github.com/ashishb/android-malware/)
 
## Set-up


`````{tabbed} FlowDroid

Install Dependencies:

```
$ sudo apt-get install openjdk-8-jdk openjdk-8-jre android-sdk
```

Find the SDK folder, it is usually located in `/usr/lib/android-sdk/`. Set it as an enviroment variable

```
export ANDROID_SDK=/usr/lib/android-sdk/
```

Download [`SourcesAndSinks.txt`](https://raw.githubusercontent.com/secure-software-engineering/FlowDroid/develop/soot-infoflow-android/SourcesAndSinks.txt) from DroidFlow project

```
wget https://raw.githubusercontent.com/secure-software-engineering/FlowDroid/develop/soot-infoflow-android/SourcesAndSinks.txt
```

**Install [FlowDroid](https://github.com/secure-software-engineering/FlowDroid)**

Download `soot-infoflow-cmd-jar-with-dependencies.jar`

```
$ wget https://github.com/secure-software-engineering/FlowDroid/releases/download/v2.8/soot-infoflow-cmd-jar-with-dependencies.jar
```

````

`````{tabbed} Mobile Security Framework (MobSF)

If you have set-up Docker before, you can start it by pulling the image and running the container via Docker:

```
docker pull opensecurity/mobile-security-framework-mobsf
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
```

And then open the web-broswer to check the link [http://localhost:8000/](http://localhost:8000/).

Otherwise, if you don't want to run Docker on your local machine, you can open the URL: [https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/MobSF/Mobile-Security-Framework-MobSF/master/scripts/stack/docker-compose.yml](https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/MobSF/Mobile-Security-Framework-MobSF/master/scripts/stack/docker-compose.yml) to run the Docker container as a web application online.

```{warning}
You may be asked to sign up with a DockerHub account first. After you register the account, log in and click on "Start". 
```

```{warning}
When "Session stack builder" finishes, it says that "Your session is ready", then you can click on "CLOSE", if it doesn't work, just refresh the website.

![](session_ready.png)
```

Click on "8000" in this page:

![](dcoker-online.png)

And finally you can see such a web application on port 8000:

![](mobsf_web.png)
`````





## FlowDroid: Static Analysis

FlowDroid [^1] is a context-, flow-, field-, object-sensitive and lifecycle-aware static taint analysis tool for Android applications. It is based on [Soot](http://www.sable.mcgill.ca/soot/) and [Heros](http://sable.github.io/heros/). A very precise call-graph is used to ensure flow- and context-sensitivity. For the purpose of malware detection, FlowDroid statically computes **data-flows** in Android apps and Java programs, which is intented to find out data leaks.

[^1]: Arzt, Steven, et al. "[Flowdroid: Precise context, flow, field, object-sensitive and lifecycle-aware taint analysis for android apps.](https://www.bodden.de/pubs/far+14flowdroid.pdf)" *Acm Sigplan Notices* 49.6 (2014): 259-269.

For example, [`Claco.A.apk`](https://github.com/ashishb/android-malware/tree/master/BreakBottleneck/SamplesOfHIP2014TalkBreakBottleneck/Claco.A) [^2] is an Android malicious app that steals text messages, contacts and all SD Card files, and it can also automatically execute downloaded `svchosts.exe` when the phone is connected to the PC in the USB drive emulation mode. `svchosts.exe` can record sound around the infected PC and upload to remote servers.

[^2]: See this slides: https://github.com/ashishb/android-malware/raw/master/BreakBottleneck/Break%20Bottleneck.pdf 

Before running `FlowDroid` with downloaded `Claco.A.apk`, we must specify a  definition file for sources and sinks, which defines what use a default shall be treated as a source of sensitive information and what shall be treated as a sink that can possibly leak sensitive data to the outside world. `SourcesAndSinks.txt` provided by FlowDroid homepage demo is targeted on looking for privacy issues, we can apply it for our example to analyze the data-flow in `Claco.A.apk`:

```
$ java -jar soot-infoflow-cmd-jar-with-dependencies.jar -a Claco.A.apk -p $ANDROID_SDK/platforms/ -s SourcesAndSinks.txt
```

It will give a long report about the analysis result:


```
...
[main] INFO soot.jimple.infoflow.android.SetupApplication - Collecting callbacks and building a callgraph took 1 seconds
[main] INFO soot.jimple.infoflow.android.SetupApplication - Running data flow analysis on Claco.A.apk with 68 sources and 194 sinks...
...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Callgraph construction took 0 seconds
...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - IFDS problem with 10212 forward and 4505 backward edges solved in 0 seconds, processing 14 results...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Current memory consumption: 249 MB
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Memory consumption after cleanup: 35 MB
[main] INFO soot.jimple.infoflow.data.pathBuilders.BatchPathBuilder - Running path reconstruction batch 1 with 5 elements
[main] INFO soot.jimple.infoflow.data.pathBuilders.ContextSensitivePathBuilder - Obtainted 5 connections between sources and sinks
...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - The sink virtualinvoke $r7.<java.io.FileOutputStream: void write(byte[])>($r8) in method <smart.apps.droidcleaner.Tools: boolean GetContacts(android.content.Context)> was called with values from the following sources:
...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - - r5 = interfaceinvoke $r4.<android.database.Cursor: java.lang.String getString(int)>($i0) in method <smart.apps.droidcleaner.Tools: boolean GetContacts(android.content.Context)>
...
<smart.apps.droidcleaner.Tools: boolean GetAllSMS(android.content.Context)> was called with values from the following sources:
...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - - $r9 = interfaceinvoke $r4.<android.database.Cursor: java.lang.String getString(int)>($i1) in method <smart.apps.droidcleaner.Tools: boolean GetAllSMS(android.content.Context)>
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - The sink virtualinvoke $r13.<java.io.DataOutputStream: void write(byte[],int,int)>(r5, 0, $i0) in method <smart.apps.droidcleaner.Tools: boolean UploadFile(java.lang.String,java.lang.String,java.lang.String,java.lang.String,android.content.Context)> was called with values from the following sources:
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Data flow solver took 1 seconds. Maximum memory consumption: 249 MB
[main] INFO soot.jimple.infoflow.android.SetupApplication - Found 11 leaks
```

It first determines the sources and sinks in the decompiled codes according to `SourcesAndSinks.txt`, and then build a call-graph and construct path between sources and sinks. Finally it finds out some data-flows comes from identified sensitive sources but never go into any legal sinks, which means sensitive data leaks. For example, from the report above, method `GetContacts`, `GetAllSMS` and `UploadFile` are called with private data as context but data is then flow into somewhere not in defined sinks, which probably matches the behavior we describe above. Thus, `FlowDroid` can detect privacy leakage issues in this app. 

```{note} Deliverable 1
Can you run `FlowDroid` with a similar configuration to explore the privacy issue in the malware `reverse_tcp`, which you have created in previous Lab 7? And then describe what happens, is there any data leakage? If there is, point out which lines in the outputs helps you locate the data leakage?
```

````{important} Answer 1
Run 
```
java -jar soot-infoflow-cmd-jar-with-dependencies.jar -a reverse_tcp.apk -p $ANDROID_SDK/platforms/ -s SourcesAndSinks.txt
```
Yes, there is one data leakage found in last few lines of the outputs:
```
...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - The sink virtualinvoke $r19.<java.io.FileOutputStream: void write(byte[])>($r18) in method <com.metasploit.stage.Payload: void a(java.io.DataInputStream,java.io.OutputStream,java.lang.Object[])> was called with values from the following sources:
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - - $r17 = virtualinvoke $r22.<java.net.URLConnection: java.io.InputStream getInputStream()>() in method <com.metasploit.stage.Payload: void main(java.lang.String[])>
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Data flow solver took 0 seconds. Maximum memory consumption: 50 MB
[main] INFO soot.jimple.infoflow.android.SetupApplication - Found 1 leaks
```
````

## MobSF: Static Analysis

[Mobile Security Framework (MobSF)](https://github.com/MobSF/Mobile-Security-Framework-MobSF) is an automated, all-in-one mobile application (Android/iOS/Windows) pen-testing, malware analysis and security assessment framework capable of performing static and dynamic analysis.

```{warning}
We will not build with the *dynamic analysis* feature in this lab for that the associated Android VMs cannot be simply configured in VMs and Docker containers. If you are still interested in this feature, read its [docs](https://mobsf.github.io/docs) or email us for help.
```

It runs as a web application that you can simply upload `.apk` files for a more comprehesive analysis. In the following of this section, we will domenstrate how to use it to detect malwares.

For example, [`Dropdialer.apk`](https://github.com/ashishb/android-malware/blob/master/BreakBottleneck/SamplesOfHIP2014TalkBreakBottleneck/Dropdialer.A/Dropdialer.apk)[^2] guises as an app supposedly used to set wallpapers. However it downloads another file in the background. It then tricks users to install the downloaded file. 

We upload `Dropdialer.apk` via MobSF web interface, after it completely analyzes the `apk` file, we will immediately jump to a report page like:

![](dropdialer-report-top.png)

Scroll down and pay attention to the Permission section:

![](permission.png)

Notice that it has a `WRITE_EXTERNAL_STORAGE` permission that allows an application to write to **external storage**, which enables the app downloads another app in the backgroud.

Then we move to the Code Analysis section, which lists some vulnerable codes:

![](code-analysis.png)

The second item shows that a method in this app can write or read external storage by default permission. If we click on `com/nnew/superMariowallpapers/MarioHDWallpapersActivity.java`, it will jump to the vulnerable code location:

![](download.png)

It is pretty obvious that it could read from some downloaded `apk` and `txt`. But when are those files downloaded?

See Quark Analysis in Malware Analysis section, it enumerates out all potential malicious behaviors in this app:

![](quark.png)

`com/nnew/superMariowallpapers/AlertActivity.smali -> download(Ljava/lang/String;Ljava/lang/String;)V` [^3] indicates most suspecious behaviors are defined in `download` method, which intends to download some files from external URLs:

![](procedure.png)

If we continue to look at Server Location, Domain Malware Check and URLs sections, we can know more about the external link which the app send requests to:

![](server.png)

The URL `http://dl.dropbox.com/u/87265868/srv.txt` with domain `dl.dropbox.com` has a geolocation listed above and still works now.

All the analysis results matches the malicious behaviors that `Dropdialer.apk` is designed for. 

[^3]: `.smali` is a human-readable dex fromat used in Android's Java VM implementation. But we do not recommend reading this low-level representation here. More information about it can be found in https://github.com/JesusFreke/smali