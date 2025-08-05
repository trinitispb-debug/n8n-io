#!/bin/bash

# 🧪 Скрипт тестирования webhook системы резервирования

echo "🧪 Тестирование webhook системы резервирования товаров"
echo "====================================================="

# Проверяем параметры
if [ $# -eq 0 ]; then
    echo "💡 Использование: $0 <webhook_url>"
    echo "📝 Пример: $0 http://localhost:5678/webhook/inventory-reserve"
    echo ""
    echo "🔗 Или используйте стандартный URL для локального тестирования:"
    WEBHOOK_URL="http://localhost:5678/webhook/inventory-reserve"
else
    WEBHOOK_URL=$1
fi

echo "🌐 Тестируем URL: $WEBHOOK_URL"
echo ""

# Тест 1: Успешное резервирование
echo "✅ Тест 1: Успешное резервирование товара"
echo "----------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": "123",
    "quantity": 2,
    "customer_id": "456",
    "reserve_type": "order",
    "customer_name": "Иван Петров"
  }' \
  -w "\nHTTP Status: %{http_code}\nTime: %{time_total}s\n\n"

sleep 2

# Тест 2: Резервирование с большим количеством (может вызвать ошибку)
echo "⚠️  Тест 2: Резервирование большого количества"
echo "--------------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": "123",
    "quantity": 1000,
    "customer_id": "789",
    "reserve_type": "order",
    "customer_name": "Мария Сидорова"
  }' \
  -w "\nHTTP Status: %{http_code}\nTime: %{time_total}s\n\n"

sleep 2

# Тест 3: Некорректные данные
echo "❌ Тест 3: Некорректные данные"
echo "------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": "",
    "quantity": -5,
    "customer_id": "999"
  }' \
  -w "\nHTTP Status: %{http_code}\nTime: %{time_total}s\n\n"

sleep 2

# Тест 4: Отсутствующие поля
echo "🔍 Тест 4: Отсутствующие обязательные поля"
echo "----------------------------------------"
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 1
  }' \
  -w "\nHTTP Status: %{http_code}\nTime: %{time_total}s\n\n"

echo "🏁 Тестирование завершено!"
echo ""
echo "📊 Проверьте результаты в:"
echo "• n8n Executions (http://localhost:5678/executions)"
echo "• Google Sheets (если настроено логирование)"
echo "• Telegram уведомления (если настроены)"
echo ""
echo "🔧 Если есть ошибки, проверьте:"
echo "• Активен ли workflow в n8n"
echo "• Правильно ли настроены credentials"
echo "• Доступен ли API Битрикс24"