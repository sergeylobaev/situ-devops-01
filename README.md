# situ-devops-01 Лаб 1. Скрипт запроса погоды

Скрипт получает текущую погоду через API Open-Meteo и генерирует HTML-страницу с информацией о температуре, влажности и скорости ветра.

Для запуска сервиса на Ubuntu 24.04 установить пакеты
```
sudo apt install -y curl jq nginx
```
Склонировать репозиторий и выдать права на запуск
```
git clone https://github.com/sergeylobaev/situ-devops-01.git
chmod +x situ-devops-01/weather.sh
sudo mv situ-devops-01 /opt/
```
Добавить задачу в крон для запуса каждую минуту
```
(sudo crontab -l 2>/dev/null; echo "* * * * * /opt/situ-devops-01/weather.sh Perm") | sudo crontab -
```
После запуска скрипта HTML-страница будет доступна по адресу
```
http://SERVER_IP/
```

<img width="746" height="675" alt="image" src="https://github.com/user-attachments/assets/c12e9a5c-2e6f-48a6-9515-3f1294370865" />
