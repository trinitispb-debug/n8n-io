# 🚀 НАЧНИТЕ ЗДЕСЬ - Запуск системы резервирования товаров

## 📍 Где выполнить команды?

### Вариант 1: Терминал/Командная строка (Рекомендуется)

#### На Windows:
1. **Откройте PowerShell или Command Prompt**
   - Нажмите `Win + R`
   - Введите `cmd` или `powershell`
   - Нажмите Enter

2. **Перейдите в папку с файлами**
   ```cmd
   cd C:\path\to\your\files
   ```

3. **Для Windows используйте Docker или npm**
   ```cmd
   # Если есть Docker
   docker run -it --rm --name n8n -p 5678:5678 -v "%cd%\n8n-data:/home/node/.n8n" n8nio/n8n
   
   # Или через npm
   npm install n8n -g
   n8n start
   ```

#### На Mac/Linux:
1. **Откройте Terminal**
   - На Mac: `Cmd + Пробел` → введите "Terminal"
   - На Linux: `Ctrl + Alt + T`

2. **Перейдите в папку с файлами**
   ```bash
   cd /path/to/your/files
   ```

3. **Запустите скрипт**
   ```bash
   ./quick_start_commands.sh
   ```

### Вариант 2: Ручной запуск (если скрипт не работает)

#### Установка через Docker:
```bash
# Создайте папку для данных
mkdir n8n-data

# Запустите n8n
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=n8n123 \
  -v $(pwd)/n8n-data:/home/node/.n8n \
  n8nio/n8n
```

#### Установка через npm:
```bash
# Установите n8n
npm install n8n -g

# Запустите
n8n start
```

### Вариант 3: n8n Cloud (Самый простой)
1. **Перейдите на** https://n8n.cloud
2. **Создайте аккаунт** (есть бесплатный план)
3. **Пропустите установку** - сразу переходите к импорту workflow

---

## 🎯 Пошаговый план действий:

### ШАГ 1: Скачайте файлы
Скачайте эти файлы на свой компьютер:
- `n8n_workflow_examples.json`
- `n8n_setup_guide.md`
- `quick_start_commands.sh` (для Mac/Linux)

### ШАГ 2: Запустите n8n
Выберите один из способов выше

### ШАГ 3: Откройте браузер
Перейдите на http://localhost:5678
- Логин: `admin`
- Пароль: `n8n123`

### ШАГ 4: Импортируйте workflow
1. В n8n нажмите **"+" → "Import from file"**
2. Выберите файл `n8n_workflow_examples.json`
3. Импортируйте все workflow

---

## 🔧 Если возникли проблемы:

### Проблема: "Команда не найдена"
**Решение:** Используйте прямые команды Docker или npm

### Проблема: "Порт 5678 занят"
**Решение:** Измените порт
```bash
docker run -it --rm --name n8n -p 5679:5678 n8nio/n8n
# Тогда откройте http://localhost:5679
```

### Проблема: "Docker не установлен"
**Решение:** 
1. Скачайте Docker с https://docker.com
2. Или используйте npm установку

### Проблема: "npm не найден"
**Решение:**
1. Установите Node.js с https://nodejs.org
2. Или используйте n8n Cloud

---

## 📞 Быстрая помощь:

### Самый простой способ (без установки):
1. Идите на https://n8n.cloud
2. Регистрируйтесь
3. Импортируйте workflow из файла

### Если ничего не работает:
Напишите мне, какая у вас операционная система и что именно не получается - помогу настроить!

---

## 🎉 После запуска n8n:

1. **Откройте** http://localhost:5678 (или ваш n8n.cloud URL)
2. **Импортируйте** файл `n8n_workflow_examples.json`
3. **Настройте** credentials (Битрикс24, Google Sheets, Telegram)
4. **Активируйте** workflow
5. **Тестируйте** систему

**Готово!** Ваша система резервирования товаров будет работать! 🚀