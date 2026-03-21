package com.example.Russify.data.network

import io.ktor.client.*
import io.ktor.client.engine.android.*
import io.ktor.client.plugins.auth.*
import io.ktor.client.plugins.auth.providers.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.plugins.logging.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

import com.example.Russify.BuildConfig

object ApiClient {
    // Backend base URL автоматически берется из BuildConfig в зависимости от flavor.
    val BASE_URL = BuildConfig.BASE_URL + "/api"
    val STORAGE_BASE_URL = BuildConfig.STORAGE_BASE_URL.trimEnd('/')

    var authToken: String? = null // Сюда сохраним токен после логина

    val client = HttpClient(Android) {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true // Игнорировать лишние поля из JSON
                prettyPrint = true
            })
        }

        // Логирование запросов (полезно для отладки)
        install(Logging) {
            level = LogLevel.BODY
        }

        // Auth plugin для автоматической подстановки Bearer токена
        install(Auth) {
            bearer {
                loadTokens {
                    // Загружаем токен для каждого запроса
                    authToken?.let { token ->
                        BearerTokens(accessToken = token, refreshToken = "")
                    }
                }

                // Обновление токена при ошибке 401 (пока не реализовано)
                refreshTokens {
                    // TODO: Реализовать refresh token logic
                    null
                }
            }
        }

        defaultRequest {
            url(BASE_URL)
        }
    }
}
