# Домашнее задание к занятию «Введение в Terraform»

------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 

```
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding kreuzwerker/docker versions matching "~> 3.0.1"...
- Installing hashicorp/random v3.5.1...
- Installed hashicorp/random v3.5.1 (unauthenticated)
- Installing kreuzwerker/docker v3.0.2...
- Installed kreuzwerker/docker v3.0.2 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the
│ following providers:
│   - hashicorp/random
│   - kreuzwerker/docker
│
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail
│ to install these providers.
│
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?
```
# own secret vars store.
personal.auto.tfvars
```
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
```
"result": "HjK7Zl46dHIxay3S",
```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
```
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# terraform validate
╷
│ Error: Missing name for resource
│
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│
│ All resource blocks must have 2 labels (type, name).
╵
╷
│ Error: Invalid resource name
│
│   on main.tf line 29, in resource "docker_container" "1nginx":
│   29: resource "docker_container" "1nginx" {
│
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
```
В ошибке указано что в ресурсе docker_image указан тип но нет лейбла.

Далее в ресурсе docker_container допущена ошибка, имя лейбла начинается с цифры, что недопустимо. 

После исправления validate все равно не прошел.
```
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# terraform validate
╷
│ Error: Reference to undeclared resource
│
│   on main.tf line 31, in resource "docker_container" "nginx":
│   31:   name  = "example_${random_password.random_string_FAKE.resulT}"
│
│ A managed resource "random_password" "random_string_FAKE" has not been declared in the root module.
╵
```
В строке 31 идет обращение к ресурсу random_password и лейблу random_string_FAKE, а ранее в коде был задеклаирован random_string.

И явная ошибка, даже наверно просто опечатка, в конце resulT надо исправить на result.
```
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# terraform validate
Success! The configuration is valid.
```

5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
```
resource "docker_image" "nginx"{
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"
```

```
  Enter a value: yes

docker_image.nginx: Creating...
docker_image.nginx: Creation complete after 0s [id=sha256:eea7b3dcba7ee47c0d16a60cc85d2b977d166be3960541991f3e6294d795ed24nginx:latest]
docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 1s [id=90d1ea0a8cc787c086d0bdf01de97923eee0eade209b274d682640507882cddf]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
90d1ea0a8cc7   eea7b3dcba7e   "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   0.0.0.0:8000->80/tcp   example_HjK7Zl46dHIxay3S
```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. В качестве ответа дополнительно приложите вывод команды ```docker ps```.

```
docker_container.nginx: Destruction complete after 1s
╷
│ Error: Unable to create container: Error response from daemon: Conflict. The container name "/example_HjK7Zl46dHIxay3S" is already in use by container "90d1ea0a8cc787c086d0bdf01de97923eee0eade209b274d682640507882cddf". You have to remove (or rename) that container to be able to reuse that name.
│
│   with docker_container.hello_world,
│   on main.tf line 29, in resource "docker_container" "hello_world":
│   29: resource "docker_container" "hello_world" {
│
╵
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
Ключ -auto-approve разрешает без запроса на подтверждение создавать и разрушаеть ресурсы. Если бы я предварительно выполнил ```plan```, мог бы увидеть возможные проблемы. 
Такой себе вариант для смелых и бессмертных. 
В итоге я потерял конейнер docker_container.nginx и не был создан новый контейнер, на проде могло првиести к серьезным последствиям.

8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
```
  Enter a value: yes

random_password.random_string: Destroying... [id=none]
random_password.random_string: Destruction complete after 0s
docker_image.nginx: Destroying... [id=sha256:eea7b3dcba7ee47c0d16a60cc85d2b977d166be3960541991f3e6294d795ed24nginx:latest]
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src# cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.5.6",
  "serial": 10,
  "lineage": "53ff9938-f396-bb3d-2cc9-c5f0050d9549",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
9. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **обязательно** подкрепите строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )
```
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation
```

Параметр keep_locally  контролирует удаление образа из локальной репы docker при разрушении. 


------


### Задание 2*

1. Изучите в документации provider [**Virtualbox**](https://docs.comcloud.xyz/providers/shekeriev/virtualbox/latest/docs) от 
shekeriev.
2. Создайте с его помощью любую виртуальную машину. Чтобы не использовать VPN, советуем выбрать любой образ с расположением в GitHub из [**списка**](https://www.vagrantbox.es/).

В качестве ответа приложите plan для создаваемого ресурса и скриншот созданного в VB ресурса. 

```
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src/task2# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # virtualbox_vm.centsos7-vm will be created
  + resource "virtualbox_vm" "centsos7-vm" {
      + cpus   = 1
      + id     = (known after apply)
      + image  = "https://github.com/tommy-muehle/puppet-vagrant-boxes/releases/download/1.1.0/centos-7.0-x86_64.box"
      + memory = "1000 mib"
      + name   = "centos7"
      + status = "running"

      + network_adapter {
          + device                 = "IntelPro1000MTDesktop"
          + host_interface         = "vboxnet0"
          + ipv4_address           = (known after apply)
          + ipv4_address_available = (known after apply)
          + mac_address            = (known after apply)
          + status                 = (known after apply)
          + type                   = "hostonly"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + IPAddress = (known after apply)

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
```

```
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src/task2# vboxmanage list vms
"server1.netology" {178b3a37-7740-4801-b5ef-10ba7d9f4aa6}
"centos7" {676e0489-df53-4d7f-aa32-fbe401f29cca}
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src/task2#
root@t450s:/home/user1/devops-netology/ter-homeworks/01/src/task2# vboxmanage showvminfo "centos7"
Name:                        centos7
Encryption:     disabled
Groups:                      /
Guest OS:                    Other Linux (64-bit)
UUID:                        676e0489-df53-4d7f-aa32-fbe401f29cca
Config file:                 /root/.terraform/virtualbox/machine/centos7/centos7.vbox
Snapshot folder:             /root/.terraform/virtualbox/machine/centos7/Snapshots
Log folder:                  /root/.terraform/virtualbox/machine/centos7/Logs
Hardware UUID:               676e0489-df53-4d7f-aa32-fbe401f29cca
Memory size:                 1000MB
Page Fusion:                 disabled
VRAM size:                   20MB
CPU exec cap:                100%
HPET:                        disabled
CPUProfile:                  host
Chipset:                     piix3
Firmware:                    BIOS
Number of CPUs:              1
PAE:                         enabled
Long Mode:                   enabled
Triple Fault Reset:          disabled
APIC:                        enabled
X2APIC:                      disabled
Nested VT-x/AMD-V:           disabled
CPUID Portability Level:     0
CPUID overrides:             None
Boot menu mode:              disabled
Boot Device 1:               HardDisk
Boot Device 2:               Not Assigned
Boot Device 3:               Not Assigned
Boot Device 4:               Not Assigned
ACPI:                        enabled
IOAPIC:                      enabled
BIOS APIC mode:              APIC
Time offset:                 0ms
BIOS NVRAM File:             /root/.terraform/virtualbox/machine/centos7/centos7.nvram
RTC:                         UTC
Hardware Virtualization:     enabled
Nested Paging:               enabled
Large Pages:                 enabled
VT-x VPID:                   enabled
VT-x Unrestricted Exec.:     enabled
AMD-V Virt. Vmsave/Vmload:   enabled
IOMMU:                       None
Paravirt. Provider:          Default
Effective Paravirt. Prov.:   KVM
State:                       running (since 2023-09-17T09:10:01.683000000)
Graphics Controller:         VBoxVGA
Monitor count:               1
3D Acceleration:             disabled
2D Video Acceleration:       disabled
Teleporter Enabled:          disabled
Teleporter Port:             0
Teleporter Address:
Teleporter Password:
Tracing Enabled:             disabled
Allow Tracing to Access VM:  disabled
Tracing Configuration:
Autostart Enabled:           disabled
Autostart Delay:             0
Default Frontend:
VM process priority:         default
Storage Controllers:
#0: 'SATA', Type: IntelAhci, Instance: 0, Ports: 2 (max 30), Bootable
  Port 0, Unit 0: UUID: ec432395-ca03-49ec-bdd5-4435304d27a6
    Location: "/root/.terraform/virtualbox/machine/centos7/box-disk1.vmdk"
NIC 1:                       MAC: 0800278A0384, Attachment: Host-only Interface 'vboxnet0', Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: deny, Bandwidth group: none
NIC 2:                       disabled
NIC 3:                       disabled
NIC 4:                       disabled
NIC 5:                       disabled
NIC 6:                       disabled
NIC 7:                       disabled
NIC 8:                       disabled
Pointing Device:             PS/2 Mouse
Keyboard Device:             PS/2 Keyboard
UART 1:                      disabled
UART 2:                      disabled
UART 3:                      disabled
UART 4:                      disabled
LPT 1:                       disabled
LPT 2:                       disabled
Audio:                       enabled (Driver: Default, Controller: AC97, Codec: STAC9700)
Audio playback:              disabled
Audio capture:               disabled
Clipboard Mode:              disabled
Drag and drop Mode:          disabled
Session name:                headless
Video mode:                  720x400x0 at 0,0 enabled
VRDE:                        disabled
OHCI USB:                    disabled
EHCI USB:                    disabled
xHCI USB:                    disabled
USB Device Filters:          <none>
Available remote USB devices: <none>
Currently attached USB devices: <none>
Bandwidth groups:            <none>
Shared folders:              <none>
VRDE Connection:             not active
Clients so far:              0
Recording enabled:           no
Recording screens:           1
 Screen 0:
    Enabled:                 yes
    ID:                      0
    Record video:            yes
    Destination:             File
    File:                    /root/.terraform/virtualbox/machine/centos7/centos7-screen0.webm
    Options:                 vc_enabled=true,ac_enabled=false,ac_profile=med
    Video dimensions:        1024x768
    Video rate:              512kbps
    Video FPS:               25fps
* Guest:
Configured memory balloon:   0MB
OS type:                     Linux26_64
Additions run level:         2
Additions version:           4.3.28 r100309
Guest Facilities:
Facility "VirtualBox Base Driver": active/running (last update: 2023/09/17 09:10:09 UTC)
Facility "VirtualBox System Service": active/running (last update: 2023/09/17 09:10:10 UTC)
Facility "Seamless Mode": not active (last update: 2023/09/17 09:10:09 UTC)
Facility "Graphics Mode": not active (last update: 2023/09/17 09:10:09 UTC)
```



