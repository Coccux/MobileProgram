package com.example.Russify.data.network

import io.ktor.client.*
import io.ktor.client.engine.android.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.request.header
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

import com.example.Russify.BuildConfig

object ApiClient {
    // URL автоматически берется из BuildConfig в зависимости от flavor (dev/prod)
    // dev: http://192.168.0.49:8080 (локальная сеть Wi-Fi)
    // prod: https://api.russify.com (production)
    val BASE_URL = BuildConfig.BASE_URL

    var authToken: String? = null // Сюда сохраним токен после логина

    val client = HttpClient(Android) {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true // Игнорировать лишние поля из JSON
                prettyPrint = true
            })
        }
        defaultRequest {
            url(BASE_URL)

            authToken?.let { token ->
                header("Authorization", "Bearer $token")
            }
        }
    }
}