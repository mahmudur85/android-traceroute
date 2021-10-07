package com.synaptictools.sample

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.synaptictools.traceroute.TraceRoute
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Created by KMR on October 06, 2021.
 *
 */
class MainViewModel: ViewModel() {
    companion object {
        private const val TAG = "MainViewModel:"
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