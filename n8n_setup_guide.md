# 🚀 Пошаговая инструкция запуска workflow в n8n

## 📋 Содержание
1. [Установка n8n](#установка-n8n)
2. [Импорт workflow](#импорт-workflow)
3. [Настройка credentials](#настройка-credentials)
4. [Конфигурация нод](#конфигурация-нод)
5. [Тестирование](#тестирование)
6. [Активация](#активация)
7. [Мониторинг](#мониторинг)

---

## 1. 🔧 Установка n8n

### Вариант A: Docker (Рекомендуется)
```bash
# Создаем директорию для данных
mkdir n8n-data

# Запускаем n8n в Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v $(pwd)/n8n-data:/home/node/.n8n \
  n8nio/n8n
```

### Вариант B: npm
```bash
# Устанавливаем n8n глобально
npm install n8n -g

# Запускаем
n8n start
```

### Вариант C: n8n Cloud
- Перейдите на https://n8n.cloud
- Создайте аккаунт
- Выберите план (есть бесплатный)

**После запуска откройте браузер:** http://localhost:5678

---

## 2. 📥 Импорт workflow

### Способ 1: Импорт JSON файла

1. **Откройте n8n** в браузере
2. **Нажмите "+" → "Import from file"**
3. **Выберите файл** `n8n_workflow_examples.json`
4. **Выберите workflow** для импорта:
   - `Inventory Reserve Main Workflow`
   - `Error Handler Workflow` 
   - `Scheduled Stock Sync`

### Способ 2: Копирование JSON

1. **Создайте новый workflow** (кнопка "+")
2. **Нажмите на три точки** в правом верхнем углу
3. **Выберите "Import from Clipboard"**
4. **Скопируйте JSON** одного из workflow из файла
5. **Вставьте и нажмите "Import"**

### Способ 3: Создание с нуля

Если хотите создать workflow вручную, следуйте схеме:

```
Webhook → Set Variables → HTTP Request (Bitrix24) → Code (Validation) → 
IF → [Success: Update Stock → Create Deal → Log → Notify → Response]
   → [Error: Log Error → Notify Error → Error Response]
```

---

## 3. 🔑 Настройка credentials

### 3.1 Google Sheets

1. **Перейдите в настройки** → Credentials
2. **Нажмите "Create New"** → Google Sheets API
3. **Выберите способ аутентификации:**

#### Способ A: Service Account (Рекомендуется)
```bash
# 1. Перейдите в Google Cloud Console
# 2. Создайте новый проект или выберите существующий
# 3. Включите Google Sheets API
# 4. Создайте Service Account
# 5. Скачайте JSON ключ
```

#### Способ B: OAuth2
- Получите Client ID и Client Secret из Google Console
- Пройдите процедуру авторизации

### 3.2 Telegram Bot

1. **Создайте бота** через @BotFather в Telegram:
```
/newbot
# Следуйте инструкциям
# Получите Bot Token
```

2. **В n8n добавьте Telegram credentials:**
- Access Token: `ваш_bot_token`

3. **Получите Chat ID:**
```bash
# Отправьте сообщение боту, затем выполните:
curl https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates

# Найдите chat.id в ответе
```

### 3.3 Email (SMTP)

```json
{
  "host": "smtp.gmail.com",
  "port": 587,
  "secure": false,
  "user": "your-email@gmail.com",
  "password": "your-app-password"
}
```

### 3.4 Битрикс24 Webhook

1. **В Битрикс24 перейдите:**
   - Приложения → Разработчикам → Другое → Входящий вебхук

2. **Настройте права:**
```
catalog - Торговый каталог
crm - CRM
tasks - Задачи и проекты
im - Чат и уведомления
```

3. **Скопируйте URL вебхука:**
```
https://your-domain.bitrix24.ru/rest/1/webhook_key/
```

---

## 4. ⚙️ Конфигурация нод

### 4.1 Замена placeholder значений

Найдите и замените в каждой ноде:

```javascript
// В HTTP Request нодах
"url": "https://your-bitrix24.bitrix24.ru/rest/1/webhook_key/"
// Заменить на:
"url": "https://ваш-домен.bitrix24.ru/rest/1/ваш_webhook_key/"

// В Google Sheets нодах
"sheetId": "your-sheet-id"
// Заменить на ID вашей таблицы

// В Telegram нодах
"chatId": "your-chat-id"
// Заменить на ваш Chat ID
```

### 4.2 Настройка Google Sheets

Создайте таблицу со следующими листами:

#### Лист "Лог операций"
| A | B | C | D | E | F | G |
|---|---|---|---|---|---|---|
| Время | Операция | ID товара | Количество | Статус | Сообщение | Пользователь |

#### Лист "Ошибки"  
| A | B | C | D | E | F |
|---|---|---|---|---|---|
| Время | Workflow | Тип ошибки | Сообщение | Серьезность | Execution ID |

#### Лист "Остатки"
| A | B | C | D | E |
|---|---|---|---|---|
| ID товара | Название | Количество | Статус | Время обновления |

### 4.3 Настройка webhook URL

1. **В ноде Webhook** установите:
```json
{
  "httpMethod": "POST",
  "path": "inventory-reserve",
  "responseMode": "responseNode"
}
```

2. **Скопируйте Production URL** (появится после сохранения)
3. **URL будет выглядеть так:**
```
https://your-n8n-instance.com/webhook/inventory-reserve
```

---

## 5. 🧪 Тестирование

### 5.1 Тест основного workflow

1. **Активируйте workflow** (переключатель в правом верхнем углу)

2. **Отправьте тестовый запрос:**
```bash
curl -X POST https://your-n8n-instance.com/webhook/inventory-reserve \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": "123",
    "quantity": 2,
    "customer_id": "456",
    "reserve_type": "order"
  }'
```

3. **Или используйте Postman/Insomnia** с теми же данными

### 5.2 Тест через Manual Trigger

1. **Добавьте Manual Trigger** в начало workflow
2. **Нажмите "Execute Workflow"**
3. **Введите тестовые данные** в JSON формате
4. **Наблюдайте выполнение** по нодам

### 5.3 Проверка логов

```bash
# В Docker
docker logs n8n

# Или в интерфейсе n8n
# Executions → выберите выполнение → посмотрите детали
```

---

## 6. ✅ Активация

### 6.1 Активация workflow

1. **Убедитесь, что все ноды настроены**
2. **Переключите тумблер "Active"** в правом верхнем углу
3. **Workflow начнет работать автоматически**

### 6.2 Настройка Cron триггеров

Для периодических задач:
```javascript
// Каждые 15 минут в рабочее время
"0 */15 8-18 * * 1-5"

// Каждый час
"0 0 * * * *"

// Каждый день в 9:00
"0 0 9 * * *"
```

### 6.3 Проверка активности

- **Зеленый индикатор** = workflow активен
- **Серый индикатор** = workflow неактивен
- **Красный индикатор** = ошибка в workflow

---

## 7. 📊 Мониторинг

### 7.1 Просмотр выполнений

1. **Перейдите в "Executions"**
2. **Фильтруйте по:**
   - Workflow
   - Статусу (Success/Error)
   - Дате

### 7.2 Настройка алертов

```javascript
// В Error Trigger workflow добавьте мониторинг
const errorCount = $execution.data.resultData.runData;
if (errorCount > 10) {
  // Отправить критический алерт
}
```

### 7.3 Логирование

Все операции логируются в:
- **Google Sheets** (структурированные данные)
- **n8n Executions** (детальные логи)
- **Telegram/Email** (уведомления)

---

## 🔧 Дополнительные настройки

### Переменные окружения для Docker

```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=password \
  -e WEBHOOK_URL=https://your-domain.com \
  -v $(pwd)/n8n-data:/home/node/.n8n \
  n8nio/n8n
```

### Настройка SSL для production

```bash
# С Let's Encrypt
docker run -it --rm \
  --name n8n \
  -p 80:5678 \
  -e N8N_HOST=your-domain.com \
  -e N8N_PORT=5678 \
  -e N8N_PROTOCOL=https \
  -e WEBHOOK_URL=https://your-domain.com \
  -v $(pwd)/n8n-data:/home/node/.n8n \
  n8nio/n8n
```

---

## 🚨 Устранение проблем

### Частые ошибки:

1. **"Workflow not found"**
   - Проверьте, что workflow сохранен и активен

2. **"Invalid credentials"**
   - Пересоздайте credentials
   - Проверьте права доступа

3. **"Webhook timeout"**
   - Увеличьте timeout в настройках
   - Оптимизируйте запросы к API

4. **"Google Sheets API quota exceeded"**
   - Добавьте задержки между запросами
   - Используйте batch операции

### Полезные команды:

```bash
# Перезапуск n8n
docker restart n8n

# Просмотр логов
docker logs -f n8n

# Очистка данных
rm -rf n8n-data/
```

---

## 📞 Поддержка

- **Документация n8n:** https://docs.n8n.io/
- **Community:** https://community.n8n.io/
- **GitHub:** https://github.com/n8n-io/n8n

Теперь ваша система резервирования товаров готова к работе! 🎉