[![Download](https://maven-badges.herokuapp.com/maven-central/com.synaptic-tools/traceroute/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.synaptic-tools/traceroute)

# Android Traceroute

An android Traceroute implementation

# Description

Traceroute is a network diagnostic tool used to track in real-time the pathway taken by a packet on an IP network from source to destination, reporting the IP addresses of all the routers it pinged in between. Traceroute also records the time taken for each hop the packet makes during its route to the destination.

Traceroute most commonly uses Internet Control Message Protocol (ICMP) echo packets with variable time to live (TTL) values. The response time of each hop is calculated. To guarantee accuracy, each hop is queried multiple times (usually three times) to better measure the response of that particular hop. Traceroute uses ICMP messages and TTL fields in the IP address header to function. Traceroute tools are typically included as a utility by operating systems such as Windows and Unix. Traceroute utilities based on TCP are also available.

# How to use

```bash
implementation "com.synaptic-tools:traceroute:1.0.0"
```

# Usages

Use `TraceRoute.setCallback` method to get the report asynchronously

```kotlin
TraceRoute.setCallback {
	success { ... }
    update { text -> ... }
    failed { code, reason -> ... }
}
TraceRoute.traceroute(hostName)
```

# ViewModel example implementation

```kotlin
import com.synaptictools.traceroute.TraceRoute

...

class MyViewModel: ViewModel() {
    companion object {
        private const val TAG = "MyViewModel:"
    }
    private val resultBuilder: StringBuilder = StringBuilder()
    private val _traceRouteResult: MutableLiveData<String> by lazy {
        MutableLiveData<String>()
    }

    val traceRouteResult: LiveData<String>
        get() = _traceRouteResult

    fun traceRoute(hostName: String?) {
        resultBuilder.clear()
        viewModelScope.launch {
            doTraceRoute(hostName)
        }
    }

    private suspend fun doTraceRoute(hostName: String?){
        withContext(Dispatchers.IO) {
            println("$TAG doTraceRoute on $hostName")
            hostName?.let { it ->
                if(it.isNotEmpty()) {
                    TraceRoute.setCallback{
                        success {
                            resultBuilder.append("\ntraceroute finish")
                            _traceRouteResult.postValue(resultBuilder.toString())
                        }
                        update { text ->
                            resultBuilder.append(text)
                            _traceRouteResult.postValue(resultBuilder.toString())
                        }
                        failed { code, reason ->
                            resultBuilder.append("\ntraceroute failed:\n code: '$code', reason: '$reason'")
                            _traceRouteResult.postValue(resultBuilder.toString())
                        }
                    }
                    TraceRoute.traceroute(it)
                }
            }
        }
    }
}
```

