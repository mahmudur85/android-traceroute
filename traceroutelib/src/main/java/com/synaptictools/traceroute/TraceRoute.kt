package com.synaptictools.traceroute

import com.synaptictools.traceroute.traceroutelibConstants.TAG

/**
 * Created by KMR on October 06, 2021.
 *
 */
object TraceRoute: TracerouteNative() {

    /**
     * record traceroute messages
     */
    private var traceRouteResult: StringBuilder? = null

    /**
     * traceroute callback to user
     */
    private var callback: TraceRouteCallback? = null

    /**
     * keep this method to use with java
     *
     * @param callback The callback that will run
     */
    fun setCallback(callback: TraceRouteCallback?) {
        TraceRoute.callback = callback
    }

    /**
     * this method is for kotlin simplify code
     *
     * @param traceRouteCallback The callback that will run
     */
    fun setCallback(traceRouteCallback: TracerouteResultCallback.() -> Unit) {
        val resultCallback = TracerouteResultCallback()
        resultCallback.traceRouteCallback()
        setCallback(resultCallback)
    }

    override fun onAppendResult(result: String?) {
        println("$TAG onAppendResult - $result")
        if(traceRouteResult == null) {
            traceRouteResult = StringBuilder()
        }
        traceRouteResult?.append(result)
        callback?.onUpdate(result)
    }

    override fun onClearResult() {
        println("$TAG onClearResult()")
        traceRouteResult = null
    }

    fun traceroute(hostname: String): TraceRouteResult? {
        val args = arrayOf("traceroute", hostname)
        return traceroute(StringVector(args))
    }

    private fun traceroute(args: StringVector) : TraceRouteResult {
        val result = TraceRouteResult.instance()
        result.code = execute(args)
        if(result.code == 0) {
            result.message = traceRouteResult.toString()
            callback?.onSuccess(result)
        } else {
            result.message = "traceroute execution failed."
            callback?.onFailed(result.code, result.message)
        }
        return result
    }
}