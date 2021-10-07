package com.synaptictools.traceroute

/**
 * Created by KMR on October 06, 2021.
 *
 */
class TracerouteResultCallback: TraceRouteCallback {
    private var _onSuccess: ((traceRouteResult: TraceRouteResult?) -> Unit)? = null

    private var _onUpdate: ((text: String?) -> Unit)? = null

    private var _onFailed: ((code: Int, reason: String?) -> Unit)? = null


    /**
     * wrap for onSuccess
     *
     * @param traceRouteResult get traceroute result status. code is 0 for success.
     */
    fun success(success: (traceRouteResult: TraceRouteResult?) -> Unit) {
        _onSuccess = success
    }

    /**
     * traceroute success
     *
     * @param traceRouteResult get traceroute result status. code is 0 for success.
     */
    override fun onSuccess(traceRouteResult: TraceRouteResult?) {
        _onSuccess?.invoke(traceRouteResult)
    }

    /**
     * wrap for onUpdate
     *
     * param text current traceroute message
     */
    fun update(update: (text: String?) -> Unit) {
        _onUpdate = update
    }

    /**
     * callback when tracerouting
     *
     * @param text current traceroute message
     */
    override fun onUpdate(text: String?) {
        _onUpdate?.invoke(text)
    }

    /**
     * wrap for onFailed
     *
     * @param code execute code. Nonzero is failure
     * @param reason Failure explanation
     */
    fun failed(failed: (code: Int, reason: String?) -> Unit) {
        _onFailed = failed
    }

    /**
     * traceroute failed
     *
     * @param code execute code. Nonzero is failure
     * @param reason Failure explanation
     */
    override fun onFailed(code: Int, reason: String?) {
        _onFailed?.invoke(code, reason)
    }
}