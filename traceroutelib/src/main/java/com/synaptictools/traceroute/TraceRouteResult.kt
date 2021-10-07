package com.synaptictools.traceroute

/**
 * Created by KMR on October 06, 2021.
 *
 */
data class TraceRouteResult(var code: Int, var message: String) {
    companion object{
        fun instance(): TraceRouteResult = TraceRouteResult(-1, "")
    }
}
