package com.synaptictools.traceroute

/**
 * Created by KMR on October 06, 2021.
 *
 */
interface TraceRouteCallback {

    /**
     * traceroute success
     *
     * @param traceRouteResult get traceroute result status. code is 0 for success.
     */
    fun onSuccess(traceRouteResult: TraceRouteResult?)

    /**
     * callback when tracerouting
     *
     * @param text current traceroute message
     */
    fun onUpdate(text: String?)

    /**
     * traceroute failed
     *
     * @param code execute code. Nonzero is failure
     * @param reason Failure explanation
     */
    fun onFailed(code: Int, reason: String?)
}