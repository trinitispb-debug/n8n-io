#!/bin/bash

# 🚀 Скрипт быстрого запуска n8n для системы резервирования товаров

echo "🔧 Настройка системы резервирования товаров n8n + Битрикс24"
echo "============================================================"

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Устанавливаем через npm..."
    
    # Проверяем Node.js
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js не установлен. Установите Node.js сначала:"
        echo "https://nodejs.org/"
        exit 1
    fi
    
    # Устанавливаем n8n через npm
    echo "📦 Устанавливаем n8n..."
    npm install n8n -g
    
    echo "🚀 Запускаем n8n..."
    n8n start
else
    echo "✅ Docker найден. Запускаем n8n в контейнере..."
    
    # Создаем директорию для данных
    mkdir -p n8n-data
    
    # Запускаем n8n в Docker
    echo "🐳 Запускаем Docker контейнер..."
    docker run -it --rm \
        --name n8n \
        -p 5678:5678 \
        -e N8N_BASIC_AUTH_ACTIVE=true \
        -e N8N_BASIC_AUTH_USER=admin \
        -e N8N_BASIC_AUTH_PASSWORD=n8n123 \
        -e WEBHOOK_URL=http://localhost:5678 \
        -v $(pwd)/n8n-data:/home/node/.n8n \
        n8nio/n8n
fi

echo ""
echo "🎉 n8n запущен!"
echo "📱 Откройте браузер: http://localhost:5678"
echo "👤 Логин: admin"
echo "🔑 Пароль: n8n123"
echo ""
echo "📋 Следующие шаги:"
echo "1. Импортируйте workflow из файла n8n_workflow_examples.json"
echo "2. Настройте credentials (Google Sheets, Telegram, Битрикс24)"
echo "3. Замените placeholder значения на реальные"
echo "4. Протестируйте workflow"
echo "5. Активируйте workflow"
echo ""
echo "📖 Подробная инструкция в файле: n8n_setup_guide.md"