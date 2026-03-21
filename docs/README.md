# 📱 Russify - Документация

Android приложение с современной системой сборки и автоматизацией уровня production.

---

## 🚀 Быстрый старт

**Новичок?** Начните с [QUICKSTART.md](QUICKSTART.md) — за 5 минут соберете и запустите приложение на телефоне.

**Опытный разработчик?** См. [BUILD.md](BUILD.md) для полной документации по сборке, тестированию и релизу.

---

## 📚 Структура документации

| Документ | Описание | Для кого |
|----------|----------|----------|
| **[QUICKSTART.md](QUICKSTART.md)** | Быстрый старт за 5 минут | Новички, быстрая настройка |
| **[BUILD.md](BUILD.md)** | Полная документация | Разработчики, CI/CD, релизы |

---

## 🎯 Возможности системы сборки

```mermaid
graph LR
    A[Исходный код] --> B{Gradle Build}
    B --> C[Dev Debug]
    B --> D[Dev Release]
    B --> E[Prod Debug]
    B --> F[Prod Release]

    C --> G[Локальное тестирование]
    D --> G
    E --> H[Production тестирование]
    F --> I[Google Play Store]

    style C fill:#90EE90
    style D fill:#90EE90
    style E fill:#FFD700
    style F fill:#FFD700
    style I fill:#FF6347
```

### ✅ Реализовано

- **Multi-flavor builds** — dev и prod окружения
- **Автоматическое версионирование** — из Git tags (semver)
- **Docker сборка** — reproducible builds
- **CI/CD** — GitHub Actions с автоматическими релизами
- **Makefile автоматизация** — 60+ команд для упрощения работы
- **ProGuard/R8** — оптимизация и обфускация кода
- **Signing configs** — безопасная подпись релизов

---

## ⚡ Самые используемые команды

```bash
# Разработка
make dev-run              # Собрать, установить и запустить dev версию
make logs-dev             # Посмотреть логи приложения

# Production
make prod-release         # Собрать production APK
make release-tag VERSION=1.0.0  # Создать релиз тег

# Тестирование
make test                 # Запустить тесты
make lint                 # Проверка кода
make check                # Все проверки

# Утилиты
make help                 # Показать все команды
make clean                # Очистить build
```

---

## 🏗️ Архитектура Build System

```mermaid
flowchart TB
    subgraph Source["Исходный код"]
        A1[Java/Kotlin]
        A2[Resources]
        A3[Assets]
    end

    subgraph Gradle["Gradle Build System"]
        B1[version.gradle.kts<br/>Версионирование]
        B2[build.gradle.kts<br/>Конфигурация]
        B3[Product Flavors<br/>dev / prod]
    end

    subgraph Build["Типы сборки"]
        C1[Debug<br/>Разработка]
        C2[Release<br/>Production]
    end

    subgraph Output["Результаты"]
        D1[APK файлы]
        D2[AAB для Play Store]
        D3[Mapping файлы]
    end

    subgraph Auto["Автоматизация"]
        E1[Makefile<br/>Команды]
        E2[Docker<br/>Изоляция]
        E3[GitHub Actions<br/>CI/CD]
    end

    Source --> Gradle
    Gradle --> Build
    Build --> Output
    Auto --> Gradle

    style B1 fill:#4A90E2
    style B3 fill:#4A90E2
    style C2 fill:#E24A4A
    style E3 fill:#50C878
```

---

## 🔧 Требования

### Минимальные

- **Java 17** (LTS)
- **Android SDK** API 35
- **Gradle 8.x** (включен в wrapper)
- **Git** для версионирования

### Опциональные

- **Make** — для упрощенных команд
- **Docker** — для изолированной сборки
- **ADB** — для установки на устройства

---

## 📦 Build Flavors

| Flavor | Backend | App ID | Название | Использование |
|--------|---------|--------|----------|---------------|
| **dev** | `http://192.168.0.49:8080` | `com.example.Russify.dev` | Russify Dev | Разработка с локальным backend |
| **prod** | `https://api.russify.com` | `com.example.Russify` | Russify | Production релизы |

---

## 🔄 Workflow разработки

```mermaid
sequenceDiagram
    participant Dev as Разработчик
    participant Git as Git
    participant Build as Gradle Build
    participant Device as Android устройство
    participant CI as GitHub Actions

    Dev->>Git: git commit
    Dev->>Build: make dev-run
    Build->>Device: Установка APK
    Device-->>Dev: Тестирование

    Dev->>Git: git push
    Git->>CI: Trigger workflow
    CI->>CI: Lint + Tests + Build
    CI-->>Dev: Результаты проверок

    Note over Dev,CI: При создании тега
    Dev->>Git: git tag v1.0.0
    Git->>CI: Release workflow
    CI->>CI: Build prod release
    CI->>CI: Create GitHub Release
    CI-->>Dev: APK готов к публикации
```

---

## 🚀 Релизы

### Процесс создания релиза

```bash
# 1. Создать тег версии
make release-tag VERSION=1.0.0

# 2. Push на GitHub
git push origin v1.0.0

# 3. GitHub Actions автоматически:
#    ✓ Соберет release APK/AAB
#    ✓ Запустит все тесты
#    ✓ Создаст GitHub Release
#    ✓ Прикрепит артефакты
```

Подробнее в разделе "Deployment" в [BUILD.md](BUILD.md).

---

## 📖 Дополнительные ресурсы

### Официальная документация

- [Android Gradle Plugin](https://developer.android.com/build)
- [Gradle Build Tool](https://gradle.org/)
- [Docker Documentation](https://docs.docker.com/)

### Внутренние ссылки

- [Troubleshooting](BUILD.md#-troubleshooting) — решение типичных проблем
- [CI/CD Setup](BUILD.md#-cicd) — настройка автоматизации
- [Versioning](BUILD.md#-версионирование) — система версий
