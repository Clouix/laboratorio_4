package com.example.laboratorio_4

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.appcompat.app.AlertDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.laboratorio_4/custom_link"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        val intent = intent
        val appLinkAction = intent.action
        val appLinkData = intent.data

        if (Intent.ACTION_VIEW == appLinkAction && appLinkData != null) {
            // Si se abre la aplicación desde un enlace, se maneja el enlace inmediatamente
            handleIntent(intent)
        }

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Registrar el canal de comunicación para recibir los enlaces personalizados
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getInitialLink") {
                // Obtener el enlace inicial cuando se abre la aplicación
                val link = handleIntent(intent)
                result.success(link)
            }
        }
    }

    private fun handleIntent(intent: Intent?): String? {
        val data = intent?.data
        return if (data != null && "myapp" == data.scheme) {
            // Aquí puedes extraer los datos del enlace y realizar las acciones necesarias en tu aplicación
            val name = data.getQueryParameter("name")
            val age = data.getQueryParameter("age")
            val football = data.getQueryParameter("football")
            val favoriteTeam = data.getQueryParameter("favoriteTeam")
            val location = data.getQueryParameter("location")

            // Puedes realizar las acciones deseadas con los datos del enlace
            // Por ejemplo, mostrar un diálogo con la información
            showDialog(name, age, football, favoriteTeam, location)

            data.toString()
        } else {
            null
        }
    }

    private fun showDialog(name: String?, age: String?, football: String?, favoriteTeam: String?, location: String?) {
        val dialog = AlertDialog.Builder(this)
            .setTitle("Información")
            .setMessage("Nombre: $name\n" +
                    "Edad: $age\n" +
                    "¿Te gusta el fútbol?: $football\n" +
                    "Equipo favorito: $favoriteTeam\n" +
                    "Ubicación: $location")
            .setPositiveButton("OK") { dialog, _ -> dialog.dismiss() }
            .create()

        dialog.show()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }
}
