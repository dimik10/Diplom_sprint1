# Diplom_sprint1

Спринт 1

ЗАДАЧА

```
Опишите инфраструктуру будущего проекта в виде кода с инструкциями по развертке, нужен кластер Kubernetes и служебный сервер (будем называть его srv):

1 Выбираем облачный провайдер и инфраструктуру.
В качестве облака подойдет и Яндекс.Облако, но можно использовать любое другое по желанию.
Нам нужно три сервера:
два сервера в одном кластере Kubernetes: 1 master и 1 app;
сервер srv для инструментов мониторинга, логгирования и сборок контейнеров.

2 Описываем инфраструктуру.
Описывать инфраструктуру мы будем, конечно, в Terraform.
Совет: лучше создать под наши конфигурации отдельную группу проектов в Git, например, devops.
Пишем в README.md инструкцию по развертке конфигураций в облаке. Никаких секретов в коде быть не должно.

3 Автоматизируем установку.
Надо реализовать возможность установки на сервер всех необходимых нам настроек и пакетов, будь то docker-compose, gitlab-runner или наши публичные ключи для доступа по SSH. Положите код автоматизации в Git-репозиторий.
Результат должен быть такой, чтобы после запуска подобной автоматизации на сервере устанавливалось почти всё, что нужно.

Совсем полностью исключать ручные действия не надо, но в таком случае их надо описать в том же README.md и положить в репозиторий.
```

Решение задачи:

С помощью terraform запускаем создание инфраструктуры и устанавливаем сервера, сети, и пост инсталл установка программ:
  - Запускаем развертывание серверов srv,master,app(количество сервером регулируется через переменные в terraform):
  ```
  terraform apply
  ```
  - В процессе установки создаётся 3 ВМ, сети, сервер srv подготавливается через provisioning-скрипт(для этого собирается конфиг инвентаризации для ansible с промощью программы terraform-inventory) - ставятся необходимые утилиты:
    jq, docker, docker-compose, git, через запуск ansible роли

  - Устанавливается окружение для будущего разворачивания k8s кластера, согласно requirements версии 2.9.
    для этого скачивается локально(т.к. в описании задачи явно не указано, что запуск должен происходить с сервера srv(сервер srv для инструментов мониторинга, логгирования и сборок контейнеров.))
    Подкладываем ключи, даём разрешения. Для инвентаризации ansible(установка k8s) был написан скрипт который парсит строки из файла terraform.tfstate

  - Возможно как ручное так же и автоматическое равзвёртывание кластера kubernetes, для этого комментируем или расскоментируем строки в provision
    файле. Проверялоась автоматическая и ручная установка.

Результаты выполнения запуска инфраструктуры и кластера k8s:
