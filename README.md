# devops-netology
first line readme modify

#Игонор в скрытом terraform в текущем каталоге и все что ниже
**/.terraform/*

# Файлы с окончанием tfstate и далее по маске
*.tfstate
*.tfstate.*

# краш логи
crash.log
crash.*.log

# игнор всех файлов с окончанием tfvars и .tfvars.json

*.tfvars
*.tfvars.json

# Два конктерно указанных файла и по маске
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Здесь должна была быть инверсия

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# в игнор идут конфиг файлы rc
.terraformrc
terraform.rc

#Забыл коммент Added gitignore

Add NEW LINE 

