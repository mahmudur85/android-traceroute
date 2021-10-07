package com.synaptictools.sample

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.ViewModelProvider
import com.synaptictools.sample.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    companion object {
        private const val TAG = "MainActivity:"
    }
    private lateinit var activityMainBinding: ActivityMainBinding
    private lateinit var mainViewModel: MainViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activityMainBinding = DataBindingUtil.setContentView(this, R.layout.activity_main)

        mainViewModel = ViewModelProvider(this).get(MainViewModel::class.java)
        mainViewModel.traceRouteResult.observe(this, { result ->
            println("$TAG result - $result")
            activityMainBinding.tvTracerouteResult.text = result
        })
        activityMainBinding.btTraceRoute.setOnClickListener {
            val hostName = activityMainBinding.evHostName.text.toString()
            if(hostName.isNotEmpty()) {
                println("$TAG hostname - $hostName")
                mainViewModel.traceRoute(hostName)
            }
        }
    }
}