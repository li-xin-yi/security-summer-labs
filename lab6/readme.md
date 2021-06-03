# Lab 6: Behavior-based Mobile Malware Analysis and Detection

## Set-up

Use the `reverse_tcp.apk` we constructed in [Lab 7](../lab7/readme.md), which is assumed to be located in home directory `~/`

### Install [DroidFlow](https://github.com/secure-software-engineering/FlowDroid)

Download [`SourcesAndSinks.txt`](https://raw.githubusercontent.com/secure-software-engineering/FlowDroid/develop/soot-infoflow-android/SourcesAndSinks.txt) from DroidFlow project

Download `soot-infoflow-cmd-jar-with-dependencies.jar`

```
$ wget https://github.com/secure-software-engineering/FlowDroid/releases/download/v2.8/soot-infoflow-cmd-jar-with-dependencies.jar
```

### Find the SDK Version

Install Android Command Line Tool

```
$ wget https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip
$ unzip commandlinetools-linux-7302050_latest.zip
$ mv cmdline-tools lastest
$ mkdir cmdline-tools
$ mv lastest cmdline-tools/
```

Use the `apkanalyzer` tool included in it check the target SDK version

```
$ cd cmdline-tools/lastest/bin
$ ./apkanalyzer -h apk features ~/reverse_tcp.apk
17
```

````{note}

`apkanalyzer` can also conduct a series of simple analyses upon `.apk` files. For example:

```
$ ./apkanalyzer -h apk features ~/reverse_tcp.apk
android.hardware.location.gps implied: requested android.permission.ACCESS_FINE_LOCATION permission, and targetSdkVersion < 21
android.hardware.camera
android.hardware.camera.autofocus
android.hardware.microphone
android.hardware.location.network implied: requested android.permission.ACCESS_COARSE_LOCATION permission, and targetSdkVersion < 21
android.hardware.telephony implied: requested a telephony permission
android.hardware.location implied: requested android.permission.ACCESS_COARSE_LOCATION permission, and requested android.permission.ACCESS_FINE_LOCATION permission
android.hardware.wifi implied: requested android.permission.ACCESS_WIFI_STATE permission, and requested android.permission.CHANGE_WIFI_STATE permission
android.hardware.faketouch implied: default feature for all apps
```

````

The default SDK root is `~/Android/Sdk` to install the target SDK for this app, we should use `sdkmanager` tool as:

```
$./sdkmanager "platform-tools" "platforms;android-17"
```

## Static Analysis

Use `FlowDroid` to detect:

```
$ java -jar soot-infoflow-cmd-jar-with-dependencies.jar -a reverse_tcp.apk -p Android/Sdk/platforms/ -s SourcesAndSinks.txt
```

It gives:

```
[main] INFO soot.jimple.infoflow.cmd.MainClass - Analyzing app ~/reverse_tcp.apk (1 of 1)...
[main] INFO soot.jimple.infoflow.android.SetupApplication - Initializing Soot...
[main] INFO soot.jimple.infoflow.android.SetupApplication - Loading dex files...
[main] INFO soot.jimple.infoflow.android.SetupApplication - ARSC file parsing took 0.003899714 seconds
[main] INFO soot.jimple.infoflow.memory.MemoryWarningSystem - Registered a memory warning system for 14,428.8 MiB
[main] INFO soot.jimple.infoflow.android.entryPointCreators.AndroidEntryPointCreator - Creating Android entry point for 3 components...
[main] INFO soot.jimple.infoflow.android.SetupApplication - Constructing the callgraph...
[main] INFO soot.jimple.infoflow.android.callbacks.DefaultCallbackAnalyzer - Collecting callbacks in DEFAULT mode...
[main] INFO soot.jimple.infoflow.android.callbacks.DefaultCallbackAnalyzer - Callback analysis done.
[main] INFO soot.jimple.infoflow.android.entryPointCreators.AndroidEntryPointCreator - Creating Android entry point for 3 components...
[main] INFO soot.jimple.infoflow.android.SetupApplication - Constructing the callgraph...
[main] INFO soot.jimple.infoflow.android.callbacks.DefaultCallbackAnalyzer - Running incremental callback analysis for 3 components...
[main] INFO soot.jimple.infoflow.android.callbacks.DefaultCallbackAnalyzer - Incremental callback analysis done.
[main] INFO soot.jimple.infoflow.memory.MemoryWarningSystem - Shutting down the memory warning system...
[main] INFO soot.jimple.infoflow.android.SetupApplication - Callback analysis terminated normally
[main] INFO soot.jimple.infoflow.android.SetupApplication - Entry point calculation done.
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.web.servlet.tags.UrlTag: java.lang.String createUrl)> -> _SINK_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.orm.hibernate3.support.ClobStringType: int[] sqlTypes)> -> _SINK_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.security.config.http.CsrfBeanDefinitionParser: org.springframework.beans.factory.config.BeanDefinition getCsrfLogoutHandler)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <java.io.File: java.io.File getAbsoluteFile)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.security.config.http.FormLoginBeanDefinitionParser: java.lang.String getLoginPage)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <com.google.auth.oauth2.UserCredentials: java.lang.String getClientSecret)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.web.servlet.tags.UrlTag: java.lang.String createUrl)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <java.io.File: java.io.File getCanonicalFile)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.apache.xmlrpc.webserver.RequestData: java.lang.String getMethod)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.dmfs.oauth2.client.http.requests.ResourceOwnerPasswordTokenRequest: org.dmfs.httpclient.HttpRequestEntity requestEntity)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.security.concurrent.DelegatingSecurityContextExecutorService: java.util.concurrent.ExecutorService getDelegate)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.security.config.annotation.web.builders.HttpSecurity: org.springframework.security.config.'annotation'.web.configurers.HeadersConfigurer headers)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.web.servlet.tags.EscapeBodyTag: java.lang.String readBodyContent)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.security.config.http.FormLoginBeanDefinitionParser: java.lang.String getLoginProcessingUrl)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.springframework.security.config.annotation.web.configurers.LogoutConfigurer: java.util.List getLogoutHandlers)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.apache.xmlrpc.webserver.RequestData: java.lang.String getHttpVersion)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <com.google.auth.oauth2.DefaultCredentialsProvider: java.io.File getWellKnownCredentialsFile)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match: <org.apache.xmlrpc.webserver.HttpServletRequestImpl: void parseParameters)> -> _SOURCE_
[main] WARN soot.jimple.infoflow.android.data.parsers.PermissionMethodParser - Line does not match:
[main] INFO soot.jimple.infoflow.android.source.AccessPathBasedSourceSinkManager - Created a SourceSinkManager with 68 sources, 194 sinks, and 4 callback methods.
[main] INFO soot.jimple.infoflow.android.SetupApplication - Collecting callbacks and building a callgraph took 5 seconds
[main] INFO soot.jimple.infoflow.android.SetupApplication - Running data flow analysis on /home/xinyi/reverse_tcp.apk with 68 sources and 194 sinks...
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Implicit flow tracking is NOT enabled
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Exceptional flow tracking is enabled
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Running with a maximum access path length of 5
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Using path-agnostic result collection
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Recursive access path shortening is enabled
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Taint analysis enabled: true
[main] INFO soot.jimple.infoflow.InfoflowConfiguration - Using alias algorithm FlowSensitive
[main] INFO soot.jimple.infoflow.memory.MemoryWarningSystem - Registered a memory warning system for 14,428.8 MiB
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Callgraph construction took 0 seconds
[main] INFO soot.jimple.infoflow.codeOptimization.InterproceduralConstantValuePropagator - Removing side-effect free methods is disabled
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Dead code elimination took 0.07780257 seconds
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Callgraph has 217 edges
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Starting Taint Analysis
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Using context- and flow-sensitive solver
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Using context- and flow-sensitive solver
[main] WARN soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Running with limited join point abstractions can break context-sensitive path builders
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Looking for sources and sinks...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Source lookup done, found 2 sources and 5 sinks.
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Taint wrapper hits: 32
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Taint wrapper misses: 18
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - IFDS problem with 549 forward and 20 backward edges solved in 0 seconds, processing 2 results...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Current memory consumption: 115 MB
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Memory consumption after cleanup: 39 MB
[main] INFO soot.jimple.infoflow.data.pathBuilders.BatchPathBuilder - Running path reconstruction batch 1 with 2 elements
[main] INFO soot.jimple.infoflow.data.pathBuilders.ContextSensitivePathBuilder - Obtainted 2 connections between sources and sinks
[main] INFO soot.jimple.infoflow.data.pathBuilders.ContextSensitivePathBuilder - Building path 1...
[main] INFO soot.jimple.infoflow.data.pathBuilders.ContextSensitivePathBuilder - Building path 2...
[main] INFO soot.jimple.infoflow.memory.MemoryWarningSystem - Shutting down the memory warning system...
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Memory consumption after path building: 38 MB
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Path reconstruction took 0 seconds
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - The sink virtualinvoke $r19.<java.io.FileOutputStream: void write(byte[])>($r18) in method <com.metasploit.stage.Payload: void a(java.io.DataInputStream,java.io.OutputStream,java.lang.Object[])> was called with values from the following sources:
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - - $r17 = virtualinvoke $r22.<java.net.URLConnection: java.io.InputStream getInputStream()>() in method <com.metasploit.stage.Payload: void main(java.lang.String[])>
[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Data flow solver took 0 seconds. Maximum memory consumption: 115 MB
[main] INFO soot.jimple.infoflow.android.SetupApplication - Found 1 leaks
```
