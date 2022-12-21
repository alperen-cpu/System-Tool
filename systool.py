import os
import subprocess

def show_menu():
    print("---------------------------")
    print(" Ana Menü ")
    print("---------------------------")
    print("1. İşletim Sistemi Bilgisi")
    print("2. Ram Bilgisi")
    print("3. Disk Bilgisi")
    print("4. Docker Kur")
    print("5. Yazılım Paketlerini Kur")
    print("6. Çıkış")

def os_info():
    print("İşletim Sistemi Bilgisi:", os.uname().sysname)
    print("Sürüm Bilgisi:", os.uname().release)

def mem_info():
    print("Boş ve kullanılan Ram:")
    result = subprocess.run(["free", "-m"], stdout=subprocess.PIPE)
    print(result.stdout.decode())

def disk_info():
    print("Disk Kullanım Bilgisi:")
    result = subprocess.run(["df", "-H"], stdout=subprocess.PIPE)
    print(result.stdout.decode())

def docker_setup():
    subprocess.run(["apt-get", "install", "ca-certificates", "curl", "gnupg", "lsb-release", "-y"])
    subprocess.run(["mkdir", "-p", "/etc/apt/keyrings"])
    subprocess.run(["curl", "-fsSL", "https://download.docker.com/linux/debian/gpg", "|", "sudo", "gpg", "--dearmor", "-o", "/etc/apt/keyrings/docker.gpg"])
    subprocess.run(["echo",
                    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian",
                    "$(lsb_release -cs) stable",
                    "|", "sudo", "tee", "/etc/apt/sources.list.d/docker.list", ">", "/dev/null"])
    subprocess.run(["apt-get", "update", "&&", "apt-get", "install", "docker-ce", "docker-ce-cli", "containerd.io", "docker-compose-plugin", "-y"])
    result = subprocess.run(["docker", "--version"], stdout=subprocess.PIPE)
    print("Docker Sürümü:", result.stdout.decode())


def software_setup():
    while True:
        print("1. PHP Kur")
        print("2. NodeJS Kur")
        print("3. Çıkış")
        choice = input("Seçiminizi yapınız: ")
        if choice == "1":
            version = input("Lütfen PHP sürümünü giriniz: ")
            subprocess.run(["apt-get", "install", f"php{version}"])
        elif choice == "2":
            version = input("Lütfen NodeJS sürümünü giriniz: ")
            subprocess.run(["apt-get", "install", f"nodejs={version}"])
        elif choice == "3":
            break
        else:
            print("Geçersiz seçim")

while True:
    show_menu()
    choice = input("Seçiminizi yapınız: ")
    if choice == "1":
        os_info()
    elif choice == "2":
        mem_info()
    elif choice == "3":
        disk_info()
    elif choice == "4":
        docker_setup()
    elif choice == "5":
        software_setup()
    elif choice == "6":
        break
    else:
        print("Geçersiz seçim")
